import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
	[
		testCase(MachObjectTests.allTests),
	]
}
#endif
