//
//  Constants.swift
//  MarshallTest
//
//  Created by Pontus Croneld on 2024-09-16.
//

import Foundation

struct Constants {  
    struct Strings {
        // Crypto model
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
        
        // States
        static let errorMessage = "Oh no something weird happened! D:"
        static let emptyMessage = "Nothing to see here :( No cryptos found"
        
        // Buttons
        static let reloadButton = "Reload"
        static let switchButton = "Switch to"
        static let favoritesButton = "Favorites"
        static let removeFavoriteButton = "Remove"
    }
    
    struct Urls {
        static let cryptoApi = "https://api.wazirx.com/sapi/v1/tickers/24hr"
        static let exchangeApi = "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/usd.json"
        static let cryptoNameJson = "cryptocurrencies"
    }
    
    struct Format {
        static let twoDecimalFormat = "%.2f"
    }
    
    struct UserDefaults {
        static let favorites = "favorites"
    }
    
    struct Accessibility {
        static let markAsFavorite = "Mark as favorite"
        static let removeAsFavorite = "Remove as favorite"
        static let seeFavorites = "See favorites"
        static let dismiss = "Dismiss"
    }
    
    struct Image {
        static let heart = "heart"
        static let heartFill = "heart.fill"
        static let crypto = "crypto"
    }
}
