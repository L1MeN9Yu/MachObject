//
// Created by Mengyu Li on 2020/8/25.
//

import Foundation

public struct CodeSignature {
	let entitlements: [String: Any]?

	init(codeDirectoryData: Data?, entitlementsData: Data?) {
		if let entitlementsData = entitlementsData {
			entitlements = try? PropertyListSerialization.propertyList(from: entitlementsData, format: nil) as? [String: Any]
		} else {
			entitlements = nil
		}
	}

	init(tuple: (Data?, Data?)) {
		self.init(codeDirectoryData: tuple.0, entitlementsData: tuple.1)
	}
}
