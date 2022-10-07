//
// Created by Mengyu Li on 2020/7/29.
//

public protocol Option: Hashable, CaseIterable {
    var value: Int64 { get }
}

extension Set: RawRepresentable where Element: Option {
    public typealias RawValue = Int64
    public var rawValue: RawValue {
        var rawValue: Int64 = 0
        for element in Element.allCases {
            if contains(element) {
                rawValue |= element.value
            }
        }

        return rawValue
    }

    public init(rawValue: RawValue) {
        var result = [Element]()
        for element in Element.allCases {
            if rawValue & element.value == element.value {
                result.append(element)
            }
        }
        self = Set(result)
    }
}
