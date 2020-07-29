//
// Created by Mengyu Li on 2020/7/29.
//

import Foundation
import MachObject

extension MutableFat {
	public struct Architecture {
		public private(set) var offset: UInt64
		public private(set) var mach: MutableMach

		init(architecture: Fat.Architecture) {
			offset = architecture.offset
			mach = MutableMach(mach: architecture.mach)
		}
	}
}

extension MutableFat.Architecture {
	mutating func update(action: (inout MutableMach) -> ()) {
		var mutableMach = mach
		action(&mutableMach)
		mach = mutableMach
	}
}
