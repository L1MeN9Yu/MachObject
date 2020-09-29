//
// Created by Mengyu Li on 2020/9/29.
//

extension UnsafeRawPointer {
    public mutating func readStringBytes() -> [UInt8] {
        let basePtr = self
        while load(as: UInt8.self) != 0 { self = advanced(by: 1) }
        // skip terminal 0
        defer { self = advanced(by: 1) }
        return [UInt8](UnsafeRawBufferPointer(start: basePtr, count: basePtr.distance(to: self)))
    }
}
