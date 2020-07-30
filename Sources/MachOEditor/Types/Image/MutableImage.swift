//
// Created by Mengyu Li on 2020/7/29.
//

import Foundation
import MachObject

public struct MutableImage {
	public let url: URL
	public private(set) var content: Content

	public init(image: Image) {
		url = image.url
		content = Content(content: image.content)
	}
}

extension MutableImage {
	mutating func update(action: (inout MutableMach) throws -> ()) throws {
		switch content {
		case let .fat(fat):
			var mutableFat = fat
			mutableFat.architectures = try fat.architectures.map { arch in
				var mutableArch = arch
				try mutableArch.update(action: action)
				return mutableArch
			}
			for arch in mutableFat.architectures {
				let archRangeInFat = Range(offset: Int(arch.offset), count: arch.mach.data.count)
				mutableFat.data.replaceSubrange(archRangeInFat, with: arch.mach.data)
			}
			content = .fat(mutableFat)
		case let .mach(mach):
			var mutableMach = mach
			try action(&mutableMach)
			content = .mach(mutableMach)
		}
	}
}

// MARK: - Save

public extension MutableImage {
	func save() throws {
		switch content {
		case let .fat(fat):
			try fat.data.write(to: url, options: .atomic)
		case let .mach(mach):
			try mach.data.write(to: url, options: .atomic)
		}
	}
}
