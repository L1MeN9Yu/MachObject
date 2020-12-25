//
// Created by Mengyu Li on 2020/12/25.
//

import Foundation

public extension Section {
    struct __Text__objc_classname: SectionContent {
        public typealias Value = Data
        public let value: Value

        public init(machoData: Data, range: Range<UInt64>) {
            value = machoData.subdata(in: range.intRange)
        }
    }
}
