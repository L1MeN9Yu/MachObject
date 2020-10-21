//
// Created by Mengyu Li on 2020/8/24.
//

import Foundation

public struct X509Extension {
    let block: ASN1Object

    init(block: ASN1Object) {
        self.block = block
    }
}

public extension X509Extension {
    var oid: String? {
        block.sub(0)?.value as? String
    }

    var name: String? {
        OID.description(of: oid ?? "")
    }

    var isCritical: Bool {
        if block.sub?.count ?? 0 > 2 {
            return block.sub(1)?.value as? Bool ?? false
        }
        return false
    }

    var value: Any? {
        if let valueBlock = block.sub?.last {
            return firstLeafValue(block: valueBlock)
        }
        return nil
    }
}

extension X509Extension {
    var valueAsBlock: ASN1Object? {
        block.sub?.last
    }

    var valueAsStrings: [String] {
        var result: [String] = []
        for item in block.sub?.last?.sub?.last?.sub ?? [] {
            if let name = item.value as? String {
                result.append(name)
            }
        }
        return result
    }
}
