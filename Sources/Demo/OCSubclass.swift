//
// Created by Mengyu Li on 2020/8/7.
//

import Foundation

class OCSubclass: OCClass {
	let subValue: Int

	init(value: Int, subValue: Int) {
		self.subValue = subValue
		super.init(value: value)
	}
}

extension OCSubclass {
	override func superFunc() {
		super.superFunc()
	}
}

extension OCSubclass {
	@objc
	func subFunc() {}
}
