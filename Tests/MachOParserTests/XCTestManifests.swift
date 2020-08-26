import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    [
        testCase(MachOParserTests.allTests),
    ]
}
#endif
