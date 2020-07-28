//
// Created by Mengyu Li on 2020/7/28.
//

import Foundation
import MachO

extension Mach {
	static func parseSections(loadCommands: [LoadCommand], machoData: Data) -> [Section] {
		let sections = loadCommands.reduce(into: [Section]()) { (result: inout [Section], loadCommand: LoadCommand) in
			if let segmentLC = loadCommand as? SegmentLC {
				let sections = segmentLC.sectionHeaders.compactMap { Section(sectionHeader: $0, machoData: machoData) }
				result.append(contentsOf: sections)
			}
			if let segment64LC = loadCommand as? Segment64LC {
				let sections = segment64LC.sectionHeaders.compactMap { Section(sectionHeader: $0, machoData: machoData) }
				result.append(contentsOf: sections)
			}
		}
		return sections
	}
}

private extension Mach {
	static func parseSections(segmentLC: SegmentLC, machoData: Data) -> [Section] {
		let sections = segmentLC.sectionHeaders.compactMap { sectionHeader -> Section? in
			Section(sectionHeader: sectionHeader, machoData: machoData)
		}
		return sections
	}

	static func parseSections(segmentLC: Segment64LC, machoData: Data) -> [Section] {
		let sections = segmentLC.sectionHeaders.compactMap { sectionHeader -> Section? in
			Section(sectionHeader: sectionHeader, machoData: machoData)
		}
		return sections
	}
}

public extension Mach {
	var cStrings: [String] {
		sections.reduce(into: [String]()) { (result: inout [String], section: Section) in
			switch section.content {
			case .raw:
				return
			case let .__Text__cstring(content):
				result.append(contentsOf: content.value)
			case let .__RODATA__cstring(content):
				result.append(contentsOf: content.value)
			}
		}
	}
}
