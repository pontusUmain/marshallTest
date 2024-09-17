//
//  UserDefaultsManager.swift
//  MarshallTest
//
//  Created by Pontus Croneld on 2024-09-17.
//

import Foundation

class UserDefaultsManager: ObservableObject {
    
    private let userDefaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
        
    func updateFavorites(model: CryptoCurrencyModel) {
        var favoriteArray = getFavoritesFromUserDefaults()
        
        if favoriteArray.contains(model) {
            favoriteArray.removeAll(where: { $0.symbol == model.symbol })
        } else {
            favoriteArray.append(
                CryptoCurrencyModel(
                    symbol: model.symbol,
                    baseAsset: model.baseAsset,
                    quoteAsset: model.quoteAsset,
                    openPrice: model.openPrice,
                    lowPrice: model.lowPrice,
                    highPrice: model.highPrice,
                    lastPrice: model.lastPrice,
                    volume: model.volume,
                    bidPrice: model.bidPrice,
                    askPrice: model.askPrice,
                    at: model.at,
                    name: model.name,
                    isFavorite: true))
        }
        
        saveFavoriteToUserDefauls(models: favoriteArray)
    }
    
    func getFavorites() -> [CryptoCurrencyModel] {
        return getFavoritesFromUserDefaults()
    }

    private func getFavoritesFromUserDefaults() -> [CryptoCurrencyModel] {
        guard let data = UserDefaults.standard.data(forKey: Constants.UserDefaults.favorites) else {
            return []
        }
        do {
            let favorites = try decoder.decode([CryptoCurrencyModel].self, from: data)
            return favorites
        } catch {
            // Fallback
            print("Could not read from user defaults: \(error.localizedDescription)")
        }
        
        return []
    }
    
    private func saveFavoriteToUserDefauls(models: [CryptoCurrencyModel]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(models)
            userDefaults.setValue(data, forKey: Constants.UserDefaults.favorites)
        } catch {
            print("Could not save to user defaults")
        }
    }
    
}
