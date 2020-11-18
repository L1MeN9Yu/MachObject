//
// Created by Mengyu Li on 2020/7/24.
//

import Foundation
import MachO

public extension segment_command_64 { var name: String { String(bytesTuple: segname) } }

public extension segment_command { var name: String { String(bytesTuple: segname) } }

public extension section_64 { var name: String { String(bytesTuple: sectname) } }

public extension section { var name: String { String(bytesTuple: sectname) } }

public extension String {
    init(bytesTuple: (Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8)) {
        var table = [Int8](repeating: 0, count: 17)
        withUnsafePointer(to: bytesTuple) { ptr in
            ptr.withMemoryRebound(to: Int8.self, capacity: 16) { ptr in
                for i in 0..<16 {
                    table[i] = ptr[i]
                }
            }
        }
        self.init(cString: table)
    }

    init(data: Data, offset: Int, commandSize: Int, loadCommandString: lc_str) {
        let loadCommandStringOffset = Int(loadCommandString.offset)
        let stringOffset = offset + loadCommandStringOffset
        let length = commandSize - loadCommandStringOffset
        self = String(data: data[stringOffset..<(stringOffset + length)], encoding: .utf8)?
            .trimmingCharacters(in: .controlCharacters)
            ?? ""
    }
}
