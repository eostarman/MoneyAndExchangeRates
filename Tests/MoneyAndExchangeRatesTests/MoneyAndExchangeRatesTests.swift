import XCTest
@testable import MoneyAndExchangeRates

final class MoneyAndExchangeRatesTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MoneyAndExchangeRates().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
