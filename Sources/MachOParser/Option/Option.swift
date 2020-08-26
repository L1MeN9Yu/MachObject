//
// Created by Mengyu Li on 2020/7/29.
//

import Foundation

public protocol Option: Hashable, CaseIterable {
    var value: Int { get }
}

extension Set where Element: Option {
    var rawValue: Int {
        var rawValue: Int = 0
        for element in Element.allCases {
            if contains(element) {
                rawValue |= element.value
            }
        }

        return rawValue
    }

    init(rawValue: Int) {
        var result = [Element]()
        for element in Element.allCases {
            if rawValue & element.value == element.value {
                result.append(element)
            }
        }
        self = Set(result)
    }
}
