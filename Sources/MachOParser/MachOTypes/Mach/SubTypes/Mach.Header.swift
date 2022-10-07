//
// Created by Mengyu Li on 2020/7/24.
//

import Darwin.Mach.machine
import Foundation

public extension Mach {
    enum Header {
        case _32(_32_)
        case _64(_64_)
    }
}

public extension Mach.Header {
    var rawCpuType: cpu_type_t {
        switch self {
        case let ._32(header):
            return header.cpuType.rawValue
        case let ._64(header):
            return header.cpuType.rawValue
        }
    }

    var rawCpuSubtype: cpu_subtype_t {
        switch self {
        case let ._32(header):
            return header.cpuSubtype.rawValue
        case let ._64(header):
            return header.cpuSubtype.rawValue
        }
    }

    var rawFileType: UInt32 {
        switch self {
        case let ._32(header):
            return header.fileType.rawValue
        case let ._64(header):
            return header.fileType.rawValue
        }
    }

    var rawFlags: UInt32 {
        switch self {
        case let ._32(header):
            return UInt32(header.flags.rawValue)
        case let ._64(header):
            return UInt32(header.flags.rawValue)
        }
    }

    var commandCount: UInt32 {
        switch self {
        case let ._32(header):
            return header.commandCount
        case let ._64(header):
            return header.commandCount
        }
    }

    var commandSize: UInt32 {
        switch self {
        case let ._32(header):
            return header.commandSize
        case let ._64(header):
            return header.commandSize
        }
    }

    var rawTypeStride: Int {
        switch self {
        case let ._32(header):
            return header.rawStride
        case let ._64(header):
            return header.rawStride
        }
    }
}

public extension Mach.Header {
    var magic: UInt32 {
        switch self {
        case let ._32(content):
            return content.magic
        case let ._64(content):
            return content.magic
        }
    }

    var cpuType: CPUType {
        switch self {
        case let ._32(content):
            return content.cpuType
        case let ._64(content):
            return content.cpuType
        }
    }

    var fileType: FileType {
        switch self {
        case let ._32(content):
            return content.fileType
        case let ._64(content):
            return content.fileType
        }
    }

    var flags: Mach.Header.Flags {
        switch self {
        case let ._32(content):
            return content.flags
        case let ._64(content):
            return content.flags
        }
    }

    var is64bit: Bool {
        switch self {
        case ._32:
            return false
        case ._64:
            return true
        }
    }
}
