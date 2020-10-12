import Foundation
@testable import MachOParser
import XCTest

final class MachOParserTests: XCTestCase {
    func testEntitlements() throws {
        let mach = try getMach()
        CodeSignParser.parse(mach: mach)
    }

    func testExports() throws {
        let mach = try getMach()
        print(mach.exports)
    }

    func testStringTable() throws {
        let mach = try getMach()
        guard let symbols = mach.stringTable?.symbols else { return }
        symbols.forEach {
            print("0x\(String($0.offset, radix: 0x10, uppercase: true)) : \($0.value)")
        }
    }

    private func getMach(path: String = "/Users/baal998/Downloads/archives/dynamic/Lagrange_Dynamic.xcframework/ios-arm64/Lagrange_Dynamic.framework/Lagrange_Dynamic") throws -> Mach {
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
        ("testEntitlements", testEntitlements),
    ]
}
