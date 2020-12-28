//
// Created by Mengyu Li on 2020/7/28.
//

import Foundation
import MachO

public extension Mach {
    var cStrings: [String] {
        var mutableSelf = self
        return mutableSelf.sections.reduce(into: [String]()) { (result: inout [String], section: Section) in
            if section.segmentName == SegmentName.__TEXT && section.segmentName == SectionName.__cstring {
                let cstring = Section.__Text__cstring(machoData: data, range: section.range)
                result.append(contentsOf: cstring.value)
            }

            if section.segmentName == SegmentName.__RODATA && section.segmentName == SectionName.__cstring {
                let cstring = Section.__Text__cstring(machoData: data, range: section.range)
                result.append(contentsOf: cstring.value)
            }
        }
    }
}
