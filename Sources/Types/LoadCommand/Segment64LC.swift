//
// Created by Mengyu Li on 2020/7/27.
//

import Foundation
import MachO

public struct Segment64LC: LoadCommand {
    public static let id: UInt32 = UInt32(LC_SEGMENT_64)

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
        segmentName = String(bytesTuple: command.segname)
        vmAddress = command.vmaddr
        vmSize = command.vmsize
        fileOffset = command.fileoff
        fileSize = command.filesize
        maxProtection = command.maxprot
        initProtection = command.initprot
        sectionCount = command.nsects
        flags = command.flags
        let sections: [section_64] = machData.get(atOffset: offset + MemoryLayout<segment_command_64>.size, count: Int(command.nsects))
        sectionHeaders = sections.map { section -> SectionHeader64 in SectionHeader64(section: section) }
    }
}
