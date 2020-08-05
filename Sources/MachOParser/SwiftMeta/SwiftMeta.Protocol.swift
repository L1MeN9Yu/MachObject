//
// Created by Mengyu Li on 2020/8/5.
//

import Foundation

extension SwiftMeta {
	struct ProtocolType {
		let raw: ProtocolDescriptor
		let offset: Int
		let name: String
		let associatedTypeNames: String

		init(raw: ProtocolDescriptor, offset: Int, name: String, associatedTypeNames: String) {
			self.raw = raw
			self.offset = offset
			self.name = name
			self.associatedTypeNames = associatedTypeNames
		}
	}
}
