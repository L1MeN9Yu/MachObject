import Foundation
@testable import MachOParser
import XCTest

final class MachOParserTests: XCTestCase {
	func testSwiftProtocols() throws {
		let mach = try getMach()
		let protos = SwiftParser.parseProtos(mach: mach)
		print("\(protos)")
	}

	func testSwiftTypes() throws {
		let mach = try getMach()
		SwiftParser.parseTypes(mach: mach)
	}

	func testMemoryLayout() {
		let uint32 = MemoryLayout<UInt32>.size
		print("UInt32 : \(uint32)")

		let int32 = MemoryLayout<Int32>.size
		print("Int32 : \(int32)")

		let fieldRecordSize = MemoryLayout<SwiftMeta.FieldRecord>.size
		print("fieldRecordSize : \(fieldRecordSize)")
	}

	func testEntitlements() throws {
		let mach = try getMach()
		CodeSignParser.parse(mach: mach)
	}

	private func getMach() throws -> Mach {
		let path = "/Applications/Visual Studio Code.app/Contents/MacOS/Electron"
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

	func testByteOrder() {
		print(ByteOrder.current)
	}

	static var allTests = [
		("testSwiftProtocols", testSwiftProtocols),
		("testMemoryLayout", testMemoryLayout),
	]
}