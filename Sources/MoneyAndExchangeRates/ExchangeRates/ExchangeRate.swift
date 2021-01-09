//
//  File.swift
//  
//
//  Created by Michael Rutherford on 1/8/21.
//

import Foundation

public struct ExchangeRate: Codable, Equatable {
    let from: Currency
    let to: Currency
    let date: Date
    let rate: Double
    
    /// Define the multiplier used to convert an amount in one currency to another - effective on the given date
    /// - Parameters:
    ///   - from: the source currency
    ///   - to: the target currency
    ///   - date: when the rate (the multiplier) takes effect
    ///   - rate: the rate to multiply the amount in the 'from' currency by to get an equivalent amount in the 'to' currency
    public init(from: Currency, to: Currency, date: Date, rate: Double) {
        self.from = from
        self.to = to
        self.date = date
        self.rate = rate
    }
}
