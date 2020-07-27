//
// Created by Mengyu Li on 2020/7/27.
//

import Foundation
import MachO

public struct VersionMinIphoneosLC: LoadCommand {
    public static let id: UInt32 = UInt32(LC_VERSION_MIN_IPHONEOS)

    public let version: Version
    public let sdk: Version

    public init(machData: Data, offset: Int) {
        let command: version_min_command = machData.get(atOffset: offset)
        version = Version(machVersion: command.version)
        sdk = Version(machVersion: command.sdk)
    }
}
