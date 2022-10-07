//
// Created by Mengyu Li on 2020/7/23.
//

import Foundation
@_implementationOnly import MachCore
import MachO

public struct Fat {
    public let data: Data
    public let header: Header
    public let architectures: [Architecture]
    private let byteOrder: ByteOrder
    private let bitWide: BitWide

    init(data: Data) throws {
        let magic = data.magic
        switch magic {
        case FAT_MAGIC:
            byteOrder = .big
            bitWide = ._32
        case FAT_CIGAM:
            byteOrder = .little
            bitWide = ._32
        case FAT_MAGIC_64:
            byteOrder = .big
            bitWide = ._64
        case FAT_CIGAM_64:
            byteOrder = .little
            bitWide = ._64
        default:
            throw Error.magic(magic)
        }
        self.data = data

        let fat_header: fat_header = data.get(atOffset: 0)
        header = Header(fat_header, byteOrder: byteOrder)

        switch bitWide {
        case ._32:
            let fatArchitectures: [fat_arch] = data.get(atOffset: Header.rawSize, count: Int(header.architectureCount))
            architectures = try fatArchitectures.map { [byteOrder] arch in
                try Architecture._32(Architecture._32_(data: data, arch: arch, byteOrder: byteOrder))
            }
        case ._64:
            let fatArchitectures: [fat_arch_64] = data.get(atOffset: Header.rawSize, count: Int(header.architectureCount))
            architectures = try fatArchitectures.map { [byteOrder] arch in
                try Architecture._64(Architecture._64_(data: data, arch: arch, byteOrder: byteOrder))
            }
        }
    }
}
