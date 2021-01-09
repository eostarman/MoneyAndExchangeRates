//
//  testExchangeRateService.swift
//  MoreMoneyTests
//
//  Created by Michael Rutherford on 7/12/20.
//

@testable import MoneyAndExchangeRates
import XCTest

@available(iOS 13.0, *)
class testExchangeRateService: XCTestCase {
    
    func testInitializingFromCache() throws {
        let exchange = ExchangeRatesService.cachedExchangeRatesService
        
        let money = Money(1.00, .EUR)
        let dollars = exchange.getMoney(from: money, to: .USD, date: Date())
        
        XCTAssertEqual(dollars, Money(1.22, .USD))
    }
    
    func testStorageOfMultipleRates() {
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        
        let rateToday = ExchangeRate(from: .EUR, to: .USD, date: today, rate: 1.10)
        let rateYesterday = ExchangeRate(from: .EUR, to: .USD, date: yesterday, rate: 1.05)
        let updatedRateYesterday = ExchangeRate(from: .EUR, to: .USD, date: yesterday, rate: 1.06)
        
        if true {
            let exchange = ExchangeRatesService(rateYesterday, rateToday, rateYesterday, updatedRateYesterday)
            
            XCTAssertEqual(exchange.allRates.count, 1)
            let rates = exchange.getRates(from: .EUR, to: .USD)
            
            XCTAssertEqual(rates.count, 2)
            XCTAssertEqual(rates[0], rateToday)
            XCTAssertEqual(rates[1], updatedRateYesterday)
        }
        
        if true {
            let exchange = ExchangeRatesService(rateToday, rateYesterday, rateYesterday, rateYesterday)
            
            XCTAssertEqual(exchange.allRates.count, 1)
            let rates = exchange.getRates(from: .EUR, to: .USD)
            
            XCTAssertEqual(rates.count, 2)
            XCTAssertEqual(rates[0], rateToday)
            XCTAssertEqual(rates[1], rateYesterday)
        }
    }
    
    func testLookupWithMultipleRates() {
        let today = Date()
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: today)!
        let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: today)!
        let fourDaysAgo = Calendar.current.date(byAdding: .day, value: -4, to: today)!
        let fiveDaysAgo = Calendar.current.date(byAdding: .day, value: -5, to: today)!
        
        let rateYesterday = ExchangeRate(from: .EUR, to: .USD, date: yesterday, rate: 1.12)
        let rateThreeDaysAgo = ExchangeRate(from: .EUR, to: .USD, date: threeDaysAgo, rate: 1.05)
        
        let exchange = ExchangeRatesService(rateYesterday, rateThreeDaysAgo)

        func getRate(_ date: Date) -> Double {
            exchange.getRate(from: .EUR, to: .USD, date: date) ?? 0
        }
   
        XCTAssertEqual(getRate(today), 1.12)
        XCTAssertEqual(getRate(yesterday), 1.12)
        XCTAssertEqual(getRate(twoDaysAgo), 1.05)
        XCTAssertEqual(getRate(threeDaysAgo), 1.05)
        XCTAssertEqual(getRate(fourDaysAgo), 1.05)
        XCTAssertEqual(getRate(fiveDaysAgo), 1.05)
        
    }
    
    func testActualWebCall() throws {
        let service = ExchangeRatesFixerService()
        
        // maybe try with MockURLProtocol - https://www.hackingwithswift.com/articles/153/how-to-test-ios-networking-code-the-easy-way
        let expectation = XCTestExpectation(description: "response")
        service.getDataFromServer { x in
            XCTAssertNotNil(x)
            XCTAssert(x?.success == true)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
}
