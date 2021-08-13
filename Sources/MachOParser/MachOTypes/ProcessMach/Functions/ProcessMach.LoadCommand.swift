//
// Created by Mengyu Li on 2021/8/13.
//

@_implementationOnly import MachCore
import var MachO.loader.LC_IDENT
import var MachO.loader.LC_IDFVMLIB
import var MachO.loader.LC_LOADFVMLIB
import var MachO.loader.LC_PREBOUND_DYLIB
import var MachO.loader.LC_PREPAGE
import var MachO.loader.LC_REQ_DYLD
import var MachO.loader.LC_SYMSEG
import struct MachO.loader.load_command

extension ProcessMach {
    static func parseLoadCommands(startPointer: UnsafeRawPointer, count: UInt32) -> [LoadCommand] {
        var loadCommands = [LoadCommand]()
        var remainingCount = count
        var offsetPointer = startPointer
        while remainingCount > 0 {
            let command: load_command = offsetPointer.get()

            switch command.cmd {
            case UInt32(LC_REQ_DYLD): /* do not handle this */ break
            case SegmentLC.id:
                let segmentLC = SegmentLC(pointer: offsetPointer)
                loadCommands.append(segmentLC)
            case SymbolTableLC.id:
                let symbolTableLC = SymbolTableLC(pointer: offsetPointer)
                loadCommands.append(symbolTableLC)
            case UInt32(LC_SYMSEG): /* OBSOLETE */ break
            case ThreadLC.id:
                let threadLC = ThreadLC(pointer: offsetPointer)
                loadCommands.append(threadLC)
            case UnixThreadLC.id:
                let unixThreadLC = UnixThreadLC(pointer: offsetPointer)
                loadCommands.append(unixThreadLC)
            case UInt32(LC_LOADFVMLIB): /* OBSOLETE */ break
            case UInt32(LC_IDFVMLIB): /* OBSOLETE */ break
            case UInt32(LC_IDENT): /* OBSOLETE */ break
            case FixedVMFileLC.id:
                let fixedVMFileLC = FixedVMFileLC(pointer: offsetPointer)
                loadCommands.append(fixedVMFileLC)
            case UInt32(LC_PREPAGE): /* prepage command (internal use) */ break
            case DynamicSymbolTableLC.id:
                let dynamicSymbolTableLC = DynamicSymbolTableLC(pointer: offsetPointer)
                loadCommands.append(dynamicSymbolTableLC)
            case LoadDylibLC.id:
                let loadDylibLC = LoadDylibLC(pointer: offsetPointer)
                loadCommands.append(loadDylibLC)
            case IDDylibLC.id:
                let idDylibLC = IDDylibLC(pointer: offsetPointer)
                loadCommands.append(idDylibLC)
            case LoadDylinkerLC.id:
                let loadDylinkerLC = LoadDylinkerLC(pointer: offsetPointer)
                loadCommands.append(loadDylinkerLC)
            case IDDylinkerLC.id:
                let idDylinkerLC = IDDylinkerLC(pointer: offsetPointer)
                loadCommands.append(idDylinkerLC)
            case UInt32(LC_PREBOUND_DYLIB): /* todo not handle */ break
            case RoutinesLC.id:
                let routinesLC = RoutinesLC(pointer: offsetPointer)
                loadCommands.append(routinesLC)
            case SubFrameworkLC.id:
                let subFrameworkLC = SubFrameworkLC(pointer: offsetPointer)
                loadCommands.append(subFrameworkLC)
            case SubUmbrellaLC.id:
                let subUmbrellaLC = SubUmbrellaLC(pointer: offsetPointer)
                loadCommands.append(subUmbrellaLC)
            case SubClientLC.id:
                let subClientLC = SubClientLC(pointer: offsetPointer)
                loadCommands.append(subClientLC)
            case SubLibraryLC.id:
                let subLibraryLC = SubLibraryLC(pointer: offsetPointer)
                loadCommands.append(subLibraryLC)
            case TwoLevelHintsLC.id:
                let twoLevelHintsLC = TwoLevelHintsLC(pointer: offsetPointer)
                loadCommands.append(twoLevelHintsLC)
            case PrebindChecksumLC.id:
                let prebindChecksumLC = PrebindChecksumLC(pointer: offsetPointer)
                loadCommands.append(prebindChecksumLC)
            case LoadWeakDylibLC.id:
                let loadWeakDylibLC = LoadWeakDylibLC(pointer: offsetPointer)
                loadCommands.append(loadWeakDylibLC)
            case Segment64LC.id:
                let segment64LC = Segment64LC(pointer: offsetPointer)
                loadCommands.append(segment64LC)
            case Routines64LC.id:
                let routines64LC = Routines64LC(pointer: offsetPointer)
                loadCommands.append(routines64LC)
            case UUIDLC.id:
                let uuidLC = UUIDLC(pointer: offsetPointer)
                loadCommands.append(uuidLC)
            case RunPathLC.id:
                let runPathLC = RunPathLC(pointer: offsetPointer)
                loadCommands.append(runPathLC)
            case CodeSignatureLC.id:
                let codeSignatureLC = CodeSignatureLC(pointer: offsetPointer)
                loadCommands.append(codeSignatureLC)
            case SegmentSplitInfoLC.id:
                let segmentSplitInfoLC = SegmentSplitInfoLC(pointer: offsetPointer)
                loadCommands.append(segmentSplitInfoLC)
            case ReexportedDylibLC.id:
                let reexportedDylibLC = ReexportedDylibLC(pointer: offsetPointer)
                loadCommands.append(reexportedDylibLC)
            case LazyLoadDylibLC.id:
                let lazyLoadDylibLC = LazyLoadDylibLC(pointer: offsetPointer)
                loadCommands.append(lazyLoadDylibLC)
            case EncryptionInfoLC.id:
                let encryptionInfoLC = EncryptionInfoLC(pointer: offsetPointer)
                loadCommands.append(encryptionInfoLC)
            case DyldInfoLC.id:
                let dyldInfoLC = DyldInfoLC(pointer: offsetPointer)
                loadCommands.append(dyldInfoLC)
            case DyldInfoOnlyLC.id:
                let dyldInfoOnlyLC = DyldInfoOnlyLC(pointer: offsetPointer)
                loadCommands.append(dyldInfoOnlyLC)
            case LoadUpwardDylibLC.id:
                let loadUpwardDylibLC = LoadUpwardDylibLC(pointer: offsetPointer)
                loadCommands.append(loadUpwardDylibLC)
            case VersionMinMacosxLC.id:
                let versionMinMacosxLC = VersionMinMacosxLC(pointer: offsetPointer)
                loadCommands.append(versionMinMacosxLC)
            case VersionMinIphoneosLC.id:
                let versionMinIphoneosLC = VersionMinIphoneosLC(pointer: offsetPointer)
                loadCommands.append(versionMinIphoneosLC)
            case FunctionStartsLC.id:
                let functionStartsLC = FunctionStartsLC(pointer: offsetPointer)
                loadCommands.append(functionStartsLC)
            case DyldEnvironmentLC.id:
                let dyldEnvironmentLC = DyldEnvironmentLC(pointer: offsetPointer)
                loadCommands.append(dyldEnvironmentLC)
            case MainLC.id:
                let mainLC = MainLC(pointer: offsetPointer)
                loadCommands.append(mainLC)
            case DataInCodeLC.id:
                let dataInCodeLC = DataInCodeLC(pointer: offsetPointer)
                loadCommands.append(dataInCodeLC)
            case SourceVersionLC.id:
                let sourceVersionLC = SourceVersionLC(pointer: offsetPointer)
                loadCommands.append(sourceVersionLC)
            case DylibCodeSignDrsLC.id:
                let dylibCodeSignDrsLC = DylibCodeSignDrsLC(pointer: offsetPointer)
                loadCommands.append(dylibCodeSignDrsLC)
            case EncryptionInfo64LC.id:
                let encryptionInfo64LC = EncryptionInfo64LC(pointer: offsetPointer)
                loadCommands.append(encryptionInfo64LC)
            case LinkerOptionLC.id:
                let linkerOptionLC = LinkerOptionLC(pointer: offsetPointer)
                loadCommands.append(linkerOptionLC)
            case LinkerOptimizationHintLC.id:
                let linkerOptimizationHintLC = LinkerOptimizationHintLC(pointer: offsetPointer)
                loadCommands.append(linkerOptimizationHintLC)
            case VersionMinTvosLC.id:
                let versionMinTvosLC = VersionMinTvosLC(pointer: offsetPointer)
                loadCommands.append(versionMinTvosLC)
            case VersionMinWatchosLC.id:
                let versionMinWatchosLC = VersionMinWatchosLC(pointer: offsetPointer)
                loadCommands.append(versionMinWatchosLC)
            case NoteLC.id:
                let noteLC = NoteLC(pointer: offsetPointer)
                loadCommands.append(noteLC)
            case BuildVersionLC.id:
                let buildVersionLC = BuildVersionLC(pointer: offsetPointer)
                loadCommands.append(buildVersionLC)
            case DyldExportsTrieLC.id:
                let dyldExportsTrieLC = DyldExportsTrieLC(pointer: offsetPointer)
                loadCommands.append(dyldExportsTrieLC)
            case DyldChainedFixupsLC.id:
                let dyldChainedFixupsLC = DyldChainedFixupsLC(pointer: offsetPointer)
                loadCommands.append(dyldChainedFixupsLC)
            default: break
            }

            offsetPointer = offsetPointer.advanced(by: Int(command.cmdsize))
            remainingCount -= 1
        }
        return loadCommands
    }
}
