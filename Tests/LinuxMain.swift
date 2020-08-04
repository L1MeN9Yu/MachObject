import XCTest

import MachOParserTests

var tests = [XCTestCaseEntry]()
tests += MachOParserTests.allTests()
XCTMain(tests)
