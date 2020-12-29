//
//  testExchangeRateService.swift
//  MoreMoneyTests
//
//  Created by Michael Rutherford on 7/12/20.
//

@testable import MoneyAndExchangeRates
import XCTest

@available(iOS 13.0, *)
class testExchangeRateService: XCTestCase {
    var service = ExchangeRateService.getForUnitTests()

    override func setUpWithError() throws {
        service = ExchangeRateService.getForUnitTests()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let jsonText = ExchangeRateService.getTestJSONData()
        let myCurrency = ExchangeRateService.parseJSON(jsonText)

        XCTAssertEqual(myCurrency.rates.count, 168)
    }

    func testActualWebCall() throws {
        // maybe try with MockURLProtocol - https://www.hackingwithswift.com/articles/153/how-to-test-ios-networking-code-the-easy-way
        let expectation = XCTestExpectation(description: "response")
        service.getDataFromServer { x in
            XCTAssertNotNil(x)
            XCTAssert(x?.success == true)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)
    }

    func testURLCreationToGetLatestExchangeRates() throws {
        let urlRequest = try ExchangeRateService.getURLRequestToGetLatestExchangeRates()

        guard let url = urlRequest.url else {
            return
        }

        XCTAssertEqual(url.scheme, "https")
        XCTAssertEqual(url.host, "data.fixer.io")
    }
}
