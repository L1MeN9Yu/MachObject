//
// Created by Mengyu Li on 2020/7/9.
//

import Foundation
import MachO

public struct MachHeader64 {
    public let magic: UInt32
    public let cpuType: cpu_type_t
    public let cpuSubtype: cpu_subtype_t
    public let fileType: UInt32
    public let commandCount: UInt32
    public let commandSize: UInt32
    public let flags: UInt32
    public let reserved: UInt32

    public init(header: mach_header_64) {
        magic = header.magic
        cpuType = header.cputype
        cpuSubtype = header.cpusubtype
        fileType = header.filetype
        commandCount = header.ncmds
        commandSize = header.sizeofcmds
        flags = header.flags
        reserved = header.reserved
    }
}

extension MachHeader64 {
    var rawStride: Int {
        MemoryLayout<mach_header_64>.stride
    }
}
