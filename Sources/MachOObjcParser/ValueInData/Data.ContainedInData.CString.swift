//
// Created by Mengyu Li on 2020/12/25.
//

import Foundation
import MachCore

public extension Data {
    func getCString<T>(atOffset offset: Int) -> T where T: ContainedInData, T.ValueType == String {
        let value = get(atOffset: offset)
        let range = offset..<offset + value.utf8.count
        return T(value: value, range: range)
    }
}
