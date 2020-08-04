//
// Created by Mengyu Li on 2020/7/24.
//

import Foundation
import MachO

public struct Section {
	public let name: String
	public let segmentName: String
	public let range: Range<UInt64>
	public let content: Content

	init(sectionHeader: SectionHeader, machoData: Data) {
		name = sectionHeader.sectionName
		range = Range(offset: UInt64(sectionHeader.offset), count: UInt64(sectionHeader.size))
		segmentName = sectionHeader.segmentName
		content = Content(segmentName: segmentName, name: name, machoData: machoData, range: range)
	}

	init(sectionHeader: SectionHeader64, machoData: Data) {
		name = sectionHeader.sectionName
		range = Range(offset: UInt64(sectionHeader.offset), count: sectionHeader.size)
		segmentName = sectionHeader.segmentName
		content = Content(segmentName: segmentName, name: name, machoData: machoData, range: range)
	}
}
