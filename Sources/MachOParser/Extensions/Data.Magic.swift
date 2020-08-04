//
// Created by Mengyu Li on 2020/7/23.
//

import struct Foundation.Data

extension Data {
	typealias SizeType = UInt32
	var magic: SizeType? {
		guard count >= MemoryLayout<SizeType>.size else { return nil }
		return withUnsafeBytes { $0.load(as: SizeType.self) }
	}
}
