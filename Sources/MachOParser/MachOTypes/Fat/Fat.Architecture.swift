//
// Created by Mengyu Li on 2020/7/24.
//

import Foundation
@_implementationOnly import MachCore
import MachO

public extension Fat {
    enum Architecture {
        case _32(_32_)
        case _64(_64_)
    }
}

public extension Fat.Architecture {
    var mach: Mach {
        switch self {
        case let ._32(content):
            return content.mach
        case let ._64(content):
            return content.mach
        }
    }

    var offset: UInt64 {
        switch self {
        case let ._32(content):
            return UInt64(content.offset)
        case let ._64(content):
            return content.offset
        }
    }
}
