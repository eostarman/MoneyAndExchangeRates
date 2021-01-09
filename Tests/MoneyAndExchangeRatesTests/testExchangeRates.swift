//
//  testExchangeRates.swift
//  MoreMoneyTests
//
//  Created by Michael Rutherford on 7/12/20.
//

@testable import MoneyAndExchangeRates
import XCTest

class testExchangeRates: XCTestCase {
    func testExchangeRates() {
        let price = Money(1.0, .USD)
        let date = Date()

        ExchangeRatesService.initialize(ExchangeRate(from: .USD, to: .ZAR, date: date, rate: 1.23))

        let newPrice = ExchangeRatesService.getMoney(from: price, to: .ZAR, date: date)
        let newAmount = newPrice?.amount

        XCTAssertEqual(newAmount, 1.23)
    }

    func testReverseExchangeRates() {
        let price = Money(1.23, .ZAR)
        let date = Date()

        ExchangeRatesService.initialize(ExchangeRate(from: .USD, to: .ZAR, date: date, rate: 1.2302))

        let newPrice = ExchangeRatesService.getMoney(from: price, to: .USD, date: date)
        let newAmount = newPrice?.amount

        XCTAssertEqual(newAmount, 1.00)
    }
}
