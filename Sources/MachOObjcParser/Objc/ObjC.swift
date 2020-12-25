//
// Created by Mengyu Li on 2020/12/25.
//

import Foundation

public enum ObjC {}

// https://opensource.apple.com/source/objc4/objc4-750.1/runtime/objc-runtime-new.h.auto.html
public extension ObjC {
    struct class_64: ImageObjClass {
        public typealias PointerType = UInt64

        public var isa: UInt64
        public var superclass: UInt64
        public var cacheBuckets: UInt64
        public var cacheMask: UInt32
        public var cacheOccupied: UInt32
        public var bits: PointerType

        public typealias RODataType = class_ro_64
        public var data: PointerType { bits & 0x0000_7FFF_FFFF_FFF8 }
    }

    struct class_ro_64: ImageObjClassRO {
        public typealias PointerType = UInt64

        public var flags: UInt32
        public var instanceStart: UInt32
        public var instanceSize: UInt32
        public var reserved: UInt32 // only for 64bit
        public var ivarLayout: PointerType
        public var name: PointerType
        public var baseMethodList: PointerType
        public var baseProtocols: PointerType
        public var ivars: PointerType
        public var weakIvarLayout: PointerType
        public var baseProperties: PointerType
    }

    struct class_32: ImageObjClass {
        public typealias PointerType = UInt32

        public var isa: UInt32
        public var superclass: UInt32
        public var cacheBuckets: UInt32
        public var cacheMask: UInt16
        public var cacheOccupied: UInt16
        public var bits: PointerType

        public typealias RODataType = class_ro_32
        public var data: PointerType { bits & 0xFFFF_FFFC }
    }

    struct class_ro_32: ImageObjClassRO {
        public typealias PointerType = UInt32

        public var flags: UInt32
        public var instanceStart: UInt32
        public var instanceSize: UInt32
        public var ivarLayout: PointerType
        public var name: PointerType
        public var baseMethodList: PointerType
        public var baseProtocols: PointerType
        public var ivars: PointerType
        public var weakIvarLayout: PointerType
        public var baseProperties: PointerType
    }

    struct method_t<Pointer: UnsignedInteger>: ArchitectureDependent {
        public typealias PointerType = Pointer
        public var name: PointerType // SEL
        public var types: PointerType // meth type string
        public var imp: PointerType // code
    }

    struct ivar_t<Pointer: UnsignedInteger>: ArchitectureDependent {
        public typealias PointerType = Pointer
        // *offset was originally 64-bit on some x86_64 platforms.
        // We read and write only 32 bits of it.
        // Some metadata provides all 64 bits. This is harmless for unsigned
        // little-endian values.
        // Some code uses all 64 bits. class_addIvar() over-allocates the
        // offset for their benefit.

        public var offset: UInt32
        public var name: PointerType
        public var type: PointerType
        // alignment is sometimes -1; use alignment() instead
        public var alignment_raw: UInt32
        public var size: UInt32
    }

    struct property_t<Pointer: UnsignedInteger>: ArchitectureDependent {
        public typealias PointerType = Pointer

        public var name: PointerType
        public var attributes: PointerType
    }

    struct entsize_list_tt {
        // entsize_list_tt does not depend on architecture
        public var entsizeAndFlags: UInt32
        public var count: UInt32
        // Elements follow immediately after the header
        // var first:Element
    }

    struct category_t<Pointer: UnsignedInteger>: ArchitectureDependent {
        public typealias PointerType = Pointer

        public var name: PointerType
        public var cls: PointerType
        public var instanceMethods: PointerType
        public var classMethods: PointerType
        public var protocols: PointerType
        public var instanceProperties: PointerType
        // Fields below this point are not always present on disk.
        public var _classProperties: PointerType
    }

    struct protocol_t<Pointer: UnsignedInteger>: ArchitectureDependent {
        public typealias PointerType = Pointer

        public var isa: PointerType
        /// const char *mangledName;
        public var name: PointerType

        /// struct protocol_list_t *protocols;
        public var protocols: PointerType
        /// method_list_t *instanceMethods;
        public var instanceMethods: PointerType
        /// method_list_t *classMethods;
        public var classMethods: PointerType
        /// method_list_t *optionalInstanceMethods;
        public var optionalInstanceMethods: PointerType
        /// method_list_t *optionalClassMethods;
        public var optionalClassMethods: PointerType
        /// struct objc_property_list *instanceProperties;
        public var instanceProperties: PointerType
    }
}
