//
// Created by Mengyu Li on 2020/7/28.
//

import Foundation

public extension Section {
    struct __Text__cstring: SectionContent {
        public typealias Value = [String]
        public let value: Value

        public init(machoData: Data, range: Range<UInt64>) {
            value = machoData.subdata(in: range.intRange).split(separator: 0).compactMap { sequence -> String? in
                String(bytes: sequence, encoding: .utf8)
            }
        }

        public static var segmentName: SegmentName = .__TEXT

        public static var sectionName: SectionName = .__cstring
    }
}
