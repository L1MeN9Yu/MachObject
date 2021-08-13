//
// Created by Mengyu Li on 2020/8/24.
//

import Foundation

public class X509Certificate {
    private let asn1: [ASN1Object]
    private let block1: ASN1Object

    private static let beginPemBlock = "-----BEGIN CERTIFICATE-----"
    private static let endPemBlock = "-----END CERTIFICATE-----"

    enum X509BlockPosition: Int {
        case version = 0
        case serialNumber = 1
        case signatureAlg = 2
        case issuer = 3
        case dateValidity = 4
        case subject = 5
        case publicKey = 6
        case extensions = 7
    }

    public convenience init(data: Data) throws {
        if String(data: data, encoding: .utf8)?.contains(X509Certificate.beginPemBlock) ?? false {
            try self.init(pem: data)
        } else {
            try self.init(der: data)
        }
    }

    public init(der: Data) throws {
        asn1 = try ASN1DERDecoder.decode(data: der)
        guard asn1.count > 0,
              let block1 = asn1.first?.sub(0)
        else {
            throw ASN1Error.parseError
        }

        self.block1 = block1
    }

    public convenience init(pem: Data) throws {
        guard let derData = X509Certificate.decodeToDER(pem: pem) else {
            throw ASN1Error.parseError
        }

        try self.init(der: derData)
    }

    init(asn1: ASN1Object) throws {
        guard let block1 = asn1.sub(0) else { throw ASN1Error.parseError }

        self.asn1 = [asn1]
        self.block1 = block1
    }

    /// Checks that the given date is within the certificate's validity period.
    public func checkValidity(_ date: Date = Date()) -> Bool {
        if let notBefore = notBefore, let notAfter = notAfter {
            return date > notBefore && date < notAfter
        }
        return false
    }

    /// Gets the version (version number) value from the certificate.
    public var version: Int? {
        if let v = firstLeafValue(block: block1) as? Data, let index = v.uint64 {
            return Int(index) + 1
        }
        return nil
    }

    /// Gets the serialNumber value from the certificate.
    public var serialNumber: Data? {
        block1[X509BlockPosition.serialNumber]?.value as? Data
    }

    /// Returns the issuer (issuer distinguished name) value from the certificate as a String.
    public var issuerDistinguishedName: String? {
        if let issuerBlock = block1[X509BlockPosition.issuer] {
            return blockDistinguishedName(block: issuerBlock)
        }
        return nil
    }

    public var issuerOIDs: [String] {
        var result: [String] = []
        if let subjectBlock = block1[X509BlockPosition.issuer] {
            for sub in subjectBlock.sub ?? [] {
                if let value = firstLeafValue(block: sub) as? String {
                    result.append(value)
                }
            }
        }
        return result
    }

    public func issuer(oid: String) -> String? {
        if let subjectBlock = block1[X509BlockPosition.issuer] {
            if let oidBlock = subjectBlock.findOid(oid) {
                return oidBlock.parent?.sub?.last?.value as? String
            }
        }
        return nil
    }

    public func issuer(dn: ASN1DistinguishedNames) -> String? {
        issuer(oid: dn.oid)
    }

    /// Returns the subject (subject distinguished name) value from the certificate as a String.
    public var subjectDistinguishedName: String? {
        if let subjectBlock = block1[X509BlockPosition.subject] {
            return blockDistinguishedName(block: subjectBlock)
        }
        return nil
    }

    public var subjectOIDs: [String] {
        var result: [String] = []
        if let subjectBlock = block1[X509BlockPosition.subject] {
            for sub in subjectBlock.sub ?? [] {
                if let value = firstLeafValue(block: sub) as? String {
                    result.append(value)
                }
            }
        }
        return result
    }

    public func subject(oid: String) -> String? {
        if let subjectBlock = block1[X509BlockPosition.subject] {
            if let oidBlock = subjectBlock.findOid(oid) {
                return oidBlock.parent?.sub?.last?.value as? String
            }
        }
        return nil
    }

    public func subject(dn: ASN1DistinguishedNames) -> String? {
        subject(oid: dn.oid)
    }

    /// Gets the notBefore date from the validity period of the certificate.
    public var notBefore: Date? {
        block1[X509BlockPosition.dateValidity]?.sub(0)?.value as? Date
    }

    /// Gets the notAfter date from the validity period of the certificate.
    public var notAfter: Date? {
        block1[X509BlockPosition.dateValidity]?.sub(1)?.value as? Date
    }

    /// Gets the signature value (the raw signature bits) from the certificate.
    public var signature: Data? {
        asn1[0].sub(2)?.value as? Data
    }

    /// Gets the signature algorithm name for the certificate signature algorithm.
    public var sigAlgName: String? {
        OID.description(of: sigAlgOID ?? "")
    }

    /// Gets the signature algorithm OID string from the certificate.
    public var sigAlgOID: String? {
        block1.sub(2)?.sub(0)?.value as? String
    }

    /// Gets the DER-encoded signature algorithm parameters from this certificate's signature algorithm.
    public var sigAlgParams: Data? {
        nil
    }

