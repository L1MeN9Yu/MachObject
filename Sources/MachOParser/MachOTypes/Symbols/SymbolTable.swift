//
// Created by Mengyu Li on 2020/10/12.
//

import Foundation
import MachO

public struct SymbolTable {
    let localSymbols: Range<UInt32>
    let externalSymbols: Range<UInt32>
    let undefinedSymbols: Range<UInt32>

    init?(mach: Mach) {
        guard let symtabLC: SymbolTableLC = mach.loadCommand() else { return nil }
        guard let dysymtabLC: DynamicSymbolTableLC = mach.loadCommand() else { return nil }
        let nlistSize: Int
        switch mach.header.is64bit {
        case true:
            nlistSize = MemoryLayout<nlist_64>.stride
        case false:
            nlistSize = MemoryLayout<nlist>.stride
        }
        let offset = symtabLC.symbolTableOffset
        let size = symtabLC.numberOfSymbols * UInt32(nlistSize)
        localSymbols = Range<UInt32>(offset: dysymtabLC.localSymbolIndex, count: dysymtabLC.localSymbolCount)
        externalSymbols = Range<UInt32>(offset: dysymtabLC.definedExternalSymbolIndex, count: dysymtabLC.definedExternalSymbolCount)
        undefinedSymbols = Range<UInt32>(offset: dysymtabLC.undefinedExternalSymbolIndex, count: dysymtabLC.undefinedExternalSymbolCount)
        var currentOffset = 0
        while currentOffset < size {
            switch mach.header.is64bit {
            case true:
                let nlist: nlist_64 = mach.data.get(atOffset: currentOffset + Int(offset))
                nlist.n_un.n_strx
            case false:
                let nlist: nlist = mach.data.get(atOffset: currentOffset + Int(offset))
            }
            currentOffset += nlistSize
        }
    }
}
