//
//  MoneyWithoutCurrency.swift
//  MobileBench
//
//  Created by Michael Rutherford on 11/16/20.
//

import Foundation

enum MoneyDecodingError: Error {
    case badAmount(String)
}

public struct MoneyWithoutCurrency: Codable, Hashable {
    let rawValue: Int64

    public static let zero = MoneyWithoutCurrency(scaledAmount: 0, numberOfDecimals: 0)

    // 1-bit for sign
    // 50-bits for the scaled value (15 digits)
    // 10-bits for currency code (001 ... 999)
    // 3-bits for # of decimal places (0 ... 7)

    // from 0 ... 7
    public var numberOfDecimals: Int {
        let value = rawValue & 0x7
        return Int(value)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(decimalValue)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)

        guard let x = Self(string) else {
            throw MoneyDecodingError.badAmount("'\(string) is not a valid currency amount")
        }
        self = x
    }

    public init?(_ string: String) {
        var n: Int64 = 0
        var foundNegativeSign = false
        var foundDecimal = false
        var foundDigit = false
        var digitsAfterDecimalPoint = 0

        for chr in string {
            if chr == ".", !foundDecimal {
                foundDecimal = true
                continue
            }
            if chr == "-", !foundDigit, !foundDecimal, !foundNegativeSign {
                foundNegativeSign = true
                continue
            }
            if let digit = chr.wholeNumberValue {
                foundDigit = true
                n = n * 10 + Int64(digit)
                if foundDecimal {
                    digitsAfterDecimalPoint += 1
                }
                continue
            }
            return nil
        }

        if n < 0 || n > 999_999_999_999_999 { // 15-digits max
            return nil
        }

        if foundNegativeSign {
            n = -n
        }

        self.init(scaledAmount: n, numberOfDecimals: digitsAfterDecimalPoint)
    }

    public var scaledAmount: Int64 {
        rawValue >> 13
    }

    public var isZero: Bool { scaledAmount == 0 }
    public var isNonZero: Bool { scaledAmount != 0 }
    public var isPositive: Bool { scaledAmount > 0 }
    public var isNegative: Bool { scaledAmount < 0 }

    public var amount: Double {
        let scaledValue = Double(rawValue >> 13)
        let scale = Money.scales[numberOfDecimals]
        let result = scaledValue / scale

        return result
    }

    static let intScales: [Int64] = [1, 10, 100, 1000, 10000, 100_000, 1_000_000, 10_000_000]

    public var decimalValue: Decimal {
        Decimal(scaledAmount) / Decimal(Money.intScales[numberOfDecimals])
    }

    public init(scaledAmount: Int, numberOfDecimals: Int) {
        precondition((0 ... 7).contains(numberOfDecimals))
        let currencyRawValue = 0

        rawValue = Int64(scaledAmount << 13) | Int64(currencyRawValue << 3) | Int64(numberOfDecimals)
    }

    public init(scaledAmount: Int64, numberOfDecimals: Int) {
        precondition((0 ... 7).contains(numberOfDecimals))
        let currencyRawValue = 0

        rawValue = Int64(scaledAmount << 13) | Int64(currencyRawValue << 3) | Int64(numberOfDecimals)
    }

    public init(amount: Decimal, numberOfDecimals: Int) {
        let scaledDecimalAmount = (amount * Decimal(Money.intScales[numberOfDecimals])).rounded(0) as NSDecimalNumber
        let scaledAmount = scaledDecimalAmount.int64Value

        let currencyRawValue = 0
        rawValue = (scaledAmount << 13) | Int64(currencyRawValue << 3) | Int64(numberOfDecimals)
    }

    public init(amount: Double, numberOfDecimals: Int) {
        let scale = Money.scales[numberOfDecimals]

        let scaledAmount = Int64((amount * scale).rounded())

        let currencyRawValue = 0
        rawValue = (scaledAmount << 13) | Int64(currencyRawValue << 3) | Int64(numberOfDecimals)
    }

    public func withCurrency(_ currency: Currency) -> Money {
        Money(scaledAmount: scaledAmount, numberOfDecimals: numberOfDecimals, currency: currency)
    }
}

 extension MoneyWithoutCurrency: Equatable {
    public static func == (left: MoneyWithoutCurrency, right: MoneyWithoutCurrency) -> Bool {
        if left.rawValue == right.rawValue {
            return true
        }

        if left.numberOfDecimals == right.numberOfDecimals {
            return left.scaledAmount == right.scaledAmount
        } else if left.numberOfDecimals > right.numberOfDecimals {
            let scale = intScales[left.numberOfDecimals - right.numberOfDecimals]
            return left.scaledAmount == right.scaledAmount * scale
        } else {
            let scale = intScales[right.numberOfDecimals - left.numberOfDecimals]
            return left.scaledAmount * scale == right.scaledAmount
        }
    }

    public static func > (left: MoneyWithoutCurrency, right: MoneyWithoutCurrency) -> Bool {
        if left.numberOfDecimals == right.numberOfDecimals {
            return left.scaledAmount > right.scaledAmount
        } else if left.numberOfDecimals > right.numberOfDecimals {
            let scale = intScales[left.numberOfDecimals - right.numberOfDecimals]
            return left.scaledAmount > right.scaledAmount * scale
        } else {
            let scale = intScales[right.numberOfDecimals - left.numberOfDecimals]
            return left.scaledAmount * scale > right.scaledAmount
        }
    }
    
    public static func < (left: MoneyWithoutCurrency, right: MoneyWithoutCurrency) -> Bool {
        return right > left
    }
}

