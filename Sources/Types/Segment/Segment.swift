//
// Created by Mengyu Li on 2020/7/24.
//

import Foundation
import MachO

public struct Segment: Equatable {
	var name: String
	var vmRange: Range<UInt64>
	var fileRange: Range<UInt64>
	var sections: [Section]

	init(segment: segment_command_64, sections: [section_64]) {
		name = segment.name
		vmRange = Range(offset: segment.vmaddr, count: segment.vmsize)
		fileRange = Range(offset: segment.fileoff, count: segment.filesize)
		self.sections = sections.map { Section($0) }
	}

	init(segment: segment_command, sections: [section]) {
		name = segment.name
		vmRange = Range(offset: UInt64(segment.vmaddr), count: UInt64(segment.vmsize))
		fileRange = Range(offset: UInt64(segment.fileoff), count: UInt64(segment.filesize))
		self.sections = sections.map { Section($0) }
	}
}
