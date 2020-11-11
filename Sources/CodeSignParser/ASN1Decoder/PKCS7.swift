//
// Created by Mengyu Li on 2020/8/24.
//

import Foundation

public struct PKCS7 {
    let derData: Data
    let asn1: [ASN1Object]
    let mainBlock: ASN1Object

    public init(data: Data) throws {
        derData = data
        asn1 = try ASN1DERDecoder.decode(data: derData)

        guard let firstBlock = asn1.first,
              let mainBlock = firstBlock.sub(1)?.sub(0)
        else {
            throw PKCS7Error.parseError
        }

        self.mainBlock = mainBlock

        guard firstBlock.sub(0)?.value as? String == OID.pkcs7signedData.rawValue else {
            throw PKCS7Error.notSupported
        }
    }
}

public extension PKCS7 {
    var digestAlgorithm: String? {
        if let block = mainBlock.sub(1) {
            return firstLeafValue(block: block) as? String
        }
        return nil
    }

    var digestAlgorithmName: String? {
        OID.description(of: digestAlgorithm ?? "") ?? digestAlgorithm
    }

    var certificate: X509Certificate? {
        mainBlock.sub(3)?.sub?.first.map { try? X509Certificate(asn1: $0) } ?? nil
    }

    var certificates: [X509Certificate] {
        mainBlock.sub(3)?.sub?.compactMap { try? X509Certificate(asn1: $0) } ?? []
    }

    var data: Data? {
        if let block = mainBlock.findOid(.pkcs7data) {
            if let dataBlock = block.parent?.sub?.last {
                var out = Data()
                if let value = dataBlock.value as? Data {
                    out.append(value)
                } else if dataBlock.value is String, let rawValue = dataBlock.rawValue {
                    out.append(rawValue)
                } else {
                    for sub in dataBlock.sub ?? [] {
                        if let value = sub.value as? Data {
                            out.append(value)
                        } else if sub.value is String, let rawValue = sub.rawValue {
                            out.append(rawValue)
                        } else {
                            for sub2 in sub.sub ?? [] {
                                if let value = sub2.rawValue {
                                    out.append(value)
                                }
                            }
                        }
                    }
                }
                return out.count > 0 ? out : nil
            }
        }
        return nil
    }
}
