//
// Created by Mengyu Li on 2020/8/4.
//

import Foundation
import MachO

public struct SegmentName: RawRepresentable {
    public typealias RawValue = String
    public let rawValue: RawValue

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension SegmentName: Equatable {
    static func == (lhs: String, rhs: Self) -> Bool {
        lhs == rhs.rawValue
    }
}

public extension SegmentName {
    static let __TEXT = Self(rawValue: SEG_TEXT)
    static let __DATA = Self(rawValue: SEG_DATA)
    static let __DATA_CONST = Self(rawValue: "__DATA_CONST")
    static let __RODATA = Self(rawValue: "__RODATA")
}
