import Foundation

public final class ExchangeRatesService: Codable {
    var allRates: [Key: [ExchangeRate]] = [:]
    
    public var isEmpty: Bool { allRates.isEmpty }
    
    struct Key: Codable, Hashable {
        let from: Currency
        let to: Currency
    }
    
    public static var cachedExchangeRatesService: ExchangeRatesService {
        var allRates: [ExchangeRate] = []
        
        let fixer = ExchangeRatesFixerService.cachedExchangeRatesFromFixer
        
        guard let fromCurrency = Currency(string: fixer.base) else {
            return ExchangeRatesService()
        }
        
        let date = fixer.date
        
        for x in fixer.rates {
            guard let toCurrency = Currency(string: x.key) else {
                continue
            }
            
            let rate = x.value
            
            allRates.append(ExchangeRate(from: fromCurrency, to: toCurrency, date: date, rate: rate))
        }
        
        return ExchangeRatesService(allRates)
    }
    
    public init() {
        
    }
    
    public convenience init(_ rates: ExchangeRate ...) {
        self.init(rates)
    }
    
    public init(_ rates: [ExchangeRate]) {
        allRates = [:]
        
        for rate in rates {
            add(rate)
        }
    }
    
    public func getRates(from: Currency, to: Currency) -> [ExchangeRate] {
        allRates[Key(from: from, to: to)] ?? []
    }
    
    public func getRate(from: Currency, to: Currency, date: Date) -> Double? {
        
        guard let rates = allRates[Key(from: from, to: to)] else {
            return nil
        }
        
        var earlierRate: ExchangeRate?
        var laterRate: ExchangeRate?
        
        for rate in rates {
            
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
        
        // an earlier exchange rate is effective until it's superceded by a more-recent exchange rate
        if let earlierRate = earlierRate {
            return earlierRate.rate
        }
        
        // I'm looking for a date older than my oldest rate - so use the oldest rate
        if let laterRate = laterRate {
            return laterRate.rate
        }
        
        return nil
    }
    
    public func getMoney(from: Money, to newCurrency: Currency, date: Date, numberOfDecimals: Int) -> Money? {
        if from.currency == newCurrency {
            return from
        }
        
        if let rate = getRate(from: from.currency, to: newCurrency, date: date), rate > 0 {
            return Money(from.amount * rate, newCurrency, numberOfDecimals: numberOfDecimals)
        }
        
        if let reverseRate = getRate(from: newCurrency, to: from.currency, date: date), reverseRate > 0 {
            return Money(from.amount / reverseRate, newCurrency, numberOfDecimals: numberOfDecimals)
        }

        return nil
    }
    
    /// Add the exchange rate from one currency to another on a particular date, replacing any prior entry with the same from/to/date.
    public func add(_ exchangeRate: ExchangeRate) {
        guard exchangeRate.rate > 0.0 else {
            return
        }
        
        let key = Key(from: exchangeRate.from, to: exchangeRate.to)
        
        // make sure that there are no duplicates (same key and date); also, within a key, sort so that the most-recent date is first
        if let priorRates = allRates[key] {
            var newRates = priorRates.filter { $0.date != exchangeRate.date }
            newRates.append(exchangeRate)
            if newRates.count > 1 {
                newRates = newRates.sorted(by: { $0.date > $1.date })
            }
            
            allRates[key] = newRates
            
        } else {
            allRates[key] = [ exchangeRate ]
        }
    }
}
