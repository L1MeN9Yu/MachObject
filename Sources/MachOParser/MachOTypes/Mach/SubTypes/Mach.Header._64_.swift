//
// Created by Mengyu Li on 2022/10/7.
//

import Foundation
import MachO

public extension Mach.Header {
    struct _64_ {
        public let magic: UInt32
        public let cpuType: CPUType
        public let cpuSubtype: CPUSubType
        public let fileType: FileType
        public let commandCount: UInt32
        public let commandSize: UInt32
        public let flags: Flags
        public let reserved: UInt32

        public init(header: mach_header_64) throws {
            magic = header.magic
            cpuType = CPUType(cpuType: header.cputype)
            cpuSubtype = CPUSubType(cpu_subtype: header.cpusubtype)
            fileType = try FileType(fileType: header.filetype)
            commandCount = header.ncmds
            commandSize = header.sizeofcmds
            flags = Flags(rawValue: Int64(header.flags))
            reserved = header.reserved
        }
    }
}

public extension Mach.Header._64_ {
    static var rawSize: Int {
        MemoryLayout<mach_header_64>.size
    }

    static var rawStride: Int {
        MemoryLayout<mach_header_64>.stride
    }

    var rawSize: Int {
        MemoryLayout<mach_header_64>.size
    }

    var rawStride: Int {
        MemoryLayout<mach_header_64>.stride
    }
}
