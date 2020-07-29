//
// Created by Mengyu Li on 2020/7/28.
//

import Foundation

public struct SourceVersion {
	public let a: UInt64
	public let b: UInt64
	public let c: UInt64
	public let d: UInt64
	public let e: UInt64

	init(version: UInt64) {
		a = (version >> 40) & 0xFFFFFF
		b = (version >> 30) & 0x3FF
		c = (version >> 20) & 0x3FF
		d = (version >> 10) & 0x3FF
		e = (version >> 0) & 0x3FF
	}
}

extension SourceVersion: CustomStringConvertible {
	public var description: String { "\(a).\(b).\(c).\(d).\(e)" }
}
