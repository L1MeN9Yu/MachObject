//
// Created by Mengyu Li on 2020/12/25.
//

import Foundation

public struct MangledObjcClassNameInData: ContainedInData {
    public typealias ValueType = String
    public let value: ValueType
    public let range: Range<Int>

    public init(value: ValueType, range: Range<Int>) {
        precondition(value.utf8.count == range.count)

        self.value = value
        self.range = range
    }
}

public extension MangledObjcClassNameInData {
    var isSwift: Bool { value.starts(with: "_Tt") }
}
