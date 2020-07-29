//
// Created by Mengyu Li on 2020/7/24.
//

import Foundation
import MachO

public struct DynamicSymbolTableLC: LoadCommand {
	public static let id: UInt32 = UInt32(LC_DYSYMTAB)

	public let localSymbolIndex: UInt32
	public let localSymbolCount: UInt32
	public let definedExternalSymbolIndex: UInt32
	public let definedExternalSymbolCount: UInt32
	public let undefinedExternalSymbolIndex: UInt32
	public let undefinedExternalSymbolCount: UInt32
	public let tableOfContentOffset: UInt32
	public let tableOfContentCount: UInt32
	public let moduleOfTableOffset: UInt32
	public let moduleOfTableCount: UInt32
	public let externalReferencedSymbolOffset: UInt32
	public let externalReferencedSymbolCount: UInt32
	public let indirectSymbolOffset: UInt32
	public let indirectSymbolCount: UInt32
	public let externalRelocationOffset: UInt32
	public let externalRelocationCount: UInt32
	public let localRelocationOffset: UInt32
	public let localRelocationCount: UInt32

	public init(machData: Data, offset: Int) {
		let command: dysymtab_command = machData.get(atOffset: offset)
		localSymbolIndex = command.ilocalsym
		localSymbolCount = command.nlocalsym
		definedExternalSymbolIndex = command.iextdefsym
		definedExternalSymbolCount = command.nextdefsym
		undefinedExternalSymbolIndex = command.iundefsym
		undefinedExternalSymbolCount = command.nundefsym
		tableOfContentOffset = command.tocoff
		tableOfContentCount = command.ntoc
		moduleOfTableOffset = command.modtaboff
		moduleOfTableCount = command.nmodtab
		externalReferencedSymbolOffset = command.extrefsymoff
		externalReferencedSymbolCount = command.nextrefsyms
		indirectSymbolOffset = command.indirectsymoff
		indirectSymbolCount = command.nindirectsyms
		externalRelocationOffset = command.extreloff
		externalRelocationCount = command.nextrel
		localRelocationOffset = command.locreloff
		localRelocationCount = command.nlocrel
	}
}
