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

    func get(atOffset offset: Int, fallbackConvert: Bool = false) -> String {
        withUnsafeBytes {
            switch fallbackConvert {
            case false:
                return $0.bindMemory(to: UInt8.self).baseAddress!.advanced(by: offset) |> String.init(cString:)
            case true:
                var address: Int = offset
                var result: [UInt8] = []
                while true {
                    let val: UInt8 = self[address]
                    if val == 0 { break }
                    address += 1
                    result.append(val)
                }

                if let str = String(bytes: result, encoding: String.Encoding.ascii) {
                    if str.isASCII { return str }
                }

                return result.reduce("0x") { (result, val: UInt8) -> String in result + String(format: "%02x", val) }
            }
        }
    }
}
