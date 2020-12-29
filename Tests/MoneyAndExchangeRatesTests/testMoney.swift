//
//  testMoney.swift
//  MoreMoneyTests
//
//  Created by Michael Rutherford on 7/12/20.
//

@testable import MoneyAndExchangeRates
import XCTest

class testMoney: XCTestCase {
    func testMoneyRoundTrip() {
        let price = Money(amount: 1.23, currency: .USD)

        XCTAssertEqual(price.amount, 1.23)
    }

    func testMoneySize() {
        let price = Money(amount: 1.23, currency: .USD)
        let decimalPrice = Decimal(0)

        XCTAssertEqual(MemoryLayout.size(ofValue: price), 8)
        XCTAssertEqual(MemoryLayout.size(ofValue: decimalPrice), 20)
    }

    func testDivideByThree() {
        let price = Currency.USD.amount(10.00)

        XCTAssertEqual(price / 3, price.currency.amount(3.33))

        XCTAssertEqual(price / 3.0, price.currency.amount(3.33))
    }

    func testDivideByThreeWithFourDecimals() {
        let price = Currency.USD.amount(10.00, numberOfDecimals: 4)

        XCTAssertEqual(price / 3, price.currency.amount(3.3333, numberOfDecimals: 4))

        XCTAssertEqual(price / 3.0, price.currency.amount(3.3333, numberOfDecimals: 4))
    }

    func testMultiplyByQuarter() {
        let price = Currency.USD.amount(10.00)
        let quarter = price * 0.25

        XCTAssertEqual(quarter, price.currency.amount(2.50))
    }

    func testMultiplySixthToTwoDecimals() {
        let price = Currency.USD.amount(10.00)
        let sixth = 1.0 / 6.0

        XCTAssertEqual(price * sixth, price.currency.amount(1.67))
    }

    func testMultiplySixthToFourDecimals() {
        let price = Currency.USD.amount(10.00, numberOfDecimals: 4)
        let sixth = 1.0 / 6.0

        XCTAssertEqual(price * sixth, price.currency.amount(1.6667, numberOfDecimals: 4))
    }

    func testMultiplyByQty() {
        let price = Currency.USD.amount(10.0001, numberOfDecimals: 4)
        let qty = 9

        XCTAssertEqual(qty * price, price.currency.amount(90.0009, numberOfDecimals: 4))
    }

    func testAddingDifferentPrecisions() {
        let price1 = Currency.USD.amount(10.00, numberOfDecimals: 0)
        let price2 = Currency.USD.amount(0.0001, numberOfDecimals: 4)

        XCTAssertEqual(price1 + price2, Currency.USD.amount(10.0001, numberOfDecimals: 4))

        XCTAssertEqual(price2 + price1, Currency.USD.amount(10.0001, numberOfDecimals: 4))
    }

    func testSubtractingDifferentPrecisions() {
        let price1 = Currency.USD.amount(10.00, numberOfDecimals: 0)
        let price2 = Currency.USD.amount(0.0001, numberOfDecimals: 4)

        XCTAssertEqual(price1 - price2, Currency.USD.amount(9.9999, numberOfDecimals: 4))

        XCTAssertEqual(price2 - price1, Currency.USD.amount(-9.9999, numberOfDecimals: 4))
    }

    func testAddingZero() {
        let price1 = Currency.USD.amount(10.00)
        let zero = price1.currency.zero

        XCTAssertEqual(price1 + zero, price1)

        XCTAssertEqual(zero + price1, price1)
    }

    func testSubtractingZero() {
        let price1 = Currency.USD.amount(10.00)
        let zero = price1.currency.zero

        XCTAssertEqual(price1 - zero, price1)

        XCTAssertEqual(zero - price1, -price1)
    }

    func testNegating() {
        let price1 = Currency.USD.amount(10.00)
        let zero = price1.currency.zero

        XCTAssertEqual(price1 + -price1, zero)

        XCTAssertEqual(price1, -(-price1))
    }

    func testRoundingDown() {
        let amountToRoundDown: Decimal = 1.234
        let amount = Money(amount: amountToRoundDown, currency: .USD)
        XCTAssertEqual(amount.decimalValue, Decimal(1.23))
    }

    func testRoundingUp() {
        let amountToRoundDown: Decimal = 1.235
        let amount = Money(amount: amountToRoundDown, currency: .USD)
        XCTAssertEqual(amount.decimalValue, Decimal(1.24))
    }

