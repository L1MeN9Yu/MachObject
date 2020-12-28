//
// Created by Mengyu Li on 2020/7/28.
//

import Foundation
import MachO

public extension Mach {
    var cStrings: [String] {
        var mutableSelf = self
        return mutableSelf.sections.reduce(into: [String]()) { (result: inout [String], section: Section) in
            switch section.content {
            case .raw:
                return
            case let .__Text__cstring(content):
                result.append(contentsOf: content.value)
            case let .__RODATA__cstring(content):
                result.append(contentsOf: content.value)
            }
        }
    }
}
