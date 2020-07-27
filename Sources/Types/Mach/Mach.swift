//
// Created by Mengyu Li on 2020/7/23.
//

import Foundation
import MachO

// MARK: - Define
public struct Mach {
    var data: Data
    public let header: Header
    public let loadCommands: [LoadCommand]

    public init(data: Data) throws {
        let magic = data.magic
        switch magic {
        case MH_MAGIC:
            self.init(data32: data)
        case MH_MAGIC_64:
            self.init(data64: data)
        default:
            throw Error.magic(magic)
        }
    }
}

private extension Mach {
    init(data32: Data) {
        self.data = data32
        let header: mach_header = data32.get(atOffset: 0)
        self.header = ._32(MachHeader32(header: header))
        loadCommands = Self.parseLoadCommand(data: data32, count: header.ncmds, headerSize: MemoryLayout<mach_header>.size)
    }

    init(data64: Data) {
        self.data = data64
        let header: mach_header_64 = data64.get(atOffset: 0)
        self.header = ._64(MachHeader64(header: header))
        loadCommands = Self.parseLoadCommand(data: data64, count: header.ncmds, headerSize: MemoryLayout<mach_header_64>.size)
    }

    static func parseLoadCommand(data: Data, count: UInt32, headerSize: Int) -> [LoadCommand] {
        var loadCommands = [LoadCommand]()
        var cmdsLeft = count
        var cursor = headerSize
        while cmdsLeft > 0 {
            let command: load_command = data.get(atOffset: cursor)
            switch command.cmd {
            case UInt32(LC_REQ_DYLD):/* do not handle this */break
            case SegmentLC.id:
                let segmentLC = SegmentLC(machData: data, offset: cursor)
                loadCommands.append(segmentLC)
            case SymbolTableLC.id:
                let symbolTableLC = SymbolTableLC(machData: data, offset: cursor)
                loadCommands.append(symbolTableLC)
            case UInt32(LC_SYMSEG):/* OBSOLETE */break
            case ThreadLC.id:
                let threadLC = ThreadLC(machData: data, offset: cursor)
                loadCommands.append(threadLC)
            case UnixThreadLC.id:
                let unixThreadLC = UnixThreadLC(machData: data, offset: cursor)
                loadCommands.append(unixThreadLC)
            case UInt32(LC_LOADFVMLIB):/* OBSOLETE */break
            case UInt32(LC_IDFVMLIB):/* OBSOLETE */break
            case UInt32(LC_IDENT):/* OBSOLETE */break
            case FixedVMFileLC.id:
                let fixedVMFileLC = FixedVMFileLC(machData: data, offset: cursor)
                loadCommands.append(fixedVMFileLC)
            case UInt32(LC_PREPAGE):/* prepage command (internal use) */break
            case DynamicSymbolTableLC.id:
                let dynamicSymbolTableLC = DynamicSymbolTableLC(machData: data, offset: cursor)
                loadCommands.append(dynamicSymbolTableLC)
            case LoadDylibLC.id:
                let loadDylibLC = LoadDylibLC(machData: data, offset: cursor)
                loadCommands.append(loadDylibLC)
            case IDDylibLC.id:
                let idDylibLC = IDDylibLC(machData: data, offset: cursor)
                loadCommands.append(idDylibLC)
            case UInt32(LC_LOAD_DYLINKER):break
            case UInt32(LC_ID_DYLINKER):break
            case UInt32(LC_PREBOUND_DYLIB):break
            case UInt32(LC_ROUTINES):break
            case UInt32(LC_SUB_FRAMEWORK):break
            case UInt32(LC_SUB_UMBRELLA):break
            case UInt32(LC_SUB_CLIENT):break
            case UInt32(LC_SUB_LIBRARY):break
            case UInt32(LC_TWOLEVEL_HINTS):break
            case UInt32(LC_PREBIND_CKSUM):break
            case LoadWeakDylibLC.id:
                let loadWeakDylibLC = LoadWeakDylibLC(machData: data, offset: cursor)
                loadCommands.append(loadWeakDylibLC)
            case UInt32(LC_SEGMENT_64):break
            case UInt32(LC_ROUTINES_64):break
            case UInt32(LC_UUID):break
            case UInt32(LC_RPATH):break
            case UInt32(LC_CODE_SIGNATURE):break
            case UInt32(LC_SEGMENT_SPLIT_INFO):break
            case ReexportedDylibLC.id:
                let reexportedDylibLC = ReexportedDylibLC(machData: data, offset: cursor)
                loadCommands.append(reexportedDylibLC)
            case UInt32(LC_LAZY_LOAD_DYLIB):break
            case UInt32(LC_ENCRYPTION_INFO):break
            case UInt32(LC_DYLD_INFO):break
            case UInt32(LC_DYLD_INFO_ONLY):break
            case UInt32(LC_LOAD_UPWARD_DYLIB):break
            case UInt32(LC_VERSION_MIN_MACOSX):break
            case UInt32(LC_VERSION_MIN_IPHONEOS):break
            case UInt32(LC_FUNCTION_STARTS):break
            case UInt32(LC_DYLD_ENVIRONMENT):break
            case UInt32(LC_MAIN):break
            case UInt32(LC_DATA_IN_CODE):break
            case UInt32(LC_SOURCE_VERSION):break
            case UInt32(LC_DYLIB_CODE_SIGN_DRS):break
            case UInt32(LC_ENCRYPTION_INFO_64):break
            case UInt32(LC_LINKER_OPTION):break
            case UInt32(LC_LINKER_OPTIMIZATION_HINT):break
            case UInt32(LC_VERSION_MIN_TVOS):break
            case UInt32(LC_VERSION_MIN_WATCHOS):break
            case UInt32(LC_NOTE):break
            case UInt32(LC_BUILD_VERSION):break
            case UInt32(LC_DYLD_EXPORTS_TRIE):break
            case UInt32(LC_DYLD_CHAINED_FIXUPS):break
            default:break
            }
            cursor += Int(command.cmdsize)
            cmdsLeft -= 1
        }
        return loadCommands
    }
}

// MARK: - Readable Property
public extension Mach {
    var fileType: FileType { FileType(fileType: header.fileType) }
    var cupType: CPUType { CPUType(cpuType: header.cupType) }
}
