//
// Created by Mengyu Li on 2020/7/29.
//

import Foundation
import MachObject

public struct MutableFat {
	public var data: Data
	public var architectures: [Architecture]

	init(fat: Fat) {
		data = fat.data
		architectures = fat.architectures.map { architecture -> Architecture in Architecture(architecture: architecture) }
	}
}
