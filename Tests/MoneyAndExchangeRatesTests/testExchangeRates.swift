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
        let price = Money(amount: 1.0, currency: .USD)
        let date = Date()

        var rates = ExchangeRates()
        rates.add(date: date, from: .USD, to: .ZAR, rate: 1.23)

        let newPrice = rates.getMoney(from: price, to: .ZAR, date: date)
        let newAmount = newPrice?.amount

        XCTAssertEqual(newAmount, 1.23)
    }

    func testReverseExchangeRates() {
        let price = Money(amount: 1.23, currency: .ZAR)
        let date = Date()

        var rates = ExchangeRates()
        rates.add(date: date, from: .USD, to: .ZAR, rate: 1.2302)

        let newPrice = rates.getMoney(from: price, to: .USD, date: date)
        let newAmount = newPrice?.amount

        XCTAssertEqual(newAmount, 1.00)
    }
}
