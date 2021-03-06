//
// Created by Mengyu Li on 2020/8/4.
//

import Foundation
import MachOParser

enum Error: Swift.Error {
    case replaceStringLength
    case sectionNotFound(name: SegmentName)
}
