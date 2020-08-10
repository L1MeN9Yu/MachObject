//
// Created by Mengyu Li on 2020/8/5.
//

import Foundation

extension SwiftMeta {
	struct EnumDescriptor {
		let flags: UInt32
		let parent: Int32
		let name: Int32
		let accessFunction: Int32
		let fieldDescriptor: Int32
		let numPayloadCasesAndPayloadSizeOffset: UInt32
		let numEmptyCases: UInt32
	}
}

extension SwiftMeta.EnumDescriptor {
	func nameOffset(start: Int) -> Int {
		start +
			MemoryLayout.size(ofValue: flags) +
			MemoryLayout.size(ofValue: parent) +
			Int(name)
	}

	func accessFunctionOffset(start: Int) -> Int {
		start +
			MemoryLayout.size(ofValue: flags) +
			MemoryLayout.size(ofValue: parent) +
			MemoryLayout.size(ofValue: name) +
			Int(accessFunction)
	}
}
