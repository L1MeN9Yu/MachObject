//
// Created by Mengyu Li on 2020/8/4.
//

import Foundation
import MachO

extension Section {
	public enum Name {}
}

public extension Section.Name {
	static let __text = SECT_TEXT
	static let __cstring = "__cstring"
}
