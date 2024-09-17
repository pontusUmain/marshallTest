//
//  Currency.swift
//  MarshallTest
//
//  Created by Pontus Croneld on 2024-09-15.
//

import Foundation
import SwiftUI

/// Class for real life currencies to show the cost of crypto currencies
/// CurrencyOption is an enum of SEK and USD, the two relevant currencies for this app
/// Exchange rate is a multiplier of the costs in the CryptoCurrencyResponse
class Currency {
    let currency: CurrencyOption
    let exchangeRate: Double
    
    init(currency: CurrencyOption, exchangeRate: Double) {
        self.currency = currency
        self.exchangeRate = exchangeRate
    }
}

enum CurrencyOption {
    case usd
    case sek
    
    /// Used for content in the Switch currency button
    var flag: String {
        switch self {
        case .usd:
            "🇺🇸"
        case .sek:
            "🇸🇪"
        }
    }
    
    /// Used for content in the Switch currency button
    var oppositeFlag: String {
        switch self {
        case .usd:
            "🇸🇪"
        case .sek:
            "🇺🇸"
        }
    }
    
    /// Used to specify which currency is the price shown as
    var symbol: String {
        switch self {
        case .usd:
            "$"
        case .sek:
            "SEK"
        }
    }
}
