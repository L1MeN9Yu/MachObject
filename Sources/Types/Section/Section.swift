//
// Created by Mengyu Li on 2020/7/24.
//

import Foundation
import MachO

public struct Section: Equatable {
    var name: String
    var range: Range<UInt64>

    init(_ section: section_64) {
        name = section.name
        range = Range(offset: UInt64(section.offset), count: section.size)
    }

    init(_ section: section) {
        name = section.name
        range = Range(offset: UInt64(section.offset), count: UInt64(section.size))
    }
}