extension MoneyWithoutCurrency {
    public static prefix func - (amount: MoneyWithoutCurrency) -> MoneyWithoutCurrency {
        MoneyWithoutCurrency(scaledAmount: -amount.scaledAmount, numberOfDecimals: amount.numberOfDecimals)
    }
    
    /// Return the amount scaled to have a specific number of decimal places
    /// - Parameter numberOfDecimals: the required number of decimals
    /// - Returns: the value with a scaled value that has the required number of decimals. If some precision is lost, the value is truncated - not rounded
    public func scaledTo(numberOfDecimals: Int) -> MoneyWithoutCurrency {
        if numberOfDecimals == self.numberOfDecimals {
            return self
        } else if numberOfDecimals > self.numberOfDecimals {
            let multiplyBy = Self.intScales[numberOfDecimals - self.numberOfDecimals]
            let newScaledAmount = scaledAmount * multiplyBy
            return MoneyWithoutCurrency(scaledAmount: newScaledAmount, numberOfDecimals: numberOfDecimals)
        } else {
            let divideBy = Self.intScales[self.numberOfDecimals - numberOfDecimals]
            let newScaledAmount = self.scaledAmount / divideBy
            return MoneyWithoutCurrency(scaledAmount: newScaledAmount, numberOfDecimals: numberOfDecimals)
        }
    }

    public static func + (left: MoneyWithoutCurrency, right: MoneyWithoutCurrency?) -> MoneyWithoutCurrency {
        guard let right = right else {
            return left
        }

        // zero is special - it has no currency, but it'll take on the currency of the other operand
        if left.scaledAmount == 0 {
            return right
        }
        if right.scaledAmount == 0 {
            return left
        }

        if left.numberOfDecimals == right.numberOfDecimals {
            let newScaledAmount = left.scaledAmount + right.scaledAmount

            return MoneyWithoutCurrency(scaledAmount: newScaledAmount, numberOfDecimals: left.numberOfDecimals)
        } else if left.numberOfDecimals > right.numberOfDecimals {
            let scale = intScales[left.numberOfDecimals - right.numberOfDecimals]
            let newScaledAmount = left.scaledAmount + right.scaledAmount * scale
            return MoneyWithoutCurrency(scaledAmount: newScaledAmount, numberOfDecimals: left.numberOfDecimals)
        } else {
            let scale = intScales[right.numberOfDecimals - left.numberOfDecimals]
            let newScaledAmount = right.scaledAmount + left.scaledAmount * scale
            return MoneyWithoutCurrency(scaledAmount: newScaledAmount, numberOfDecimals: right.numberOfDecimals)
        }
    }

    public static func - (left: MoneyWithoutCurrency, right: MoneyWithoutCurrency?) -> MoneyWithoutCurrency {
        guard let right = right else {
            return left
        }

        return left + -right
    }

    public static func += (left: inout MoneyWithoutCurrency, right: MoneyWithoutCurrency?) {
        left = left + right
    }

    public static func -= (left: inout MoneyWithoutCurrency, right: MoneyWithoutCurrency?) {
        left = left - right
    }

    public static func / (left: MoneyWithoutCurrency, divisor: Double) -> MoneyWithoutCurrency {
        left * (1.0 / divisor)
    }

    public static func / (left: MoneyWithoutCurrency, divisor: Int) -> MoneyWithoutCurrency {
        left * (1.0 / Double(divisor))
    }

    public static func * (left: MoneyWithoutCurrency, double: Double) -> MoneyWithoutCurrency {
        let newAmount = left.amount * double

        let result = MoneyWithoutCurrency(amount: newAmount, numberOfDecimals: left.numberOfDecimals)
        return result
    }

    public static func * (qty: Int, right: MoneyWithoutCurrency) -> MoneyWithoutCurrency {
        MoneyWithoutCurrency(scaledAmount: right.scaledAmount * Int64(qty), numberOfDecimals: right.numberOfDecimals)
    }
}

extension MoneyWithoutCurrency: CustomDebugStringConvertible {
    public var debugDescription: String {
        "\(self)"
    }
}

extension String.StringInterpolation {
    public mutating func appendInterpolation(_ value: MoneyWithoutCurrency) {
        
        if value.scaledAmount == 0 {
            appendLiteral("0.00")
            return
        }
        
        var numberOfDecimals = value.numberOfDecimals
        if numberOfDecimals == 4 && value.scaledAmount % 100 == 0 {
            numberOfDecimals = 2
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = numberOfDecimals
        formatter.maximumFractionDigits = numberOfDecimals
        let formattedAmount = formatter.string(from: value.decimalValue as NSNumber)!
        
        appendInterpolation(formattedAmount)
    }
}
