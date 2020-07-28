//
// Created by Mengyu Li on 2020/7/23.
//

import Foundation
import MachO

public struct Fat {
	var data: Data
	var architectures: [Architecture]
}

extension Fat {
	init(data: Data) throws {
		self.data = data
		let header: fat_header = data.get(atOffset: 0)
		let archs: [fat_arch] = data.get(
			atOffset: MemoryLayout<fat_header>.size,
			count: Int(header.nfat_arch.byteSwapped)
		)
		architectures = try archs.map { arch in
			try Fat.Architecture(data: data, arch: arch)
		}
	}
}
