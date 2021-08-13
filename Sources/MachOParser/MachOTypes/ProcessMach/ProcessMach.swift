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
    private let pointer: UnsafeRawPointer
    public let header: Header
    public let allLoadCommands: [LoadCommand]

    public init(headerPointer: UnsafePointer<mach_header>) throws {
        let baseHeader = headerPointer.pointee
        switch baseHeader.magic {
        case MH_MAGIC, MH_CIGAM:
            self.init(headerPointer32: headerPointer)
        case MH_MAGIC_64, MH_CIGAM_64:
            self.init(headerPointer64: headerPointer)
        default:
            throw Error.magic(baseHeader.magic)
        }
    }
}

private extension ProcessMach {
    init(headerPointer32: UnsafePointer<mach_header>) {
        pointer = UnsafeRawPointer(headerPointer32)
        header = ._32(MachHeader32(header: headerPointer32.pointee))

        allLoadCommands = Self.parseLoadCommands(startPointer: pointer.advanced(by: header.rawTypeStride), count: header.commandCount)
    }

    init(headerPointer64: UnsafePointer<mach_header>) {
        pointer = UnsafeRawPointer(headerPointer64)
        let headerPointer = headerPointer64.withMemoryRebound(to: mach_header_64.self, capacity: 1) { $0 }
        header = ._64(MachHeader64(header: headerPointer.pointee))

        allLoadCommands = Self.parseLoadCommands(startPointer: pointer.advanced(by: header.rawTypeStride), count: header.commandCount)
    }
}

public extension ProcessMach {
    func loadCommands<T: LoadCommand>() -> [T]? { allLoadCommands.compactMap { $0 as? T } }

    func loadCommand<T: LoadCommand>() -> T? { loadCommands()?.first }
}

public extension ProcessMach {
    var codeSignature: CodeSignature? {
        guard let codeSignatureLC: CodeSignatureLC = loadCommand() else { return nil }

        return CodeSignature(machPointer: pointer, offset: Int(codeSignatureLC.dataOffset))
    }
}
