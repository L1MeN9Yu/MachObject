import XCTest
@testable import MachObject

final class MachObjectTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let path = "/Users/limengyu/Desktop/Lagrange_Dynamic"
        let image = try Image(url: URL(fileURLWithPath: path))
        switch image.content {
        case .fat(let fat):
            let arm64Mach = fat.architectures.compactMap { architecture -> Mach? in
                if architecture.mach.cupType == .arm64 { return architecture.mach }
                return nil
            }
                    .first
            print("\(arm64Mach?.loadCommands)")
        case .mach(let mach):
            print("\(mach.loadCommands)")
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
