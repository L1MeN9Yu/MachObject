//
// Created by Mengyu Li on 2020/12/28.
//

import Foundation
@_implementationOnly import MachCore

public struct Segment {
    public let name: String
    public let vmRange: Range<UInt64>
    public let fileRange: Range<UInt64>
    public let sections: [Section]
}

public extension Segment {
    init(machData: Data, segmentLC: SegmentLC) {
        name = segmentLC.segmentName
        vmRange = Range(offset: UInt64(segmentLC.vmAddress), count: UInt64(segmentLC.vmSize))
        fileRange = Range(offset: UInt64(segmentLC.fileOffset), count: UInt64(segmentLC.fileSize))
        sections = segmentLC.sectionHeaders.map { Section(sectionHeader: $0, machoData: machData) }
    }

    init(machData: Data, segment64LC: Segment64LC) {
        name = segment64LC.segmentName
        vmRange = Range(offset: segment64LC.vmAddress, count: segment64LC.vmSize)
        fileRange = Range(offset: segment64LC.fileOffset, count: segment64LC.fileSize)
        sections = segment64LC.sectionHeaders.map { Section(sectionHeader: $0, machoData: machData) }
    }
}
