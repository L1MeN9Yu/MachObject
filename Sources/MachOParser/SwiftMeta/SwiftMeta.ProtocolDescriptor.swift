//
// Created by Mengyu Li on 2020/8/4.
//

import Foundation

extension SwiftMeta {
	struct ProtocolDescriptor {
		let flags: UInt32
		let parent: Int32
		let name: Int32 // offset
		let numRequirementsInSignature: UInt32
		let numRequirements: UInt32
		let associatedTypeNames: Int32 // offset
	}
}

extension SwiftMeta.ProtocolDescriptor {
	func nameOffset(start: Int) -> Int {
		start +
			MemoryLayout.size(ofValue: flags) +
			MemoryLayout.size(ofValue: parent) +
			Int(name)
	}

	func associatedTypeNamesOffset(start: Int) -> Int {
		start +
			MemoryLayout.size(ofValue: flags) +
			MemoryLayout.size(ofValue: parent) +
			MemoryLayout.size(ofValue: name) +
			MemoryLayout.size(ofValue: numRequirementsInSignature) +
			MemoryLayout.size(ofValue: numRequirements) +
			Int(associatedTypeNames)
	}
}
