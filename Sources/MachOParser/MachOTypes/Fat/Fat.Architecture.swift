//
// Created by Mengyu Li on 2020/7/24.
//

import Foundation
@_implementationOnly import MachCore
import MachO

public extension Fat {
    enum Architecture {
        case _32(_32_)
        case _64(_64_)
    }
}

public extension Fat.Architecture {
    var mach: Mach {
        switch self {
        case let ._32(content):
            return content.mach
        case let ._64(content):
            return content.mach
        }
    }

    var offset: UInt64 {
        switch self {
        case let ._32(content):
            return UInt64(content.offset)
        case let ._64(content):
            return content.offset
        }
    }
}

public extension Fat.Architecture {
    struct _32_ {
        public let cpuType: CPUType
        public let cpuSubType: CPUSubType
        public let offset: UInt32
        public let size: UInt32
        public let align: UInt32
        public let mach: Mach

        init(data: Data, arch: fat_arch, byteOrder: ByteOrder) throws {
            switch byteOrder {
            case .little:
                cpuType = CPUType(cpuType: arch.cputype.bigEndian)
                cpuSubType = CPUSubType(cpu_subtype: arch.cpusubtype.bigEndian)
                offset = arch.offset.bigEndian
                size = arch.size.bigEndian
                align = arch.align.bigEndian
            case .big:
                cpuType = CPUType(cpuType: arch.cputype)
                cpuSubType = CPUSubType(cpu_subtype: arch.cpusubtype)
                offset = arch.offset
                size = arch.size
                align = arch.align
            }

            let range: Range<Data.Index> = Int(offset)..<Int(offset + size)
            let subData = data.subdata(in: range)
            mach = try Mach(data: subData)
        }
    }
}

public extension Fat.Architecture {
    struct _64_ {
        public let cpuType: CPUType
        public let cpuSubType: CPUSubType
        public let offset: UInt64
        public let size: UInt64
        public let align: UInt32
        public let reserved: UInt32
        public let mach: Mach

        init(data: Data, arch: fat_arch_64, byteOrder: ByteOrder) throws {
            switch byteOrder {
            case .little:
                cpuType = CPUType(cpuType: arch.cputype.bigEndian)
                cpuSubType = CPUSubType(cpu_subtype: arch.cpusubtype.bigEndian)
                offset = arch.offset.bigEndian
                size = arch.size.bigEndian
                align = arch.align.bigEndian
                reserved = arch.reserved.bigEndian
            case .big:
                cpuType = CPUType(cpuType: arch.cputype)
                cpuSubType = CPUSubType(cpu_subtype: arch.cpusubtype)
                offset = arch.offset
                size = arch.size
                align = arch.align
                reserved = arch.reserved
            }

            let range: Range<Data.Index> = Int(offset)..<Int(offset + size)
            let subData = data.subdata(in: range)
            mach = try Mach(data: subData)
        }
    }
}
