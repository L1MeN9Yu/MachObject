//
// Created by Mengyu Li on 2020/8/4.
//

import Foundation

struct SwiftParser {}

extension SwiftParser {
	static func parseProtos(mach: Mach) -> [SwiftMeta.ProtocolType] {
		var protocols = [SwiftMeta.ProtocolType]()
		guard let protosSection = mach.section(of: Section.SegmentName.__TEXT, name: Section.Name.__swift5_protos) else {
			return protocols
		}

		for index in 0..<protosSection.count {
			let indexOffset = index * protosSection.align + protosSection.range.lowerBound
			let localOffset: Int32 = mach.data.get(atOffset: Int(indexOffset))
			let protocolDescriptorOffset = Int(indexOffset) + Int(localOffset)
			let protocolDescriptor: SwiftMeta.ProtocolDescriptor = mach.data.get(atOffset: protocolDescriptorOffset)
			let nameOffset = protocolDescriptor.nameOffset(start: protocolDescriptorOffset)
			let name = mach.data.get(atOffset: nameOffset)

			func parseAssociatedTypeNames() -> String {
				if protocolDescriptor.associatedTypeNames != 0 {
					let associatedTypeNamesOffset = protocolDescriptor.associatedTypeNamesOffset(start: protocolDescriptorOffset)
					let associatedTypeNames = mach.data.get(atOffset: associatedTypeNamesOffset)
					return associatedTypeNames
				} else {
					return ""
				}
			}

			let associatedTypeNames = parseAssociatedTypeNames()
			let `protocol` = SwiftMeta.ProtocolType(
				raw: protocolDescriptor, offset: protocolDescriptorOffset,
				name: name, associatedTypeNames: associatedTypeNames
			)
			protocols.append(`protocol`)
		}
		return protocols
	}
}