    func testRoundingUp2() {
        let amountToRoundDown: Decimal = 1.23499999
        let amount = Money(amount: amountToRoundDown, currency: .USD)
        XCTAssertEqual(amount.decimalValue, Decimal(1.23))
    }

    func testRoundingNegativeNumberDown() {
        let amountToRoundDown: Decimal = -1.234
        let amount = Money(amount: amountToRoundDown, currency: .USD)
        XCTAssertEqual(amount.decimalValue, Decimal(-1.23))
    }

    func testRoundingNegativeNumberUp() {
        let amountToRoundDown: Decimal = -1.235
        let amount = Money(amount: amountToRoundDown, currency: .USD)
        XCTAssertEqual(amount.decimalValue, Decimal(-1.24))
    }

    // -mark

    func testRoundingDownWithoutCurrency() {
        let amountToRoundDown: Decimal = 1.234
        let amount = MoneyWithoutCurrency(amount: amountToRoundDown, numberOfDecimals: 2)
        XCTAssertEqual(amount.decimalValue, Decimal(1.23))
    }

    func testRoundingUpWithoutCurrency() {
        let amountToRoundDown: Decimal = 1.235
        let amount = MoneyWithoutCurrency(amount: amountToRoundDown, numberOfDecimals: 2)
        XCTAssertEqual(amount.decimalValue, Decimal(1.24))
    }

    func testRoundingUp2WithoutCurrency() {
        let amountToRoundDown: Decimal = 1.23499999
        let amount = MoneyWithoutCurrency(amount: amountToRoundDown, numberOfDecimals: 2)
        XCTAssertEqual(amount.decimalValue, Decimal(1.23))
    }

    func testRoundingNegativeNumberDownWithoutCurrency() {
        let amountToRoundDown: Decimal = -1.234
        let amount = MoneyWithoutCurrency(amount: amountToRoundDown, numberOfDecimals: 2)
        XCTAssertEqual(amount.decimalValue, Decimal(-1.23))
    }

    func testRoundingNegativeNumberUpWithoutCurrency() {
        let amountToRoundDown: Decimal = -1.235
        let amount = MoneyWithoutCurrency(amount: amountToRoundDown, numberOfDecimals: 2)
        XCTAssertEqual(amount.decimalValue, Decimal(-1.24))
    }

    func testRoundingToNumberOfDecimals() {
        let originalAmount: Decimal = 1.235001
        let amount1 = Money(amount: originalAmount, currency: .USD, numberOfDecimals: 4)
        XCTAssertEqual(amount1.scaledAmount, 12350)

        let amount2 = amount1.withDecimals(0)
        XCTAssertEqual(amount2.scaledAmount, 1)

        let amount3 = amount1.withStandardNumberOfDecimalsForCurrency()
        XCTAssertEqual(amount3.scaledAmount, 124)
    }

    func testEqualityOperator() {
        let amount1 = Money(amount: 1.23, currency: .USD, numberOfDecimals: 4)
        let amount2 = Money(amount: 1.23, currency: .USD, numberOfDecimals: 2)
        let amount3 = Money(amount: 1.23, currency: .EUR, numberOfDecimals: 2)

        XCTAssertEqual(amount1, amount1)
        XCTAssertEqual(amount1, amount2)
        XCTAssertEqual(amount2, amount1)

        XCTAssertNotEqual(amount2, amount3)
    }

    func testGreaterThanOperator() {
        let amount1a = Money(amount: 1.23, currency: .USD, numberOfDecimals: 4)
        let amount2a = Money(amount: 1.22, currency: .USD, numberOfDecimals: 2)

        XCTAssertTrue(amount1a > amount2a)

        let amount1b = Money(amount: 1.23, currency: .USD, numberOfDecimals: 2)
        let amount2b = Money(amount: 1.22, currency: .USD, numberOfDecimals: 4)

        XCTAssertTrue(amount1b > amount2b)

        let amount1c = Money(amount: 1.23, currency: .USD, numberOfDecimals: 5)
        let amount2c = Money(amount: 1.22, currency: .USD, numberOfDecimals: 5)

        XCTAssertTrue(amount1c > amount2c)

        let amount1d = Money(amount: 1.22, currency: .USD, numberOfDecimals: 7)
        let amount2d = Money(amount: 1.22, currency: .ZAR, numberOfDecimals: 7)

        XCTAssertTrue(amount1d > amount2d)
    }

    func testStringInterpolation() {
        let amount = Money(amount: 1.23456, currency: .USD, numberOfDecimals: 4)
        let text = "\(amount)"

        XCTAssertEqual(text, "USD1.2346")
    }
}
