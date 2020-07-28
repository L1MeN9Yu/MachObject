//
// Created by Mengyu Li on 2020/7/28.
//

import Foundation
import MachO

extension Mach {
	// swiftlint:disable function_body_length
	static func parseLoadCommand(data: Data, count: UInt32, headerSize: Int) -> [LoadCommand] {
		var loadCommands = [LoadCommand]()
		var loadCommandLeft = count
		var offsetCursor = headerSize
		while loadCommandLeft > 0 {
			let command: load_command = data.get(atOffset: offsetCursor)
			switch command.cmd {
			case UInt32(LC_REQ_DYLD): /* do not handle this */ break
			case SegmentLC.id:
				let segmentLC = SegmentLC(machData: data, offset: offsetCursor)
				loadCommands.append(segmentLC)
			case SymbolTableLC.id:
				let symbolTableLC = SymbolTableLC(machData: data, offset: offsetCursor)
				loadCommands.append(symbolTableLC)
			case UInt32(LC_SYMSEG): /* OBSOLETE */ break
			case ThreadLC.id:
				let threadLC = ThreadLC(machData: data, offset: offsetCursor)
				loadCommands.append(threadLC)
			case UnixThreadLC.id:
				let unixThreadLC = UnixThreadLC(machData: data, offset: offsetCursor)
				loadCommands.append(unixThreadLC)
			case UInt32(LC_LOADFVMLIB): /* OBSOLETE */ break
			case UInt32(LC_IDFVMLIB): /* OBSOLETE */ break
			case UInt32(LC_IDENT): /* OBSOLETE */ break
			case FixedVMFileLC.id:
				let fixedVMFileLC = FixedVMFileLC(machData: data, offset: offsetCursor)
				loadCommands.append(fixedVMFileLC)
			case UInt32(LC_PREPAGE): /* prepage command (internal use) */ break
			case DynamicSymbolTableLC.id:
				let dynamicSymbolTableLC = DynamicSymbolTableLC(machData: data, offset: offsetCursor)
				loadCommands.append(dynamicSymbolTableLC)
			case LoadDylibLC.id:
				let loadDylibLC = LoadDylibLC(machData: data, offset: offsetCursor)
				loadCommands.append(loadDylibLC)
			case IDDylibLC.id:
				let idDylibLC = IDDylibLC(machData: data, offset: offsetCursor)
				loadCommands.append(idDylibLC)
			case LoadDylinkerLC.id:
				let loadDylinkerLC = LoadDylinkerLC(machData: data, offset: offsetCursor)
				loadCommands.append(loadDylinkerLC)
			case IDDylinkerLC.id:
				let idDylinkerLC = IDDylinkerLC(machData: data, offset: offsetCursor)
				loadCommands.append(idDylinkerLC)
			case UInt32(LC_PREBOUND_DYLIB): /* todo not handle */ break
			case RoutinesLC.id:
				let routinesLC = RoutinesLC(machData: data, offset: offsetCursor)
				loadCommands.append(routinesLC)
			case SubFrameworkLC.id:
				let subFrameworkLC = SubFrameworkLC(machData: data, offset: offsetCursor)
				loadCommands.append(subFrameworkLC)
			case SubUmbrellaLC.id:
				let subUmbrellaLC = SubUmbrellaLC(machData: data, offset: offsetCursor)
				loadCommands.append(subUmbrellaLC)
			case SubClientLC.id:
				let subClientLC = SubClientLC(machData: data, offset: offsetCursor)
				loadCommands.append(subClientLC)
			case SubLibraryLC.id:
				let subLibraryLC = SubLibraryLC(machData: data, offset: offsetCursor)
				loadCommands.append(subLibraryLC)
			case TwoLevelHintsLC.id:
				let twoLevelHintsLC = TwoLevelHintsLC(machData: data, offset: offsetCursor)
				loadCommands.append(twoLevelHintsLC)
			case PrebindChecksumLC.id:
				let prebindChecksumLC = PrebindChecksumLC(machData: data, offset: offsetCursor)
				loadCommands.append(prebindChecksumLC)
			case LoadWeakDylibLC.id:
				let loadWeakDylibLC = LoadWeakDylibLC(machData: data, offset: offsetCursor)
				loadCommands.append(loadWeakDylibLC)
			case Segment64LC.id:
				let segment64LC = Segment64LC(machData: data, offset: offsetCursor)
				loadCommands.append(segment64LC)
			case Routines64LC.id:
				let routines64LC = Routines64LC(machData: data, offset: offsetCursor)
				loadCommands.append(routines64LC)
			case UUIDLC.id:
				let uuidLC = UUIDLC(machData: data, offset: offsetCursor)
				loadCommands.append(uuidLC)
			case RunPathLC.id:
				let runPathLC = RunPathLC(machData: data, offset: offsetCursor)
				loadCommands.append(runPathLC)
			case CodeSignatureLC.id:
				let codeSignatureLC = CodeSignatureLC(machData: data, offset: offsetCursor)
				loadCommands.append(codeSignatureLC)
			case SegmentSplitInfoLC.id:
				let segmentSplitInfoLC = SegmentSplitInfoLC(machData: data, offset: offsetCursor)
				loadCommands.append(segmentSplitInfoLC)
			case ReexportedDylibLC.id:
				let reexportedDylibLC = ReexportedDylibLC(machData: data, offset: offsetCursor)
				loadCommands.append(reexportedDylibLC)
			case LazyLoadDylibLC.id:
				let lazyLoadDylibLC = LazyLoadDylibLC(machData: data, offset: offsetCursor)
				loadCommands.append(lazyLoadDylibLC)
			case EncryptionInfoLC.id:
				let encryptionInfoLC = EncryptionInfoLC(machData: data, offset: offsetCursor)
				loadCommands.append(encryptionInfoLC)
			case DyldInfoLC.id:
				let dyldInfoLC = DyldInfoLC(machData: data, offset: offsetCursor)
				loadCommands.append(dyldInfoLC)
			case DyldInfoOnlyLC.id:
				let dyldInfoOnlyLC = DyldInfoOnlyLC(machData: data, offset: offsetCursor)
				loadCommands.append(dyldInfoOnlyLC)
			case LoadUpwardDylibLC.id:
				let loadUpwardDylibLC = LoadUpwardDylibLC(machData: data, offset: offsetCursor)
				loadCommands.append(loadUpwardDylibLC)
			case VersionMinMacosxLC.id:
				let versionMinMacosxLC = VersionMinMacosxLC(machData: data, offset: offsetCursor)
				loadCommands.append(versionMinMacosxLC)
			case VersionMinIphoneosLC.id:
				let versionMinIphoneosLC = VersionMinIphoneosLC(machData: data, offset: offsetCursor)
				loadCommands.append(versionMinIphoneosLC)
			case FunctionStartsLC.id:
				let functionStartsLC = FunctionStartsLC(machData: data, offset: offsetCursor)
				loadCommands.append(functionStartsLC)
			case DyldEnvironmentLC.id:
				let dyldEnvironmentLC = DyldEnvironmentLC(machData: data, offset: offsetCursor)
				loadCommands.append(dyldEnvironmentLC)
			case MainLC.id:
				let mainLC = MainLC(machData: data, offset: offsetCursor)
				loadCommands.append(mainLC)
			case DataInCodeLC.id:
				let dataInCodeLC = DataInCodeLC(machData: data, offset: offsetCursor)
				loadCommands.append(dataInCodeLC)
			case SourceVersionLC.id:
				let sourceVersionLC = SourceVersionLC(machData: data, offset: offsetCursor)
				loadCommands.append(sourceVersionLC)
			case DylibCodeSignDrsLC.id:
				let dylibCodeSignDrsLC = DylibCodeSignDrsLC(machData: data, offset: offsetCursor)
				loadCommands.append(dylibCodeSignDrsLC)
			case EncryptionInfo64LC.id:
				let encryptionInfo64LC = EncryptionInfo64LC(machData: data, offset: offsetCursor)
				loadCommands.append(encryptionInfo64LC)
			case LinkerOptionLC.id:
				let linkerOptionLC = LinkerOptionLC(machData: data, offset: offsetCursor)
				loadCommands.append(linkerOptionLC)
			case LinkerOptimizationHintLC.id:
				let linkerOptimizationHintLC = LinkerOptimizationHintLC(machData: data, offset: offsetCursor)
				loadCommands.append(linkerOptimizationHintLC)
			case VersionMinTvosLC.id:
				let versionMinTvosLC = VersionMinTvosLC(machData: data, offset: offsetCursor)
				loadCommands.append(versionMinTvosLC)
			case VersionMinWatchosLC.id:
				let versionMinWatchosLC = VersionMinWatchosLC(machData: data, offset: offsetCursor)
				loadCommands.append(versionMinWatchosLC)
			case NoteLC.id:
				let noteLC = NoteLC(machData: data, offset: offsetCursor)
				loadCommands.append(noteLC)
			case BuildVersionLC.id:
				let buildVersionLC = BuildVersionLC(machData: data, offset: offsetCursor)
				loadCommands.append(buildVersionLC)
			case DyldExportsTrieLC.id:
				let dyldExportsTrieLC = DyldExportsTrieLC(machData: data, offset: offsetCursor)
				loadCommands.append(dyldExportsTrieLC)
			case DyldChainedFixupsLC.id:
				let dyldChainedFixupsLC = DyldChainedFixupsLC(machData: data, offset: offsetCursor)
				loadCommands.append(dyldChainedFixupsLC)
			default: break
			}
			offsetCursor += Int(command.cmdsize)
			loadCommandLeft -= 1
		}
		return loadCommands
	}
}
