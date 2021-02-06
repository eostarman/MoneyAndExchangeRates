
import Foundation

public struct Money: Codable, Hashable {
    let rawValue: Int64

    public static let zeroUSD = Money(scaledAmount: 0, numberOfDecimals: 0, currency: .USD)

    // 10-bits for currency code (001 ... 999)
    // 3-bits for # of decimal places (0 ... 4)

    // from 0 ... 7
    public var numberOfDecimals: Int {
        let value = rawValue & 0x7
        return Int(value)
    }

    // handles # of decimal places from 0 ... 7
    static let scales = [1.0, 10.0, 100.0, 1000.0, 10000.0, 100_000.0, 1_000_000.0, 10_000_000.0]

    static let intScales: [Int64] = [1, 10, 100, 1000, 10000, 100_000, 1_000_000, 10_000_000]

    public var currency: Currency {
        let currencyRawValue = Int16((rawValue >> 3) & 0x3FF)
        if let x = Currency(rawValue: currencyRawValue) {
            return x
        }
        return .USD
    }

    private var currencyRawValue: Int64 {
        (rawValue >> 3) & 0x3FF
    }

    public var decimalValue: Decimal {
        Decimal(scaledAmount) / Decimal(Money.intScales[numberOfDecimals])
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

    public init(scaledAmount: Int, numberOfDecimals: Int, currency: Currency) {
        precondition((0 ... 7).contains(numberOfDecimals))

        rawValue = Int64(scaledAmount << 13) | Int64(currency.rawValue << 3) | Int64(numberOfDecimals)
    }

    public init(scaledAmount: Int64, numberOfDecimals: Int, currency: Currency) {
        precondition((0 ... 7).contains(numberOfDecimals))

        rawValue = Int64(scaledAmount << 13) | Int64(currency.rawValue << 3) | Int64(numberOfDecimals)
    }

    public init(_ amount: Decimal, _ currency: Currency, numberOfDecimals: Int? = nil) {
        let currencyRawValue = currency.rawValue
        let numberOfDecimals = numberOfDecimals ?? currency.numberOfDecimals

        let scaledDecimalAmount = (amount * Decimal(Money.intScales[numberOfDecimals])).rounded(0) as NSDecimalNumber
        let scaledAmount = scaledDecimalAmount.int64Value

        rawValue = (scaledAmount << 13) | Int64(currencyRawValue << 3) | Int64(numberOfDecimals)
    }

    public init(_ amount: Double, _ currency: Currency, numberOfDecimals: Int? = nil) {
        let currencyRawValue = currency.rawValue
        let numberOfDecimals = numberOfDecimals ?? currency.numberOfDecimals
        let scale = Money.scales[numberOfDecimals]

        let scaledAmount = Int64((amount * scale).rounded())

        rawValue = (scaledAmount << 13) | Int64(currencyRawValue << 3) | Int64(numberOfDecimals)
    }

    public init(currency: Currency) {
        rawValue = Int64(currency.rawValue << 3) | Int64(currency.numberOfDecimals)
    }

    private init(scaledAmount: Int64, currencyRawValue: Int64, numberOfDecimals: Int) {
        rawValue = (scaledAmount << 13) | (currencyRawValue << 3) | Int64(numberOfDecimals)
    }
    
    public func withoutCurrency() -> MoneyWithoutCurrency {
        MoneyWithoutCurrency(scaledAmount: scaledAmount, numberOfDecimals: numberOfDecimals)
    }

    /// return the amount rounded to the standard number of decimals for the given currency (e.g. 2-decimals for USD, EUR and ZAR)
    public func withStandardNumberOfDecimalsForCurrency() -> Money {
        withDecimals(currency.numberOfDecimals)
    }

    /// return the amount rounded to the given number of decimals
    public func withDecimals(_ withDecimals: Int) -> Money {
        Money(decimalValue, currency, numberOfDecimals: withDecimals)
//        if scaledAmount == 0 {
//            return Money(scaledAmount: 0, currencyRawValue: currencyRawValue, numberOfdecimals: withDecimals)
//        } else if withDecimals > numberOfDecimals {
//            let scale = Money.intScales[withDecimals - numberOfDecimals]
//            let newScaledAmount = scaledAmount * scale
//            return Money(scaledAmount: newScaledAmount, currencyRawValue: currencyRawValue, numberOfdecimals: withDecimals)
//        } else if withDecimals < numberOfDecimals {
//            let remove = numberOfDecimals - withDecimals
//            let scale = Money.intScales[remove - 1]
//            var newScaledAmount = scaledAmount / scale
//            newScaledAmount += newScaledAmount > 0 ? 5 : -5
//            newScaledAmount /= 10
//
//            return Money(scaledAmount: newScaledAmount, currencyRawValue: currencyRawValue, numberOfdecimals: withDecimals)
//        } else {
//            return self
//        }
    }
}

extension Money: Equatable {
    public static func == (left: Money, right: Money) -> Bool {
        if left.rawValue == right.rawValue {
            return true
        }

        if left.currencyRawValue != right.currencyRawValue {
            return false
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

    public static func > (left: Money, right: Money) -> Bool {
        if left.currencyRawValue != right.currencyRawValue {
            return left.currencyRawValue > right.currencyRawValue
        }

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
}

extension Money {
    public static prefix func - (amount: Money) -> Money {
        Money(scaledAmount: -amount.scaledAmount, currencyRawValue: amount.currencyRawValue, numberOfDecimals: amount.numberOfDecimals)
    }

    public static func + (left: Money, right: Money?) -> Money {
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

        precondition(left.currency == right.currency)

        if left.numberOfDecimals == right.numberOfDecimals {
            let newScaledAmount = left.scaledAmount + right.scaledAmount

            return Money(scaledAmount: newScaledAmount, currencyRawValue: left.currencyRawValue, numberOfDecimals: left.numberOfDecimals)
        } else if left.numberOfDecimals > right.numberOfDecimals {
            let scale = intScales[left.numberOfDecimals - right.numberOfDecimals]
            let newScaledAmount = left.scaledAmount + right.scaledAmount * scale
            return Money(scaledAmount: newScaledAmount, currencyRawValue: left.currencyRawValue, numberOfDecimals: left.numberOfDecimals)
        } else {
            let scale = intScales[right.numberOfDecimals - left.numberOfDecimals]
            let newScaledAmount = right.scaledAmount + left.scaledAmount * scale
            return Money(scaledAmount: newScaledAmount, currencyRawValue: right.currencyRawValue, numberOfDecimals: right.numberOfDecimals)
        }
    }

    public static func - (left: Money, right: Money?) -> Money {
        guard let right = right else {
            return left
        }

        return left + -right
    }

    public static func += (left: inout Money, right: Money?) {
        left = left + right
    }

    public static func -= (left: inout Money, right: Money?) {
        left = left - right
    }

    public static func / (left: Money, divisor: Double) -> Money {
        left * (1.0 / divisor)
    }

    public static func / (left: Money, divisor: Int) -> Money {
        left * (1.0 / Double(divisor))
    }

    /// the result is 4 decimals
    public static func * (left: Money, double: Double) -> Money {
        let newAmount = left.amount * double

        let result = Money(newAmount, left.currency, numberOfDecimals: 4)
        return result
    }

    /// the result is 4 decimals
    public static func * (qty: Int, right: Money) -> Money {
        Money(scaledAmount: right.scaledAmount * Int64(qty), currencyRawValue: right.currencyRawValue, numberOfDecimals: 4)
    }
}

public extension String.StringInterpolation {
    mutating func appendInterpolation(_ value: Money) {
        appendInterpolation("\(value.currency)\(value.amount)")
    }
}

extension Money: CustomDebugStringConvertible {
    public var debugDescription: String {
        "\(decimalValue) \(currency)"
    }
}

public extension Decimal {
    func rounded(_ scale: Int) -> Decimal { // https://forums.swift.org/t/decimal-has-no-rounded/14200/10
        var result = Decimal()
        var localCopy = self
        NSDecimalRound(&result, &localCopy, scale, .plain)
        return result
    }
}
