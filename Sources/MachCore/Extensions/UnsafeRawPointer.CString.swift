//
// Created by Mengyu Li on 2020/9/29.
//

import struct Foundation.Data

public extension UnsafeRawPointer {
    mutating func readStringBytes() -> [UInt8] {
        let basePtr = self
        while load(as: UInt8.self) != 0 { self = advanced(by: 1) }
        // skip terminal 0
        defer { self = advanced(by: 1) }
        return [UInt8](UnsafeRawBufferPointer(start: basePtr, count: basePtr.distance(to: self)))
    }
}

public extension UnsafeRawPointer {
    func getString() -> String {
        var pointer = self
        let bytes = pointer.readStringBytes()
        switch String(data: Data(bytes), encoding: .utf8) {
        case .none:
            return bytes.reduce("0x") { (result, val: UInt8) -> String in result + String(format: "%02x", val) }
        case let .some(value):
            return value
        }
    }
}
