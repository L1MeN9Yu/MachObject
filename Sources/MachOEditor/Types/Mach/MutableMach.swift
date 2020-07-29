//
// Created by Mengyu Li on 2020/7/29.
//

import Foundation
import MachObject

public struct MutableMach {
	public private(set) var data: Data

	init(mach: Mach) {
		data = mach.data
	}
}
