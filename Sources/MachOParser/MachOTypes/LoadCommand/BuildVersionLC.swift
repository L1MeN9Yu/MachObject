//
// Created by Mengyu Li on 2020/7/28.
//

import Foundation
import MachO

public struct BuildVersionLC: LoadCommand {
    public static let id = UInt32(LC_BUILD_VERSION)
    public let platform: Platform
    public let minos: Version
    public let sdk: Version
    public let buildToolVersions: [BuildToolVersion]

    public init(machData: Data, offset: Int) {
        let command: build_version_command = machData.get(atOffset: offset)
        platform = Platform(platform: command.platform)
        minos = Version(machVersion: command.minos)
        sdk = Version(machVersion: command.sdk)
        let tool_versions: [build_tool_version] = machData.get(
            atOffset: offset + MemoryLayout<build_version_command>.size, count: Int(command.ntools)
        )
        buildToolVersions = tool_versions.map { tool_version -> BuildToolVersion in
            BuildToolVersion(tool_version: tool_version)
        }
    }
}

public extension BuildVersionLC {
    enum Platform {
        case macos
        case ios
        case tvos
        case watchos
        case bridgeos
        case macCatalyst
        case iosSimulator
        case tvosSimulator
        case watchosSimulator
        case driverKit
        case unknown

        init(platform: UInt32) {
            switch platform {
            case UInt32(PLATFORM_MACOS):
                self = .macos
            case UInt32(PLATFORM_IOS):
                self = .ios
            case UInt32(PLATFORM_TVOS):
                self = .tvos
            case UInt32(PLATFORM_WATCHOS):
                self = .watchos
            case UInt32(PLATFORM_BRIDGEOS):
                self = .bridgeos
            case UInt32(PLATFORM_MACCATALYST):
                self = .macCatalyst
            case UInt32(PLATFORM_IOSSIMULATOR):
                self = .iosSimulator
            case UInt32(PLATFORM_TVOSSIMULATOR):
                self = .tvosSimulator
            case UInt32(PLATFORM_WATCHOSSIMULATOR):
                self = .watchosSimulator
            case UInt32(PLATFORM_DRIVERKIT):
                self = .driverKit
            default:
                self = .unknown
            }
        }
    }
}

public extension BuildVersionLC {
    enum BuildTool {
        case clang
        case swift
        case ld
        case unknown

        init(tool: UInt32) {
            switch tool {
            case UInt32(TOOL_CLANG):
                self = .clang
            case UInt32(TOOL_SWIFT):
                self = .swift
            case UInt32(TOOL_LD):
                self = .ld
            default:
                self = .unknown
            }
        }
    }

    struct BuildToolVersion {
        let tool: BuildTool
        let version: Version

        init(tool_version: build_tool_version) {
            tool = BuildTool(tool: tool_version.tool)
            version = Version(machVersion: tool_version.version)
        }
    }
}
