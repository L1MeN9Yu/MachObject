//
// Created by Mengyu Li on 2020/8/5.
//

import Foundation

extension SwiftMeta {
    struct ProtocolType {
        let raw: ProtocolDescriptor
        let offset: Int
        let name: String
        let associatedTypeNames: String
        let flag: Set<Flag>

        init(raw: ProtocolDescriptor, offset: Int, name: String, associatedTypeNames: String) {
            self.raw = raw
            self.offset = offset
            self.name = name
            self.associatedTypeNames = associatedTypeNames
            flag = Set<Flag>(rawValue: Int(raw.flags))
        }
    }
}

extension SwiftMeta.ProtocolType {
    /// https://github.com/apple/swift/blob/master/include/swift/ABI/MetadataValues.h `class ProtocolDescriptorFlags`
    enum Flag {
        case isSwift
        case classConstraint
        case dispatchStrategyMask
        case dispatchStrategyShift
        case specialProtocolMask
        case specialProtocolShift
        case isResilient
        case objCReserved
    }
}

extension SwiftMeta.ProtocolType.Flag: Option {
    var value: Int {
        switch self {
        case .isSwift:
            return 1 << 0
        case .classConstraint:
            return 1 << 1
        case .dispatchStrategyMask:
            return 0xF << 2
        case .dispatchStrategyShift:
            return 2
        case .specialProtocolMask:
            return 0x0000_03C0
        case .specialProtocolShift:
            return 6
        case .isResilient:
            return 1 << 10
        case .objCReserved:
            return 0xFFFF_0000
        }
    }
}

extension SwiftMeta.ProtocolType.Flag: CustomStringConvertible {
    public var description: String {
        switch self {
        case .isSwift:
            return "IsSwift"
        case .classConstraint:
            return "ClassConstraint"
        case .dispatchStrategyMask:
            return "DispatchStrategyMask"
        case .dispatchStrategyShift:
            return "DispatchStrategyShift"
        case .specialProtocolMask:
            return "SpecialProtocolMask"
        case .specialProtocolShift:
            return "SpecialProtocolShift"
        case .isResilient:
            return "IsResilient"
        case .objCReserved:
            return "_ObjCReserved"
        }
    }
}
