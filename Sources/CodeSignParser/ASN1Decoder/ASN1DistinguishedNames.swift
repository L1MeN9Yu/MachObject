//
// Created by Mengyu Li on 2020/8/24.
//

public struct ASN1DistinguishedNames {
    public let oid: String
    public let representation: String

    init(oid: String, representation: String) {
        self.oid = oid
        self.representation = representation
    }
}

public extension ASN1DistinguishedNames {
    static let commonName = ASN1DistinguishedNames(oid: "2.5.4.3", representation: "CN")
    static let dnQualifier = ASN1DistinguishedNames(oid: "2.5.4.46", representation: "DNQ")
    static let serialNumber = ASN1DistinguishedNames(oid: "2.5.4.5", representation: "SERIALNUMBER")
    static let givenName = ASN1DistinguishedNames(oid: "2.5.4.42", representation: "GIVENNAME")
    static let surname = ASN1DistinguishedNames(oid: "2.5.4.4", representation: "SURNAME")
    static let organizationalUnitName = ASN1DistinguishedNames(oid: "2.5.4.11", representation: "OU")
    static let organizationName = ASN1DistinguishedNames(oid: "2.5.4.10", representation: "O")
    static let streetAddress = ASN1DistinguishedNames(oid: "2.5.4.9", representation: "STREET")
    static let localityName = ASN1DistinguishedNames(oid: "2.5.4.7", representation: "L")
    static let stateOrProvinceName = ASN1DistinguishedNames(oid: "2.5.4.8", representation: "ST")
    static let countryName = ASN1DistinguishedNames(oid: "2.5.4.6", representation: "C")
    static let email = ASN1DistinguishedNames(oid: "1.2.840.113549.1.9.1", representation: "E")
}
