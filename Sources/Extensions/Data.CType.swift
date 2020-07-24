//
// Created by Mengyu Li on 2020/7/23.
//

import struct Foundation.Data

extension Data {
    func get<T>(atOffset offset: Int) -> T {
        withUnsafeBytes { $0.baseAddress!.advanced(by: offset).get() }
    }

    func get<T>(atOffset offset: Int, count: Int) -> [T] {
        withUnsafeBytes { $0.baseAddress!.advanced(by: offset).get(count: count) }
    }

    func get<T>(fromRange range: Range<Int>) -> [T] {
        get(atOffset: range.startIndex, count: range.count / MemoryLayout<T>.stride)
    }

    func get(atOffset offset: Int) -> String {
        withUnsafeBytes {
            $0.bindMemory(to: UInt8.self).baseAddress!.advanced(by: offset) |> String.init(cString:)
        }
    }
}
