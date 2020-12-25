//
// Created by Mengyu Li on 2020/12/25.
//

import Foundation
import MachOParser

public extension Section {
    func contains<ContainedInDataType: ContainedInData>(data: ContainedInDataType) -> Bool {
        range.intRange.overlaps(data.range)
    }
}
