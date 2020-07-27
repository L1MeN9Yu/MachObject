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
            case LoadDylinkerLC.id:
                let loadDylinkerLC = LoadDylinkerLC(machData: data, offset: cursor)
                loadCommands.append(loadDylinkerLC)
            case IDDylinkerLC.id:
                let idDylinkerLC = IDDylinkerLC(machData: data, offset: cursor)
                loadCommands.append(idDylinkerLC)
            case UInt32(LC_PREBOUND_DYLIB):/* todo not handle */break
            case RoutinesLC.id:
                let routinesLC = RoutinesLC(machData: data, offset: cursor)
                loadCommands.append(routinesLC)
            case SubFrameworkLC.id:
                let subFrameworkLC = SubFrameworkLC(machData: data, offset: cursor)
                loadCommands.append(subFrameworkLC)
            case SubUmbrellaLC.id:
                let subUmbrellaLC = SubUmbrellaLC(machData: data, offset: cursor)
                loadCommands.append(subUmbrellaLC)
            case SubClientLC.id:
                let subClientLC = SubClientLC(machData: data, offset: cursor)
                loadCommands.append(subClientLC)
            case SubLibraryLC.id:
                let subLibraryLC = SubLibraryLC(machData: data, offset: cursor)
                loadCommands.append(subLibraryLC)
            case TwoLevelHintsLC.id:
                let twoLevelHintsLC = TwoLevelHintsLC(machData: data, offset: cursor)
                loadCommands.append(twoLevelHintsLC)
            case PrebindChecksumLC.id:
                let prebindChecksumLC = PrebindChecksumLC(machData: data, offset: cursor)
                loadCommands.append(prebindChecksumLC)
            case LoadWeakDylibLC.id:
                let loadWeakDylibLC = LoadWeakDylibLC(machData: data, offset: cursor)
                loadCommands.append(loadWeakDylibLC)
            case Segment64LC.id:
                let segment64LC = Segment64LC(machData: data, offset: cursor)
                loadCommands.append(segment64LC)
            case Routines64LC.id:
                let routines64LC = Routines64LC(machData: data, offset: cursor)
                loadCommands.append(routines64LC)
            case UUIDLC.id:
                let uuidLC = UUIDLC(machData: data, offset: cursor)
                loadCommands.append(uuidLC)
            case RunPathLC.id:
                let runPathLC = RunPathLC(machData: data, offset: cursor)
                loadCommands.append(runPathLC)
            case CodeSignatureLC.id:
                let codeSignatureLC = CodeSignatureLC(machData: data, offset: cursor)
                loadCommands.append(codeSignatureLC)
            case SegmentSplitInfoLC.id:
                let segmentSplitInfoLC = SegmentSplitInfoLC(machData: data, offset: cursor)
                loadCommands.append(segmentSplitInfoLC)
            case ReexportedDylibLC.id:
                let reexportedDylibLC = ReexportedDylibLC(machData: data, offset: cursor)
                loadCommands.append(reexportedDylibLC)
            case LazyLoadDylibLC.id:
                let lazyLoadDylibLC = LazyLoadDylibLC(machData: data, offset: cursor)
                loadCommands.append(lazyLoadDylibLC)
            case EncryptionInfoLC.id:
                let encryptionInfoLC = EncryptionInfoLC(machData: data, offset: cursor)
                loadCommands.append(encryptionInfoLC)
            case DyldInfoLC.id:
                let dyldInfoLC = DyldInfoLC(machData: data, offset: cursor)
                loadCommands.append(dyldInfoLC)
            case DyldInfoOnlyLC.id:
                let dyldInfoOnlyLC = DyldInfoOnlyLC(machData: data, offset: cursor)
                loadCommands.append(dyldInfoOnlyLC)
            case LoadUpwardDylibLC.id:
                let loadUpwardDylibLC = LoadUpwardDylibLC(machData: data, offset: cursor)
                loadCommands.append(loadUpwardDylibLC)
            case VersionMinMacosxLC.id:
                let versionMinMacosxLC = VersionMinMacosxLC(machData: data, offset: cursor)
                loadCommands.append(versionMinMacosxLC)
            case VersionMinIphoneosLC.id:
                let versionMinIphoneosLC = VersionMinIphoneosLC(machData: data, offset: cursor)
                loadCommands.append(versionMinIphoneosLC)
            case FunctionStartsLC.id:
                let functionStartsLC = FunctionStartsLC(machData: data, offset: cursor)
                loadCommands.append(functionStartsLC)
            case DyldEnvironmentLC.id:
                let dyldEnvironmentLC = DyldEnvironmentLC(machData: data, offset: cursor)
                loadCommands.append(dyldEnvironmentLC)
            case MainLC.id:
                let mainLC = MainLC(machData: data, offset: cursor)
                loadCommands.append(mainLC)
            case DataInCodeLC.id:
                let dataInCodeLC = DataInCodeLC(machData: data, offset: cursor)
                loadCommands.append(dataInCodeLC)
            case UInt32(LC_SOURCE_VERSION):break
            case DylibCodeSignDrsLC.id:
                let dylibCodeSignDrsLC = DylibCodeSignDrsLC(machData: data, offset: cursor)
                loadCommands.append(dylibCodeSignDrsLC)
            case EncryptionInfo64LC.id:
                let encryptionInfo64LC = EncryptionInfo64LC(machData: data, offset: cursor)
                loadCommands.append(encryptionInfo64LC)
            case UInt32(LC_LINKER_OPTION):break
            case UInt32(LC_LINKER_OPTIMIZATION_HINT):break
            case VersionMinTvosLC.id:
                let versionMinTvosLC = VersionMinTvosLC(machData: data, offset: cursor)
                loadCommands.append(versionMinTvosLC)
            case VersionMinWatchosLC.id:
                let versionMinWatchosLC = VersionMinWatchosLC(machData: data, offset: cursor)
                loadCommands.append(versionMinWatchosLC)
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
