//
//  File.swift
//  
//
//  Created by Michael Rutherford on 1/8/21.
//

import Foundation


/// fixer.io is a web service that returns exchange rates as a JSON package
public struct ExchangeRatesFromFixer: Decodable {
    public var success: Bool
    var timestamp: Int64 = 0
    public var timeStampDate: Date {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return date
    }

    public var base: String = ""
    public var date = Date.distantPast
    public var rates: [String: Double] = [:]
}
