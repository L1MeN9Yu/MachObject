//
// Created by Mengyu Li on 2020/8/24.
//

import Foundation

extension X509Extension {
    // Used for SubjectAltName and IssuerAltName
    // Every name can be one of these subtype:
    //  - otherName      [0] INSTANCE OF OTHER-NAME,
    //  - rfc822Name     [1] IA5String,
    //  - dNSName        [2] IA5String,
    //  - x400Address    [3] ORAddress,
    //  - directoryName  [4] Name,
    //  - ediPartyName   [5] EDIPartyName,
    //  - uniformResourceIdentifier [6] IA5String,
    //  - IPAddress      [7] OCTET STRING,
    //  - registeredID   [8] OBJECT IDENTIFIER
    //
    // Result does not support: x400Address, directoryName and ediPartyName
    //
    var alternativeNameAsStrings: [String] {
        var result: [String] = []
        for item in block.sub?.last?.sub?.last?.sub ?? [] {
            guard let nameType = item.identifier?.tagNumber.rawValue else {
                continue
            }
            switch nameType {
            case 0:
                if let name = item.sub?.last?.sub?.last?.value as? String {
                    result.append(name)
                }
            case 1, 2, 6:
                if let name = item.value as? String {
                    result.append(name)
                }
            case 7:
                if let ip = item.value as? Data {
                    result.append(ip.map { "\($0)" }.joined(separator: "."))
                }
            case 8:
                if let value = item.value as? String, var data = value.data(using: .utf8) {
                    let oid = ASN1DERDecoder.decodeOid(contentData: &data)
                    result.append(oid)
                }
            default:
                break
            }
        }
        return result
    }
}
