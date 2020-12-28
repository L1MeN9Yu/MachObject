//
// Created by Mengyu Li on 2020/7/24.
//

import CoreGraphics
import Foundation
import MachO

public struct Section {
    public let name: String
    public let segmentName: String
    public let range: Range<UInt64>
    public let align: UInt64 // power(2,sectionHeader align)
    public let count: UInt64

    init(sectionHeader: SectionHeader, machoData: Data) {
        name = sectionHeader.sectionName
        range = Range<UInt64>(offset: UInt64(sectionHeader.offset), count: UInt64(sectionHeader.size))
        segmentName = sectionHeader.segmentName
        align = UInt64(pow(CGFloat(2), CGFloat(sectionHeader.align)))
        count = UInt64(sectionHeader.size) / align
    }

    init(sectionHeader: SectionHeader64, machoData: Data) {
        name = sectionHeader.sectionName
        range = Range<UInt64>(offset: UInt64(sectionHeader.offset), count: sectionHeader.size)
        segmentName = sectionHeader.segmentName
        align = UInt64(pow(CGFloat(2), CGFloat(sectionHeader.align)))
        count = sectionHeader.size / align
    }
}

public extension Section {
    func content<T: SectionContent>(machData: Data) -> T {
        T(machoData: machData, range: range)
    }
}
