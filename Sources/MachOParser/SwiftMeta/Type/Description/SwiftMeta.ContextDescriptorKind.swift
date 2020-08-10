//
// Created by Mengyu Li on 2020/8/5.
//

import Foundation

extension SwiftMeta {
	/// https://github.com/apple/swift/blob/master/include/swift/ABI/MetadataValues.h `enum class ContextDescriptorKind`
	enum ContextDescriptorKind {
		/// This context descriptor represents a module.
		case module
		/// This context descriptor represents an extension.
		case `extension`
		/// This context descriptor represents an anonymous possibly-generic context
		/// such as a function body.
		case anonymous
		/// This context descriptor represents a protocol context.
		case `protocol`
		/// This context descriptor represents an opaque type alias.
		case opaque
		/// First kind that represents a type of any sort.
		// case Type_First
		/// This context descriptor represents a class.
		case `class`
		/// This context descriptor represents a struct.
		case `struct`
		/// This context descriptor represents an enum.
		case `enum`
		/// Last kind that represents a type of any sort.
		// case Type_Last = 31
	}
}

extension SwiftMeta.ContextDescriptorKind {
	init?(value: UInt32) {
		switch value {
		case 0:
			self = .module
		case 1:
			self = .extension
		case 2:
			self = .anonymous
		case 3:
			self = .protocol
		case 4:
			self = .opaque
		case 16:
			self = .class
		case 17:
			self = .struct
		case 18:
			self = .enum
		default:
			return nil
		}
	}
}

extension SwiftMeta.ContextDescriptorKind: CustomStringConvertible {
	public var description: String {
		switch self {
		case .module:
			return "Module"
		case .extension:
			return "Extension"
		case .anonymous:
			return "Anonymous"
		case .protocol:
			return "Protocol"
		case .opaque:
			return "OpaqueType"
		case .class:
			return "Class"
		case .struct:
			return "Struct"
		case .enum:
			return "Enum"
		}
	}
}
