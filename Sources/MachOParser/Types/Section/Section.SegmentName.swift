//
// Created by Mengyu Li on 2020/8/4.
//

import Foundation
import MachO

extension Section {
	public enum SegmentName {}
}

public extension Section.SegmentName {
	static let __Text = SEG_TEXT
	static let __Data = SEG_DATA
	static let __RODATA = "__RODATA"
}
