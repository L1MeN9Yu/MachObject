//
// Created by Mengyu Li on 2020/7/24.
//

import Foundation
import MachO

public struct SegmentLC: LoadCommand {
    public static let id = UInt32(LC_SEGMENT)

    public let segmentName: String
    public let vmAddress: UInt32 /* memory address of this segment */
    public let vmSize: UInt32 /* memory size of this segment */
    public let fileOffset: UInt32 /* file offset of this segment */
    public let fileSize: UInt32 /* amount to map from the file */
    public let maxProtection: vm_prot_t /* maximum VM protection */
    public let initProtection: vm_prot_t /* initial VM protection */
    public let sectionCount: UInt32 /* number of sections in segment */
    public let flags: UInt32 /* flags */

    public let sectionHeaders: [SectionHeader]

    public init(machData: Data, offset: Int) {
        let command: segment_command = machData.get(atOffset: offset)
        let sections: [section] = machData.get(atOffset: offset + MemoryLayout<segment_command>.stride, count: Int(command.nsects))
        self.init(command: command, sections: sections)
    }

    public init(pointer: UnsafeRawPointer) {
        let command: segment_command = pointer.get()
        let sections_pointer = pointer.advanced(by: MemoryLayout<segment_command>.stride)
        let sections: [section] = sections_pointer.get(count: Int(command.nsects))
        self.init(command: command, sections: sections)
    }
}

private extension SegmentLC {
    init(command: segment_command, sections: [section]) {
        segmentName = String(tuple16: command.segname)
        vmAddress = command.vmaddr
        vmSize = command.vmsize
        fileOffset = command.fileoff
        fileSize = command.filesize
        maxProtection = command.maxprot
        initProtection = command.initprot
        sectionCount = command.nsects
        flags = command.flags

        sectionHeaders = sections.map { section -> SectionHeader in SectionHeader(section: section) }
    }
}
