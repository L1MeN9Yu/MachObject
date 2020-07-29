//
// Created by Mengyu Li on 2020/7/29.
//

import Foundation
import MachObject

extension MutableImage {
	public enum Content {
		case fat(MutableFat)
		case mach(MutableMach)

		init(content: Image.Content) {
			switch content {
			case let .fat(fat):
				self = .fat(MutableFat(fat: fat))
			case let .mach(mach):
				self = .mach(MutableMach(mach: mach))
			}
		}
	}
}
