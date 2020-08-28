//
// Created by Mengyu Li on 2020/7/29.
//

import Foundation

public protocol Option: Hashable, CaseIterable {
    var value: Int64 { get }
}

public extension Set where Element: Option {
    var rawValue: Int64 {
        var rawValue: Int64 = 0
        for element in Element.allCases {
            if contains(element) {
                rawValue |= element.value
            }
        }

        return rawValue
    }

    init(rawValue: Int64) {
        var result = [Element]()
        for element in Element.allCases {
            if rawValue & element.value == element.value {
                result.append(element)
            }
        }
        self = Set(result)
    }
}
