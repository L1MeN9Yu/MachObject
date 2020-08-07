//
// Created by Mengyu Li on 2020/8/7.
//

import Foundation

extension SwiftMeta {
	struct FieldDescriptor {
		let mangledTypeName: Int32
		let superclass: Int32
		let kind: UInt16
		let fieldRecordSize: UInt16
		let numFields: UInt32
		let fieldRecords: UnsafeRawPointer
	}
}

extension SwiftMeta.FieldDescriptor {
	func mangledTypeNameOffset(start: Int) -> Int {
		start + Int(mangledTypeName)
	}

	func fieldRecordsOffset(start: Int) -> Int {
		start +
			MemoryLayout.size(ofValue: mangledTypeName) +
			MemoryLayout.size(ofValue: superclass) +
			MemoryLayout.size(ofValue: kind) +
			MemoryLayout.size(ofValue: fieldRecordSize) +
			MemoryLayout.size(ofValue: numFields)
	}
}
