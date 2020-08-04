//
// Created by Mengyu Li on 2020/7/29.
//

import Foundation
import MachOParser

extension MutableFat {
	struct Architecture {
		private(set) var offset: UInt64
		private(set) var mach: MutableMach

		init(architecture: Fat.Architecture) {
			offset = architecture.offset
			mach = MutableMach(mach: architecture.mach)
		}
	}
}

extension MutableFat.Architecture {
	mutating func update(action: (inout MutableMach) throws -> ()) throws {
		var mutableMach = mach
		try action(&mutableMach)
		mach = mutableMach
	}
}
