//
// Created by Mengyu Li on 2020/12/29.
//

import Foundation
import MachO

public extension Array where Element == Import {
    mutating func add(opcodesData: Data, range: Range<Int>, weakly: Bool) {
        let parsedStack = opcodesData.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> ImportStack in
            var stack = ImportStack()
            var dylibOrdinal: Int = 0
            var symbolBytes: [UInt8]?
            var symbolStart: Int?
            var cursorPtr = bytes.baseAddress!.advanced(by: range.lowerBound)
            let end = bytes.baseAddress!.advanced(by: range.upperBound)
            while cursorPtr < end {
                let opcode = Int32(cursorPtr.load(as: UInt8.self))
                cursorPtr = cursorPtr.advanced(by: 1)
                switch opcode & BIND_OPCODE_MASK {
                case BIND_OPCODE_DONE:
                    dylibOrdinal = 0
                    symbolBytes = nil
                    symbolStart = nil
                case BIND_OPCODE_SET_DYLIB_ORDINAL_IMM:
                    dylibOrdinal = Int(opcode & BIND_IMMEDIATE_MASK)
                case BIND_OPCODE_SET_DYLIB_ORDINAL_ULEB:
                    dylibOrdinal = Int(cursorPtr.readUleb128())
                case BIND_OPCODE_SET_DYLIB_SPECIAL_IMM:
                    fatalError("Unsupported opcode BIND_OPCODE_SET_DYLIB_SPECIAL_IMM")
                case BIND_OPCODE_SET_SYMBOL_TRAILING_FLAGS_IMM:
                    symbolStart = bytes.baseAddress!.distance(to: cursorPtr)
                    symbolBytes = cursorPtr.readStringBytes()
                case BIND_OPCODE_SET_TYPE_IMM: break
                case BIND_OPCODE_SET_ADDEND_SLEB:
                    _ = cursorPtr.readSleb128()
                case BIND_OPCODE_SET_SEGMENT_AND_OFFSET_ULEB:
                    _ = cursorPtr.readUleb128()
                case BIND_OPCODE_ADD_ADDR_ULEB:
                    _ = cursorPtr.readUleb128()
                case BIND_OPCODE_DO_BIND_ULEB_TIMES_SKIPPING_ULEB:
                    _ = cursorPtr.readUleb128()
                    fallthrough
                case BIND_OPCODE_DO_BIND_ADD_ADDR_ULEB:
                    _ = cursorPtr.readUleb128()
                    fallthrough
                case BIND_OPCODE_DO_BIND_ADD_ADDR_IMM_SCALED: fallthrough
                case BIND_OPCODE_DO_BIND:
                    guard
                        let symbolBytes = symbolBytes,
                        let symbolStart = symbolStart
                    else {
                        fatalError("BIND_OPCODE_DO_BIND record has no symbol")
                    }
                    let symbolRange = Range(offset: UInt64(symbolStart), count: UInt64(symbolBytes.count))
                    let entry = Import(
                        dylibOrdinal: dylibOrdinal,
                        symbol: symbolBytes,
                        symbolRange: symbolRange,
                        weak: weakly
                    )
                    stack.append(entry)
                default:
                    fatalError("Unsupported opcode \(opcode)")
                }
            }
            return stack
        }
        append(contentsOf: parsedStack)
    }

    mutating func resolveMissingDylibOrdinals() {
        let indiciesWithoutDylibOrdinal = enumerated().filter { _, entry in entry.dylibOrdinal == 0 }.map { offset, _ in offset }
        guard !indiciesWithoutDylibOrdinal.isEmpty else { return }

        let dylibOrdinalsPerSymbol: [String: [Int]] = Dictionary(grouping: self) { $0.symbolString }
            .mapValues { $0.map(\.dylibOrdinal).filter { $0 != 0 } }
        for index in indiciesWithoutDylibOrdinal {
            let symbolString = self[index].symbolString
            if let matchedOrdinal = dylibOrdinalsPerSymbol[symbolString]?.first {
                self[index].update(dylibOrdinal: matchedOrdinal)
            } else if !self[index].weak {
//                fatalError("Could not resolve '\(symbolString)' binding info")
//                print("Could not resolve '\(symbolString)' binding info")
                // todo check symbol table
                continue
            }
        }
    }
}
