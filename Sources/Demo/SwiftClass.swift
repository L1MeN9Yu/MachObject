//
// Created by Mengyu Li on 2020/8/6.
//

import Foundation

class SwiftClass {
	let superValue: Int

	init(superValue: Int) { self.superValue = superValue }

	func superOverrideFunc() {}
}

extension SwiftClass {
	func superFunc() {}
}
