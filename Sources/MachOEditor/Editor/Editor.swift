//
// Created by Mengyu Li on 2020/7/30.
//

import Foundation
import MachObject

public struct Editor { private init() {} }

public extension Editor {
	static func erase(url: URL, filePath prefixes: [String], replacement: String = "") throws {
		let image = try Image(url: url)
		var mutableImage = MutableImage(image: image)
		try mutableImage.update { (mach: inout MutableMach) throws in
			try mach.erase(filePaths: prefixes, replacement: replacement)
		}
		try mutableImage.save()
	}
}
