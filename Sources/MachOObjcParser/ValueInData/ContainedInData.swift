//
// Created by Mengyu Li on 2020/12/25.
//

import Foundation

/// Value that is loaded from Mach-O image and is stored at a specific location in it
public protocol ContainedInData {
    associatedtype ValueType
    init(value: ValueType, range: Range<Int>)
    var value: ValueType { get }
    var range: Range<Int> { get }
}

public extension CustomStringConvertible where Self: ContainedInData {
    var description: String { "'\(value)'[\(range)]" }
}
