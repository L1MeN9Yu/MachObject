//
// Created by Mengyu Li on 2020/12/28.
//

import Foundation
import MachOParser

extension Mach {
    func get<T>(atFileOffset offset: Int) -> T {
        data.get(atOffset: offset)
    }

    func get<T, I: UnsignedInteger>(fromVmOffset offset: I) -> T {
        let objectFileAddress = fileOffset(fromVmOffset: offset)
        return get(atFileOffset: objectFileAddress)
    }

    func getCString<R, I: UnsignedInteger>(fromVmOffset offset: I) -> R where R: ContainedInData, R.ValueType == String {
        data.getCString(atOffset: fileOffset(fromVmOffset: offset))
    }

    func get_entsize_list_tt<Element: FromMach, I: UnsignedInteger>(fromVmOffset offset: I, flags: UInt32 = 0) -> [Element] {
        guard offset != 0 else { return [] }
        let listFileOffset = fileOffset(fromVmOffset: offset)
        let list: ObjC.entsize_list_tt = get(atFileOffset: listFileOffset)
        let elementSize = list.entsizeAndFlags & ~flags

        let expectedSize = MemoryLayout<Element.Raw>.size
        guard elementSize == expectedSize else {
            fatalError(
                """
                List of \(Element.self) defines entsize=\(elementSize), while \(expectedSize) expected.
                Looks like the binary is malformed.
                """
            )
        }

        let elements: [Element] = (0..<list.count).map { idx in
            Element(mach: self, offset: listFileOffset + MemoryLayout<ObjC.entsize_list_tt>.size + Int(idx * elementSize))
        }
        return elements
    }
}
