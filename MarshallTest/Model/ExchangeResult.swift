//
//  ExchangeResult.swift
//  MarshallTest
//
//  Created by Pontus Croneld on 2024-09-15.
//

import Foundation

struct ExchangeResult: Codable {
    let date: String
    let usd: [String: Double]
}

extension ExchangeResult {
    func getExchangeRate(for currency: String) -> Double? {
        guard let rate = usd.first(where: { $0.key.lowercased() == currency.lowercased() }) else {
            return nil
        }
        
        return rate.value
    }
}
