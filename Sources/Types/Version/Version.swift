//
// Created by Mengyu Li on 2020/7/27.
//

import Foundation

public struct Version {
    public let major: UInt
    public let minor: UInt
    public let patch: UInt

    init(machVersion: uint32) {
        major = UInt((machVersion & 0xFFFF0000) >> 16)
        minor = UInt((machVersion & 0x0000FF00) >> 16)
        patch = UInt((machVersion & 0x000000FF) >> 16)
    }
}
