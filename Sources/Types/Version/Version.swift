//
// Created by Mengyu Li on 2020/7/27.
//

import Foundation

public struct Version {
    public let major: UInt
    public let minor: UInt
    public let patch: UInt

    init(machVersion: uint32) {
        major = UInt((machVersion & 0xFFFF_0000) >> 16)
        minor = UInt((machVersion & 0x0000_FF00) >> 16)
        patch = UInt((machVersion & 0x0000_00FF) >> 16)
    }
}

extension Version: CustomStringConvertible {
    public var description: String { "\(major).\(minor).\(patch)" }
}
