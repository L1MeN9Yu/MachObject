//
// Created by Mengyu Li on 2020/8/4.
//

import Foundation
import MachO

public struct SectionName: RawRepresentable {
    public typealias RawValue = String
    public let rawValue: RawValue

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension SectionName: Equatable {
    static func == (lhs: String, rhs: Self) -> Bool {
        lhs == rhs.rawValue
    }
}

public extension SectionName {
    static let __text = Self(rawValue: SECT_TEXT)
    static let __cstring = Self(rawValue: "__cstring")
    static let __const = Self(rawValue: "__const")
}
