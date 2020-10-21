//
// Created by Mengyu Li on 2020/10/21.
//

import Foundation

extension Data {
    var uint64: UInt64? {
        guard count <= 8 else { return nil }

        var value: UInt64 = 0
        for (index, byte) in enumerated() {
            value += UInt64(byte) << UInt64(8 * (count - index - 1))
        }
        return value
    }
}
