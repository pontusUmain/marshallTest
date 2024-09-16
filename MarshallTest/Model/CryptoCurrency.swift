//
//  Currency.swift
//  MarshallTest
//
//  Created by Pontus Croneld on 2024-09-13.
//

import Foundation

struct CryptoCurrencyResponse: Codable {
    let symbol: String
    let baseAsset: String
    let quoteAsset: String
    let openPrice: String
    let lowPrice: String
    let highPrice: String
    let lastPrice: String
    let volume: String
    let bidPrice: String
    let askPrice: String
    let at: Int
    
    func makeModel(name: String) -> CryptoCurrencyModel? {
        guard let openPrice = Double(self.openPrice),
              let lowPrice = Double(self.lowPrice),
              let highPrice = Double(self.highPrice),
              let lastPrice = Double(self.lastPrice),
              let bidPrice = Double(self.bidPrice),
              let askPrice = Double(self.askPrice) else {
            return nil
        }
        return CryptoCurrencyModel(
            symbol: self.symbol,
            baseAsset: self.baseAsset,
            quoteAsset: self.quoteAsset,
            openPrice: openPrice,
            lowPrice: lowPrice,
            highPrice: highPrice,
            lastPrice: lastPrice,
            volume: self.volume,
            bidPrice: bidPrice,
            askPrice: askPrice,
            at: self.at,
            name: name)
    }
}

struct CryptoCurrencyModel: Hashable {
    let symbol: String
    let baseAsset: String
    let quoteAsset: String
    let openPrice: Double
    let lowPrice: Double
    let highPrice: Double
    let lastPrice: Double
    let volume: String
    let bidPrice: Double
    let askPrice: Double
    let at: Int
    let name: String
}

extension CryptoCurrencyModel {
    static let placeholder: CryptoCurrencyModel = .init(symbol: "Mock", baseAsset: "placeholder", quoteAsset: "placeholder", openPrice: 0.0, lowPrice: 0.0, highPrice: 0.0, lastPrice: 0.0, volume: "placeholder", bidPrice: 0.0, askPrice: 0.0, at: 0, name: "placeholder")
}

struct CryptoCurrency: Codable, Hashable {
    let symbol: String
    let baseAsset: String
    let quoteAsset: String
    let openPrice: String
    let lowPrice: String
    let highPrice: String
    let lastPrice: String
    let volume: String
    let bidPrice: String
    let askPrice: String
    let at: Int
}
