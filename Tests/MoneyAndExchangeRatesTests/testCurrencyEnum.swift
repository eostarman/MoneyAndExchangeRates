//
//  testCurrencyEnum.swift
//  MoreMoneyTests
//
//  Created by Michael Rutherford on 12/17/20.
//

@testable import MoneyAndExchangeRates
import XCTest

class testCurrencyEnum: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCurrencyName() {
        XCTAssertEqual(Currency.USD.name, "USD")
        XCTAssertEqual(Currency.EUR.name, "EUR")

        for value in Currency.allCases {
            XCTAssertEqual("\(value)", value.name)
            return
        }
    }

    func testCurrencyDescription() {
        XCTAssertEqual(Currency.USD.description, "US Dollar")
        XCTAssertEqual(Currency.EUR.description, "Euro")
        XCTAssertEqual(Currency.ZAR.description, "Rand")
    }

    func testCurrencySymbol() {
        XCTAssertEqual(Currency.USD.symbol, "$")
        XCTAssertEqual(Currency.EUR.symbol, "€")
        XCTAssertEqual(Currency.ZAR.symbol, "R")

        var missingSymbols: [String] = []

        for value in Currency.allCases {
            if value.symbol == Currency.genericCurrencySymbol {
                missingSymbols.append(value.name)
            }
        }

        // at the time of writing, these 15 currencies didn't have symbols (they get the genericCurrencySymbol)
        let text = missingSymbols.joined(separator: ", ")
        XCTAssertEqual(text, "VEF, STD, SVC, LSL, MXV, BOV, MRO, CUC, CLF, COU, UYI, USN, CHE, CHW, ZWL")
    }

    func testCurrencyAmountMethods() {
        let testAmount: Decimal = 1.23
        let scaledAmount: Int64 = 123
        let currency: Currency = .USD

        let amount = currency.amount(testAmount)
        XCTAssertEqual(amount.currency, currency)
        XCTAssertEqual(amount.numberOfDecimals, currency.numberOfDecimals)
        XCTAssertEqual(amount.scaledAmount, scaledAmount)
        XCTAssertEqual(amount.decimalValue, testAmount)

        let zero = currency.zero
        XCTAssertEqual(zero.currency, currency)
        XCTAssertEqual(zero.numberOfDecimals, currency.numberOfDecimals)
        XCTAssertEqual(zero.scaledAmount, 0)
    }

    func testCurrencyConstructor() {
        XCTAssertEqual(Currency(currencyNid: nil), nil)
        XCTAssertEqual(Currency(currencyNid: 840), Currency.USD)
        XCTAssertEqual(Currency(currencyNid: 710), Currency.ZAR)
    }

    func testNumberOfDecimals() {
        XCTAssertEqual(Currency.USD.numberOfDecimals, 2)
        XCTAssertEqual(Currency.ZAR.numberOfDecimals, 2)
        XCTAssertEqual(Currency.EUR.numberOfDecimals, 2)
        XCTAssertEqual(Currency.CLF.numberOfDecimals, 4)

        for value in Currency.allCases {
            XCTAssertGreaterThanOrEqual(value.numberOfDecimals, 0)
            XCTAssertLessThanOrEqual(value.numberOfDecimals, 4)
        }
    }
}
