//
// Created by Mengyu Li on 2020/8/5.
//

import Foundation

extension SwiftMeta {
    struct ContextDescriptorFlags {
        let value: UInt32
        /// The kind of context this descriptor describes.
        let kind: ContextDescriptorKind?
        /// Whether the context being described is generic.
        let isGeneric: Bool
        /// Whether this is a unique record describing the referenced context.
        let isUnique: Bool
        /// The format version of the descriptor. Higher version numbers may have
        /// additional fields that aren't present in older versions.
        let version: UInt8
        /// The most significant two bytes of the flags word, which can have
        /// kind-specific meaning.
        let kindSpecificFlags: UInt16

        init(value: UInt32) {
            self.value = value

            kind = ContextDescriptorKind(value: value & 0x1F)
            isGeneric = (value & 0x80) != 0
            isUnique = (value & 0x40) != 0
            version = UInt8((value >> 8) & 0xFF)
            kindSpecificFlags = UInt16((value >> 16) & 0xFFFF)
        }
    }
}
