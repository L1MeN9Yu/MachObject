import Foundation
@testable import MachOParser
import XCTest

final class MachOParserTests: XCTestCase {
	func testSwiftProtocols() throws {
		let mach = try getMach()
		SwiftParser.parseProtos(mach: mach)
	}

	func testMemoryLayout() {
		let uint32 = MemoryLayout<UInt32>.size
		print("UInt32 : \(uint32)")

		let int32 = MemoryLayout<Int32>.size
		print("Int32 : \(int32)")
	}

	private func getMach() throws -> Mach {
		let path = "/Users/limengyu/Desktop/Lagrange_Dynamic"
		let image = try Image(url: URL(fileURLWithPath: path))
		switch image.content {
		case let .fat(fat):
			guard let arm64Mach = (fat.architectures.compactMap { architecture -> Mach? in
				if architecture.mach.cpuType == .arm64 { return architecture.mach }
				return nil
			})
				.first else { fatalError() }
			return arm64Mach
		case let .mach(mach):
			return mach
		}
	}

	static var allTests = [
		("testSwiftProtocols", testSwiftProtocols),
		("testMemoryLayout", testMemoryLayout),
	]
}
