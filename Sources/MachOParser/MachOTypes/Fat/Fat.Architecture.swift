//
// Created by Mengyu Li on 2020/7/24.
//

import Foundation
import MachO

extension Fat {
    public struct Architecture {
        public let offset: UInt64
        public let mach: Mach

        init(data: Data, arch: fat_arch) throws {
            let range = (Int(arch.offset.byteSwapped)..<Int(arch.offset.byteSwapped + arch.size.byteSwapped))
            let subdata = data.subdata(in: range)
            offset = UInt64(arch.offset.byteSwapped)
            mach = try Mach(data: subdata)
        }
    }
}
