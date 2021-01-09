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
}
