//
// Created by Mengyu Li on 2020/7/27.
//

import Foundation
import MachO

public struct SectionHeader64 {
    public let sectionName: String /* for 64-bit architectures */ /* name of this section */
    public let segmentName: String /* segment this section goes in */
    public let address: UInt64 /* memory address of this section */
    public let size: UInt64 /* size in bytes of this section */
    public let offset: UInt32 /* file offset of this section */
    public let align: UInt32 /* section alignment (power of 2) */
    public let relocationOffset: UInt32 /* file offset of relocation entries */
    public let relocationCount: UInt32 /* number of relocation entries */
    public let flags: UInt32 /* flags (section type and attributes)*/
    public let reserved1: UInt32 /* reserved (for offset or index) */
    public let reserved2: UInt32 /* reserved (for count or sizeof) */
    public let reserved3: UInt32 /* reserved */

    init(section: section_64) {
        sectionName = String(tuple16: section.sectname)
        segmentName = String(tuple16: section.segname)
        address = section.addr
        size = section.size
        offset = section.offset
        align = section.align
        relocationOffset = section.reloff
        relocationCount = section.nreloc
        flags = section.flags
        reserved1 = section.reserved1
        reserved2 = section.reserved2
        reserved3 = section.reserved3
    }
}
