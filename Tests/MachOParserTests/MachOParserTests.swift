import Foundation
@testable import MachOParser
import XCTest

final class MachOParserTests: XCTestCase {
//    func testSwiftProtocols() throws {
//        let mach = try getMach()
//        let protos = SwiftParser.parseProtos(mach: mach)
//        print("\(protos)")
//    }
//
//    func testSwiftTypes() throws {
//        let mach = try getMach()
//        SwiftParser.parseTypes(mach: mach)
//    }

    func testEntitlements() throws {
        let mach = try getMach()
        CodeSignParser.parse(mach: mach)
    }

    func testExports() throws {
        let mach = try getMach(path: "/Applications/MachOExplorer.app/Contents/Frameworks/MachOKit.framework/MachOKit")
        print(mach.exports)
    }

    private func getMach(path: String = "/Applications/Visual Studio Code.app/Contents/MacOS/Electron") throws -> Mach {
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