    /**
     Gets a boolean array representing bits of the KeyUsage extension, (OID = 2.5.29.15).
     ```
     KeyUsage ::= BIT STRING {
     digitalSignature        (0),
     nonRepudiation          (1),
     keyEncipherment         (2),
     dataEncipherment        (3),
     keyAgreement            (4),
     keyCertSign             (5),
     cRLSign                 (6),
     encipherOnly            (7),
     decipherOnly            (8)
     }
     ```
     */
    public var keyUsage: [Bool] {
        var result: [Bool] = []
        if let oidBlock = block1.findOid(OID.keyUsage) {
            let data = oidBlock.parent?.sub?.last?.sub(0)?.value as? Data
            let bits: UInt8 = data?.first ?? 0
            for index in 0...7 {
                let value = bits & UInt8(1 << index) != 0
                result.insert(value, at: 0)
            }
        }
        return result
    }

    /// Gets a list of Strings representing the OBJECT IDENTIFIERs of the ExtKeyUsageSyntax field of
    /// the extended key usage extension, (OID = 2.5.29.37).
    public var extendedKeyUsage: [String] {
        extensionObject(oid: OID.extKeyUsage)?.valueAsStrings ?? []
    }

    /// Gets a collection of subject alternative names from the SubjectAltName extension, (OID = 2.5.29.17).
    public var subjectAlternativeNames: [String] {
        extensionObject(oid: OID.subjectAltName)?.alternativeNameAsStrings ?? []
    }

    /// Gets a collection of issuer alternative names from the IssuerAltName extension, (OID = 2.5.29.18).
    public var issuerAlternativeNames: [String] {
        extensionObject(oid: OID.issuerAltName)?.alternativeNameAsStrings ?? []
    }

    /// Gets the information of the public key from this certificate.
    public var publicKey: X509PublicKey? {
        block1[X509BlockPosition.publicKey].map(X509PublicKey.init)
    }

    /// Get a list of critical extension OID codes
    public var criticalExtensionOIDs: [String] {
        guard let extensionBlocks = extensionBlocks else { return [] }
        return extensionBlocks
            .map { X509Extension(block: $0) }
            .filter(\.isCritical)
            .compactMap(\.oid)
    }

    /// Get a list of non critical extension OID codes
    public var nonCriticalExtensionOIDs: [String] {
        guard let extensionBlocks = extensionBlocks else { return [] }
        return extensionBlocks
            .map { X509Extension(block: $0) }
            .filter { !$0.isCritical }
            .compactMap(\.oid)
    }

    private var extensionBlocks: [ASN1Object]? {
        block1[X509BlockPosition.extensions]?.sub(0)?.sub
    }

    /// Gets the extension information of the given OID enum.
    public func extensionObject(oid: OID) -> X509Extension? {
        extensionObject(oid: oid.rawValue)
    }

    /// Gets the extension information of the given OID code.
    public func extensionObject(oid: String) -> X509Extension? {
        block1[X509BlockPosition.extensions]?
            .findOid(oid)?
            .parent
            .map(X509Extension.init)
    }

    // Format subject/issuer information in RFC1779
    private func blockDistinguishedName(block: ASN1Object) -> String {
        var result = ""
        let oidNames: [ASN1DistinguishedNames] = [
            .commonName,
            .dnQualifier,
            .serialNumber,
            .givenName,
            .surname,
            .organizationalUnitName,
            .organizationName,
            .streetAddress,
            .localityName,
            .stateOrProvinceName,
            .countryName,
            .email,
        ]
        for oidName in oidNames {
            if let oidBlock = block.findOid(oidName.oid) {
                if !result.isEmpty {
                    result.append(", ")
                }
                result.append(oidName.representation)
                result.append("=")
                if let value = oidBlock.parent?.sub?.last?.value as? String {
                    let specialChar = ",+=\n<>#;\\"
                    let quote = value.contains(where: { specialChar.contains($0) }) ? "\"" : ""
                    result.append(quote)
                    result.append(value)
                    result.append(quote)
                }
            }
        }
        return result
    }

    // read possible PEM encoding
    private static func decodeToDER(pem pemData: Data) -> Data? {
        if
            let pem = String(data: pemData, encoding: .ascii),
            pem.contains(beginPemBlock)
        {
            let lines = pem.components(separatedBy: .newlines)
            var base64buffer = ""
            var certLine = false
            for line in lines {
                if line == endPemBlock {
                    certLine = false
                }
                if certLine {
                    base64buffer.append(line)
                }
                if line == beginPemBlock {
                    certLine = true
                }
            }
            if let derDataDecoded = Data(base64Encoded: base64buffer) {
                return derDataDecoded
            }
        }

        return nil
    }
}

extension X509Certificate: CustomStringConvertible {
    public var description: String {
        asn1.reduce("") { $0 + "\($1.description)\n" }
    }
}

func firstLeafValue(block: ASN1Object) -> Any? {
    if let sub = block.sub?.first {
        return firstLeafValue(block: sub)
    }
    return block.value
}

extension ASN1Object {
    subscript(index: X509Certificate.X509BlockPosition) -> ASN1Object? {
        guard let sub = sub,
              sub.indices.contains(index.rawValue) else { return nil }
        return sub[index.rawValue]
    }
}
