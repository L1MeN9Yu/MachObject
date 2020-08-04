//
// Created by Mengyu Li on 2020/8/4.
//

import Foundation
import MachO

extension Section {
	public enum SegmentName {}
}

public extension Section.SegmentName {
	static let __TEXT = SEG_TEXT
	static let __DATA = SEG_DATA
	static let __DATA_CONST = "__DATA_CONST"
	static let __RODATA = "__RODATA"
}
