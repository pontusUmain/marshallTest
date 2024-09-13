//
//  Currency.swift
//  MarshallTest
//
//  Created by Pontus Croneld on 2024-09-13.
//

import Foundation

struct Currency: Codable, Hashable {
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

extension Currency {
    func getCurrencyName() -> String? {
        loadNameJson(key: self.baseAsset)
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



