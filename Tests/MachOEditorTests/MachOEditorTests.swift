import Foundation
import MachObject
@testable import MachOEditor
import XCTest

final class MachOEditorTests: XCTestCase {
	func testExample() throws {
		let path = "/Users/limengyu/Desktop/Lagrange_Dynamic"
		let copyPath = "/Users/limengyu/Desktop/Lagrange_Dynamic_\(UUID().uuidString)"
		try FileManager.default.copyItem(atPath: path, toPath: copyPath)
		let image = try Image(url: URL(fileURLWithPath: copyPath))
		var mutableImage = MutableImage(image: image)
		try mutableImage.update { (mach: inout MutableMach) throws -> () in
			try mach.erase(filePaths: ["/Users/limengyu/"])
		}
		try mutableImage.save()
	}

	static var allTests = [
		("testExample", testExample),
	]
}
