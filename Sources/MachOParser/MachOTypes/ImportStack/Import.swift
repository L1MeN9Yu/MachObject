//
// Created by Mengyu Li on 2020/12/29.
//

import Foundation

public typealias ImportStack = [Import]

public struct Import {
    public private(set) var dylibOrdinal: Int
    public let symbol: [UInt8]
    public let symbolRange: Range<UInt64>
    public let weak: Bool // should be skipped when dylib is missing
}

public extension Import {
    var symbolString: String {
        guard let symbolName = String(bytes: symbol, encoding: .utf8) else { fatalError() }
        return symbolName
    }
}

extension Import {
    mutating func update(dylibOrdinal: Int) { self.dylibOrdinal = dylibOrdinal }
}
