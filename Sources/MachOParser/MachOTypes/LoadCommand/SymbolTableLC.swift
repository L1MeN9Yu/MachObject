//
// Created by Mengyu Li on 2020/7/24.
//

import Foundation
import MachO

public struct SymbolTableLC: LoadCommand {
    public static let id: UInt32 = UInt32(LC_SYMTAB)

    public let symbolTableOffset: UInt32
    public let numberOfSymbols: UInt32
    public let stringTableOffset: UInt32
    public let stringTableSize: UInt32

    public init(machData: Data, offset: Int) {
        let symtab: symtab_command = machData.get(atOffset: offset)
        symbolTableOffset = symtab.symoff
        numberOfSymbols = symtab.nsyms
        stringTableOffset = symtab.stroff
        stringTableSize = symtab.strsize
    }
}
