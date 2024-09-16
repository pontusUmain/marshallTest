//
//  Constants.swift
//  MarshallTest
//
//  Created by Pontus Croneld on 2024-09-16.
//

import Foundation

struct Constants {  
    struct Strings {
        static let symbol = "Symbol"
        static let baseAsset = "Base asset"
        static let quoteAsset = "Quote asset"
        static let openPrice = "Open price"
        static let lowPrice = "Low price"
        static let highPrice = "High price"
        static let lastPrice = "Last price"
        static let volume = "Volume"
        static let bidPrice = "Bid price"
        static let askPrice = "Ask price"
        static let at = "At"
    }
    
    struct Urls {
        static let cryptoApi = "https://api.wazirx.com/sapi/v1/tickers/24hr"
        static let exchangeApi = "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/usd.json"
        static let cryptoNameJson = "cryptocurrencies"
    }
    
    struct Format {
        static let twoDecimalFormat = "%.2f"
    }
}
