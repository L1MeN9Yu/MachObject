//
// Created by Mengyu Li on 2020/7/24.
//

import Foundation
import MachO

public struct SegmentLC: LoadCommand {
    public typealias Command = segment_command
    public static let id: UInt32 = UInt32(LC_SEGMENT)

    let segment: Segment

    public init(machData: Data, offset: Int) {
        let rawSegment: segment_command = machData.get(atOffset: offset)
        let sections: [section] = machData.get(atOffset: offset + MemoryLayout<segment_command>.size, count: Int(rawSegment.nsects))
        segment = Segment(segment: rawSegment, sections: sections)
    }
}
