//
// Created by Mengyu Li on 2020/7/27.
//

import Foundation
import MachO

public struct Segment64LC: LoadCommand {
    public static let id = UInt32(LC_SEGMENT_64)

    public let segmentName: String /* segment name */
    public let vmAddress: UInt64 /* memory address of this segment */
    public let vmSize: UInt64 /* memory size of this segment */
    public let fileOffset: UInt64 /* file offset of this segment */
    public let fileSize: UInt64 /* amount to map from the file */
    public let maxProtection: vm_prot_t /* maximum VM protection */
    public let initProtection: vm_prot_t /* initial VM protection */
    public let sectionCount: UInt32 /* number of sections in segment */
    public let flags: UInt32 /* flags */

    public let sectionHeaders: [SectionHeader64]

    public init(machData: Data, offset: Int) {
        let command: segment_command_64 = machData.get(atOffset: offset)
        let sections: [section_64] = machData.get(atOffset: offset + MemoryLayout<segment_command_64>.stride, count: Int(command.nsects))
        self.init(command: command, sections: sections)
    }

    public init(pointer: UnsafeRawPointer) {
        let command: segment_command_64 = pointer.get()
        let sections_pointer = pointer.advanced(by: MemoryLayout<segment_command_64>.stride)
        let sections: [section_64] = sections_pointer.get(count: Int(command.nsects))
        self.init(command: command, sections: sections)
    }
}

private extension Segment64LC {
    init(command: segment_command_64, sections: [section_64]) {
        segmentName = String(tuple16: command.segname)
        vmAddress = command.vmaddr
        vmSize = command.vmsize
        fileOffset = command.fileoff
        fileSize = command.filesize
        maxProtection = command.maxprot
        initProtection = command.initprot
        sectionCount = command.nsects
        flags = command.flags

        sectionHeaders = sections.map { section -> SectionHeader64 in SectionHeader64(section: section) }
    }
}
