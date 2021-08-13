//
// Created by Mengyu Li on 2020/7/23.
//

import Foundation

public extension UnsafeRawPointer {
    func get<T>() -> T {
        bindMemory(to: T.self, capacity: 1).pointee
    }

    func get<T>(count: Int) -> [T] {
        bindMemory(to: T.self, capacity: count)
            |> { t in UnsafeBufferPointer<T>(start: t, count: count) }
            |> [T].init
    }
}

public extension UnsafeRawPointer {
    func getString() -> String {
        let pointer = assumingMemoryBound(to: UInt8.self)
        var address: Int = 0
        var result: [UInt8] = []
        while true {
            let val: UInt8 = pointer[address]
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

public extension UnsafeRawPointer {
    mutating func read<T>() -> T {
        defer {
            self = advanced(by: MemoryLayout<T>.stride)
        }
        return get()
    }

    mutating func read<T>(count: Int) -> [T] {
        defer {
            self = advanced(by: MemoryLayout<T>.stride * count)
        }
        return get(count: count)
    }
}
