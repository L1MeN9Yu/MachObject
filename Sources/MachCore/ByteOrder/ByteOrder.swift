//
// Created by Mengyu Li on 2020/8/24.
//

import Foundation

public enum ByteOrder {
    case little
    case big
}

public extension ByteOrder {
    static let current: Self = {
        switch 0x123456.bigEndian == 0x123456 {
        case true:
            return big
        case false:
            return little
        }
    }()
}
