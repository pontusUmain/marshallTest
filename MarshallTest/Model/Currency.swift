//
//  Currency.swift
//  MarshallTest
//
//  Created by Pontus Croneld on 2024-09-15.
//

import Foundation
import SwiftUI

class CurrentCurrency {
    let currency: Currency
    let exchangeRate: Double
    
    init(currency: Currency, exchangeRate: Double) {
        self.currency = currency
        self.exchangeRate = exchangeRate
    }
}

enum Currency {
    case usd
    case sek
    
    var flag: String {
        switch self {
        case .usd:
            "🇺🇸"
        case .sek:
            "🇸🇪"
        }
    }
    
    var oppositeFlag: String {
        switch self {
        case .usd:
            "🇸🇪"
        case .sek:
            "🇺🇸"
        }
    }
    
    var symbol: String {
        switch self {
        case .usd:
            "$"
        case .sek:
            "SEK"
        }
    }
}
