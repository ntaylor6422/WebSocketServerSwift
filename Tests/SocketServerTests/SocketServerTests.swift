import XCTest
@testable import SocketServer

final class SocketServerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SocketServer().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
