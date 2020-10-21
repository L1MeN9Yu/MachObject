//
// Created by Mengyu Li on 2020/8/24.
//

import Foundation

public struct X509PublicKey {
    let pkBlock: ASN1Object

    init(pkBlock: ASN1Object) {
        self.pkBlock = pkBlock
    }
}

public extension X509PublicKey {
    var algOid: String? {
        pkBlock.sub(0)?.sub(0)?.value as? String
    }

    var algName: String? {
        OID.description(of: algOid ?? "")
    }

    var algParams: String? {
        pkBlock.sub(0)?.sub(1)?.value as? String
    }

    var key: Data? {
        guard
            let algOid = algOid,
            let oid = OID(rawValue: algOid),
            let keyData = pkBlock.sub(1)?.value as? Data
        else {
            return nil
        }

        switch oid {
        case .ecPublicKey:
            return keyData

        case .rsaEncryption:
            guard let publicKeyAsn1Objects = (try? ASN1DERDecoder.decode(data: keyData)) else {
                return nil
            }
            guard let publicKeyModulus = publicKeyAsn1Objects.first?.sub(0)?.value as? Data else {
                return nil
            }
            return publicKeyModulus

        default:
            return nil
        }
    }
}
