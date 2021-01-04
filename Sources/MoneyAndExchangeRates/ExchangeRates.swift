import Foundation

public struct ExchangeRates: Codable {
    private var rates: [ExchangeRate] = []

    public init() {}

    private func getRate(from: Currency, to: Currency, date: Date) -> Double {
        var earlierRate: ExchangeRate?
        var laterRate: ExchangeRate?

        for rate in rates {
            if rate.from != from || rate.to != to {
                continue
            }

            if rate.date == date {
                return rate.rate
            }
            if rate.date < date {
                if earlierRate == nil || rate.date > earlierRate!.date {
                    earlierRate = rate
                }
            } else {
                if laterRate == nil || rate.date < laterRate!.date {
                    laterRate = rate
                }
            }
        }

        if laterRate != nil {
            return laterRate!.rate
        }

        if earlierRate != nil {
            return earlierRate!.rate
        }

        return 0
    }

    public func getMoney(from: Money, to currency: Currency, date: Date) -> Money? {
        if from.currency == currency {
            return from
        }

        var rate = getRate(from: from.currency, to: currency, date: date)
        if rate == 0 {
            rate = getRate(from: currency, to: from.currency, date: date)
            if rate == 0 {
                if #available(iOS 13.0, *) {
                    if #available(OSX 10.15, *) {
                        rate = ExchangeRateService.getExchangeRateForTesting(from: from.currency, to: currency) ?? 0
                    } else {
                        // Fallback on earlier versions
                    }
                } else {
                    // Fallback on earlier versions
                    return nil
                }
                if rate == 0 {
                    return nil
                }
            } else {
                rate = 1.0 / rate
            }
        }

        let amount = Money(from.amount * rate, currency)
        return amount
    }

    public mutating func add(date: Date, from: Currency, to: Currency, rate: Double) {
        let exchangeRate = ExchangeRate(date: date, from: from, to: to, rate: rate)
        rates.append(exchangeRate)
    }

    private struct ExchangeRate: Codable {
        let date: Date
        let from: Currency
        let to: Currency
        let rate: Double
    }
}
