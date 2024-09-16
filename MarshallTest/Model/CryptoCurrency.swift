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

extension CryptoCurrency {
    var getName: String {
        if let name = loadNameJson(key: self.baseAsset) {
            return name
        } else {
            return ""
        }
    }
    
    func getPrice(rate: Double) -> String {
        guard let price = Double(lastPrice) else {
            return ""
        }
        
        return "\(price * rate)"
    }
    
    func loadNameJson(key: String) -> String? {
        if let url = Bundle.main.url(forResource: "cryptocurrencies", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([String: String].self, from: data)
            
                guard let first = jsonData.first(where: { $0.key.lowercased() == key }) else {
                    return nil
                }
                
                return first.value
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}



