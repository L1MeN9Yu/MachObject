//
// Created by Mengyu Li on 2021/8/13.
//

import CodeSignParser
import struct MachO.loader.mach_header
import struct MachO.loader.mach_header_64
import var MachO.loader.MH_CIGAM
import var MachO.loader.MH_CIGAM_64
import var MachO.loader.MH_MAGIC
import var MachO.loader.MH_MAGIC_64

public struct ProcessMach {
    public let pointer: UnsafeRawPointer
    public let header: Header
    public let allLoadCommands: [LoadCommand]

    public init(headerPointer: UnsafePointer<mach_header>) throws {
        let baseHeader = headerPointer.pointee
        switch baseHeader.magic {
        case MH_MAGIC, MH_CIGAM:
            try self.init(headerPointer32: headerPointer)
        case MH_MAGIC_64, MH_CIGAM_64:
            try self.init(headerPointer64: headerPointer)
        default:
            throw Error.magic(baseHeader.magic)
        }
    }
}

private extension ProcessMach {
    init(headerPointer32: UnsafePointer<mach_header>) throws {
        pointer = UnsafeRawPointer(headerPointer32)
        header = try ._32(Header._32_(header: headerPointer32.pointee))

        allLoadCommands = Self.parseLoadCommands(startPointer: pointer.advanced(by: header.rawTypeStride), count: header.commandCount)
    }

    init(headerPointer64: UnsafePointer<mach_header>) throws {
        pointer = UnsafeRawPointer(headerPointer64)
        let headerPointer = headerPointer64.withMemoryRebound(to: mach_header_64.self, capacity: 1) { $0 }
        header = try ._64(Header._64_(header: headerPointer.pointee))

        allLoadCommands = Self.parseLoadCommands(startPointer: pointer.advanced(by: header.rawTypeStride), count: header.commandCount)
    }
}

public extension ProcessMach {
    var fileType: Header.FileType { header.fileType }

    var cpuType: CPUType { header.cpuType }

    var flags: Header.Flags { header.flags }
}

public extension ProcessMach {
    func loadCommands<T: LoadCommand>() -> [T]? { allLoadCommands.compactMap { $0 as? T } }

    func loadCommand<T: LoadCommand>() -> T? { loadCommands()?.first }
}

public extension ProcessMach {
    var stringTable: StringTable? {
        StringTable(processMach: self)
    }
}
