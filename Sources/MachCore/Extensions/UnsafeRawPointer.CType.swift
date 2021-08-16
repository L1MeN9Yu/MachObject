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
