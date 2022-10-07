//
// Created by Mengyu Li on 2022/10/5.
//

@_implementationOnly import MachCore
import struct MachO.fat.fat_header

public extension Fat {
    struct Header {
        public let magic: UInt32
        public let architectureCount: UInt32

        init(_ fat_header: fat_header, byteOrder: ByteOrder) {
            magic = fat_header.magic
            switch byteOrder {
            case .little:
                architectureCount = fat_header.nfat_arch.bigEndian
            case .big:
                architectureCount = fat_header.nfat_arch
            }
        }
    }
}

public extension Fat.Header {
    static var rawSize: Int {
        MemoryLayout<fat_header>.size
    }

    static var rawStride: Int {
        MemoryLayout<fat_header>.stride
    }
}
