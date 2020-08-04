//
// Created by Mengyu Li on 2020/7/29.
//

import Foundation
import MachOParser

struct MutableFat {
	var data: Data
	var architectures: [Architecture]

	init(fat: Fat) {
		data = fat.data
		architectures = fat.architectures.map { architecture -> Architecture in
			Architecture(architecture: architecture)
		}
	}
}
