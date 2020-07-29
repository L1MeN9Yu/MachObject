import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
	[
		testCase(MachOEditorTests.allTests),
	]
}
#endif
