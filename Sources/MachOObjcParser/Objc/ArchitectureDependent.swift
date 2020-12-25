//
// Created by Mengyu Li on 2020/12/25.
//

import Foundation

/// Objc metadata structures with different 32-bit and 64-bit versions.
public protocol ArchitectureDependent {
    /// Type of pointer for given architecture
    associatedtype PointerType: UnsignedInteger
}
