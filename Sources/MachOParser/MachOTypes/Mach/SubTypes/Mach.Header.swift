//
// Created by Mengyu Li on 2020/7/24.
//

import Foundation

extension Mach {
    public enum Header {
        case _32(MachHeader32)
        case _64(MachHeader64)
    }
}

public extension Mach.Header {
    var magic: UInt32 {
        switch self {
        case let ._32(header):
            return header.magic
        case let ._64(header):
            return header.magic
        }
    }

    var rawCpuType: cpu_type_t {
        switch self {
        case let ._32(header):
            return header.cpuType
        case let ._64(header):
            return header.cpuType
        }
    }

    var rawCpuSubtype: cpu_subtype_t {
        switch self {
        case let ._32(header):
            return header.cpuSubtype
        case let ._64(header):
            return header.cpuSubtype
        }
    }

    var rawFileType: UInt32 {
        switch self {
        case let ._32(header):
            return header.fileType
        case let ._64(header):
            return header.fileType
        }
    }

    var rawFlags: UInt32 {
        switch self {
        case let ._32(header):
            return header.flags
        case let ._64(header):
            return header.flags
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
}

public extension Mach.Header {
    var cpuType: Mach.CPUType { Mach.CPUType(cpuType: rawCpuType) }

    var fileType: Mach.FileType { Mach.FileType(fileType: rawFileType) }

    var readableFlag: Set<MachHeaderFlag> { Set<MachHeaderFlag>(rawValue: Int64(rawFlags)) }

    var is64bit: Bool {
        switch self {
        case ._32:
            return false
        case ._64:
            return true
        }
    }
}
