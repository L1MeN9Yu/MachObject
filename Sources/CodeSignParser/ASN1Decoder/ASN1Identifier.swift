//
// Created by Mengyu Li on 2020/8/24.
//

import Foundation

public struct ASN1Identifier {
    let rawValue: UInt8

    init(rawValue: UInt8) {
        self.rawValue = rawValue
    }
}

public extension ASN1Identifier {
    var typeClass: Class {
        for tc in [Class.application, Class.contextSpecific, Class.private] where (rawValue & tc.rawValue) == tc.rawValue {
            return tc
        }
        return .universal
    }

    var isPrimitive: Bool {
        (rawValue & 0x20) == 0
    }

    var isConstructed: Bool {
        (rawValue & 0x20) != 0
    }

    var tagNumber: TagNumber {
        TagNumber(rawValue: rawValue & 0x1F) ?? .endOfContent
    }
}

extension ASN1Identifier: CustomStringConvertible {
    public var description: String {
        if typeClass == .universal {
            return String(describing: tagNumber)
        } else {
            return "\(typeClass)(\(tagNumber.rawValue))"
        }
    }
}
