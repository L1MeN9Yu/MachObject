//
// Created by Mengyu Li on 2020/7/28.
//

import Foundation
import MachO

extension Section {
	public enum Content {
		case raw(Common)
		case __Text__cstring(__Text__cstring)
		case __RODATA__cstring(__RODATA__cstring)

		init(segmentName: String, name: String, machoData: Data, range: Range<UInt64>) {
			switch (segmentName, name) {
			case (Self.__Text, Self.__cstring):
				self = .__Text__cstring(Section.__Text__cstring(machoData: machoData, range: range))
			case (Self.__RODATA, Self.__cstring):
				self = .__RODATA__cstring(Section.__RODATA__cstring(machoData: machoData, range: range))
			default:
				self = .raw(Common(machoData: machoData, range: range))
			}
		}

		public static let __Text = SEG_TEXT
		public static let __Data = SEG_DATA
		public static let __RODATA = "__RODATA"

		public static let __text = "__text"
		public static let __cstring = "__cstring"
	}
}
