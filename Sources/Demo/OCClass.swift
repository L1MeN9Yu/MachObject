//
// Created by Mengyu Li on 2020/8/6.
//

import Foundation

class OCClass: NSObject {
    let value: Int
    @objc
    let cache: NSCache<AnyObject, AnyObject> = NSCache()

    init(value: Int) {
        self.value = value
        super.init()
    }
}

extension OCClass {
    @objc
    func superFunc() {}
}
