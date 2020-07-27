//
// Created by Mengyu Li on 2020/7/24.
//

import Foundation
import MachO

public struct SegmentLC: LoadCommand {
    public static let id: UInt32 = UInt32(LC_SEGMENT)

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
        segmentName = String(bytesTuple: command.segname)
        vmAddress = command.vmaddr
        vmSize = command.vmsize
        fileOffset = command.fileoff
        fileSize = command.filesize
        maxProtection = command.maxprot
        initProtection = command.initprot
        sectionCount = command.nsects
        flags = command.flags
        let sections: [section] = machData.get(atOffset: offset + MemoryLayout<segment_command>.size, count: Int(command.nsects))
        sectionHeaders = sections.map { section -> SectionHeader in SectionHeader(section: section) }
    }
}
