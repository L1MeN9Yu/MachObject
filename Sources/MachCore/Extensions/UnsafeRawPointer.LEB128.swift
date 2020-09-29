//
// Created by Mengyu Li on 2020/9/29.
//

extension UnsafeRawPointer {
    public mutating func readSleb128() -> Int64 {
        // continuation bit is 1 in default leb128 implementation
        readLeb128(continuationBitState: true)
    }

    public mutating func readNibSleb128() -> Int64 {
        // Nib file format uses uleb-like coding, but uses 0 as a continuation bit
        readLeb128(continuationBitState: false)
    }

    public mutating func readUleb128() -> UInt64 {
        // continuation bit is 1 in default leb128 implementation
        readLeb128(continuationBitState: true)
    }

    public mutating func readNibUleb128() -> UInt64 {
        // Nib file format uses uleb-like coding, but uses 0 as a continuation bit
        readLeb128(continuationBitState: false)
    }

    private mutating func readLeb128<T: FixedWidthInteger>(continuationBitState: Bool) -> T {
        var accumulator: T = 0
        var group: UInt8
        var shift: Int = 0
        let maxShift = (MemoryLayout<T>.size * 8) - 1
        repeat {
            if shift > maxShift {
                fatalError("sleb128 too long to be represented as \(T.self)")
            }
            group = load(as: UInt8.self)
            accumulator |= T(group & 0x7F) << shift
            shift += 7
            self = advanced(by: 1)
        } while (group & 0x80 != 0) == continuationBitState

        if T.isSigned {
            let isNegative = group >> 6 & 0x01 != 0
            if isNegative {
                accumulator |= ~T(0) << min(shift, maxShift) // 1-bit padding
            } else {
                accumulator &= T.max // clear sign bit (possible 1-bits overflow)
            }
        }

        return accumulator
    }
}
