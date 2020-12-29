//
// Created by Mengyu Li on 2020/12/29.
//

import Foundation
import MachOParser

typealias CpuId = Int64

extension Mach {
    var asCpuId: CpuId {
        (Int64(UInt32(bitPattern: header.rawCpuType)) << 32) | Int64(UInt32(bitPattern: header.rawCpuSubtype))
    }
}
