@testable import CodeSignParser
import Foundation
import MachO
@testable import MachOParser
import XCTest

final class MachOParserTests: XCTestCase {
    func testCodeSignature() throws {
        let mach = try getMach()
        guard let codeSignature = mach.codeSignature else { return }
        print("\(codeSignature.codeDirectoryList)")
        if let entitlements = codeSignature.entitlements {
            print("\(entitlements)")
        }
        print("==========================")
        guard let codeSignatureLC: CodeSignatureLC = mach.loadCommand() else { return }
        let offset = Int(codeSignatureLC.dataOffset)
        let size = Int(codeSignatureLC.dataSize)
        let subData = mach.data.subdata(in: offset..<(offset + size))
        let codeSignature2 = CodeSignature(codeSignatureData: subData)
        print("\(codeSignature2.codeDirectoryList)")
        if let entitlements2 = codeSignature2.entitlements {
            print("\(entitlements2)")
        }
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

    private func getMach(path: String = "/Applications/Xcode.app/Contents/MacOS/Xcode") throws -> Mach {
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
        ("testCodeSignature", testCodeSignature),
    ]
}

extension MachOParserTests {
    func testProcessMach() throws {
        guard let headerFromDyld: UnsafePointer<mach_header> = _dyld_get_image_header(0) else {
            fatalError()
        }

        let processMach = try ProcessMach(headerPointer: headerFromDyld)
        print("\(processMach.header)")
        if let stringTable = processMach.stringTable {
            print("\(stringTable)")
        }
    }
}
