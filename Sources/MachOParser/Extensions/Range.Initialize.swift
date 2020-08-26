//
// Created by Mengyu Li on 2020/7/24.
//

public extension Range where Bound: BinaryInteger {
    init(offset: Bound, count: Bound) {
        self = offset..<(offset + count)
    }

    var intRange: Range<Int> { Int(lowerBound)..<Int(upperBound) }
}
