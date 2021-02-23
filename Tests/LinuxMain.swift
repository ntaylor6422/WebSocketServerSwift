import XCTest

import SocketServerTests

var tests = [XCTestCaseEntry]()
tests += SocketServerTests.allTests()
XCTMain(tests)
