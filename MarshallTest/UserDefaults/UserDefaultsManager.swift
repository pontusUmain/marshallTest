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
    
    /// Function accessible for the ViewModel to manipulate the array of favorites in UserDefaults
    /// - Parameter model: Single CryptoCurrencyModel to be updated, either removed or appended to the list of favorites
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
        
        saveFavoritesToUserDefauls(models: favoriteArray)
    }
    
    /// Function accessibile for the Viewmodel to get the current list of favorite cryptos from UserDefaults
    /// - Returns: An array of CryptoCurrencyModel
    func getFavorites() -> [CryptoCurrencyModel] {
        return getFavoritesFromUserDefaults()
    }
    
    /// Private func to handle the decoding and checking of user defaults.
    /// - Returns: An array of CryptoCurrencyModel
    private func getFavoritesFromUserDefaults() -> [CryptoCurrencyModel] {
        guard let data = UserDefaults.standard.data(forKey: Constants.UserDefaults.favorites) else {
            return []
        }
        do {
            let favorites = try decoder.decode([CryptoCurrencyModel].self, from: data)
            return favorites
        } catch {
            print("Could not read from user defaults: \(error.localizedDescription)")
        }
        
        return []
    }
    
    /// Private func that encodes the updated list of favorite marked models and saves it to user defaults
    /// - Parameter models: CryptoCurrencyModel
    private func saveFavoritesToUserDefauls(models: [CryptoCurrencyModel]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(models)
            userDefaults.setValue(data, forKey: Constants.UserDefaults.favorites)
        } catch {
            print("Could not save to user defaults")
        }
    }
    
}
