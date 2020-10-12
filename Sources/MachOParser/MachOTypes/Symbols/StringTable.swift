//
// Created by Mengyu Li on 2020/10/12.
//

import Foundation

public struct StringTable {
    let symbols: [Symbol]

    public init?(mach: Mach) {
        guard let symbolTableLC: SymbolTableLC = mach.loadCommand() else { return nil }
        let offset = symbolTableLC.stringTableOffset
        let size = symbolTableLC.stringTableSize
        var currentOffset: UInt32 = 0
        var symbols = [Symbol]()
        while currentOffset < size {
            let string = mach.data.get(atOffset: Int(currentOffset + offset))
            let symbol = Symbol(offset: Int(currentOffset + offset), value: string)
            symbols.append(symbol)
            switch string.count == 0 {
            case true:
                currentOffset += 1
            case false:
                currentOffset += UInt32(string.count + 1)
            }
        }
        self.symbols = symbols
    }
}
