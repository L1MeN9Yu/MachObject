//
// Created by Mengyu Li on 2020/8/6.
//

import Foundation

class SwiftSubclass: SwiftClass {
    let subValue: Int

    init(superValue: Int, subValue: Int) {
        self.subValue = subValue
        super.init(superValue: superValue)
    }

    override func superOverrideFunc() {
        super.superOverrideFunc()
    }
}

extension SwiftSubclass {
    func subFunc() {}
}
