//
// Created by Mengyu Li on 2020/7/24.
//

import Foundation

extension Image {
	enum Error: Swift.Error {
		case unsupported(url: URL, magic: UInt32?)
	}
}
