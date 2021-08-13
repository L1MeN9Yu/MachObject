//
// Created by Mengyu Li on 2020/7/24.
//

import Foundation
import MachO

public struct SymbolTableLC: LoadCommand {
    public static let id = UInt32(LC_SYMTAB)

    public let symbolTableOffset: UInt32
    public let numberOfSymbols: UInt32
    public let stringTableOffset: UInt32
    public let stringTableSize: UInt32

    public init(machData: Data, offset: Int) {
        let command: symtab_command = machData.get(atOffset: offset)
        self.init(command: command)
    }

    public init(pointer: UnsafeRawPointer) {
        let command: symtab_command = pointer.get()
        self.init(command: command)
    }
}

private extension SymbolTableLC {
    init(command: symtab_command) {
        symbolTableOffset = command.symoff
        numberOfSymbols = command.nsyms
        stringTableOffset = command.stroff
        stringTableSize = command.strsize
    }
}
