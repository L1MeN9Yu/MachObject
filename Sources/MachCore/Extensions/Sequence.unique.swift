//
// Created by Mengyu Li on 2020/12/29.
//

import Foundation

public extension Sequence where Element: Hashable {
    var unique: Set<Element> { Set(self) }
}
