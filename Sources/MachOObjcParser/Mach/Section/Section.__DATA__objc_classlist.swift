//
// Created by Mengyu Li on 2020/12/25.
//

import Foundation
import MachOParser

public extension Section {
    struct __DATA__objc_classlist: SectionContent {
        public typealias Value = Data
        public let value: Value

        public init(machoData: Data, range: Range<UInt64>) {
            value = machoData.subdata(in: range.intRange)
        }

        public private(set) static var segmentName: SegmentName = .__DATA
        public private(set) static var sectionName: SectionName = .__objc_classlist
    }
}
