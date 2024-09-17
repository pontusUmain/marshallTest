//
//  ExchangeResult.swift
//  MarshallTest
//
//  Created by Pontus Croneld on 2024-09-15.
//

import Foundation

/// Response item for endpoint .exchangeApi
/// Array usd is used to determine the exchange rate of various currencies to the US dollar
struct ExchangeResult: Codable {
    let date: String
    let usd: [String: Double]
}

extension ExchangeResult {
    /// Method to find exchange rate for specified currency
    /// - Parameter currency: Short name for currency to be exchanged to USD
    /// - Returns: Optional double for the exchange rate, returns nil if key not found
    func getExchangeRate(for currency: String) -> Double? {
        guard let rate = usd.first(where: { $0.key.lowercased() == currency.lowercased() }) else {
            return nil
        }
        
        return rate.value
    }
}
