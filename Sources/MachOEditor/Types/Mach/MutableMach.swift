//
// Created by Mengyu Li on 2020/7/29.
//

import Foundation
import MachObject

public struct MutableMach {
	public private(set) var data: Data

	init(mach: Mach) {
		data = mach.data
	}
}

// MARK: - Erase

extension MutableMach {
	mutating func erase(filePaths prefixes: [String], replacement: String = "") throws {
		guard !prefixes.isEmpty else { return }
		let mach = try Mach(data: data)
		guard let section = (mach.sections.first {
			$0.segmentName == Section.Content.__Text && $0.name == Section.Content.__cstring
		}) else { return }
		data.replaceString(range: section.range.intRange, filter: { (string: String) -> Bool in
			string.utf8.count >= replacement.utf8.count &&
				prefixes.contains(where: { prefix in string.starts(with: prefix) })
		}, mapping: { _ in replacement })
	}
}
