//
// Created by Mengyu Li on 2020/7/27.
//

import Foundation
import MachO

public struct VersionMinIphoneosLC: LoadCommand {
    public static let id = UInt32(LC_VERSION_MIN_IPHONEOS)

    public let version: Version
    public let sdk: Version

    public init(machData: Data, offset: Int) {
        let command: version_min_command = machData.get(atOffset: offset)
        self.init(command: command)
    }

    public init(pointer: UnsafeRawPointer) {
        let command: version_min_command = pointer.get()
        self.init(command: command)
    }
}

private extension VersionMinIphoneosLC {
    init(command: version_min_command) {
        version = Version(machVersion: command.version)
        sdk = Version(machVersion: command.sdk)
    }
}
