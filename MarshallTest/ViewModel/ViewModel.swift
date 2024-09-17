//
//  ViewModel.swift
//  MarshallTest
//
//  Created by Pontus Croneld on 2024-09-13.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    
    private let networkService = NetworkService()
    private let userDefaultsManager = UserDefaultsManager()
    
    /// State handling for UI in CurrencyListView
    @Published var viewState: ViewState = .loadingState
    /// All Currency models, USD by default, and SEK added after fetch from API call
    @Published var exchange: [Currency] = [.init(currency: .usd, exchangeRate: 1)]
    /// Current index of the Exchange array, determining which currency is currently being shown to the user
    @Published var currentExchangeIndex: Int = 0
    /// All CryptoCurrencyModels as fetched from API call
    @Published var models = [CryptoCurrencyModel]()
    /// All CryptoCurrencyModels marked as favorites, as fetched from UserDefaults
    @Published var favorites = [CryptoCurrencyModel]()
    
    @MainActor
    /// Triggers an API call to load cryptoCurrencies asynchronously. ViewState is updated as emptyState if the response is empty
    /// Items in the response are cast as CryptoCurrencyModel by loadCurrencyModels method
    /// ViewState is updated to show content if type cast succeeds, showing a list of CryptoCurrencyModel
    /// ViewState is updated to empty state on error or if type cast fails
    /// Function is marked as MainActor to update UI on the main thread
    func getCryptoCurrencies() async {
        do {
            let currencyResponse = try await networkService.loadCurrencies()
            if currencyResponse.isEmpty {
                viewState = .emptyState(message: Constants.Strings.emptyMessage)
                return
            }
            
            models = loadCurrencyModels(currencyResponse: currencyResponse)
            viewState = models.isEmpty ? .emptyState(message: Constants.Strings.emptyMessage) : .contentState(models: models)
            
        } catch let error {
            print(error)
            viewState = .emptyState(message: Constants.Strings.errorMessage)
        }
    }
    
    /// Triggers a JSON decoding from the bundled JSON-file to acquire names of cryptocurrencies
    /// Compares the base asset of each item in the currencyResponse to the keys of the currencyNameResponse
    /// If a key matches, the value is used for the name parameter of the CryptoCurrencyModel
    /// Models are marked as favorite by checkModelAsFavorite method
    /// Sorts out nil's and returns a list of non-optional CryptoCurrencyModel
    /// - Parameter currencyResponse: Response from networkService.loadCurrencies
    /// - Returns: Array of CryptoCurrencyModel
    private func loadCurrencyModels(currencyResponse: [CryptoCurrencyResponseItem]) -> [CryptoCurrencyModel] {
        let currencyNameResponse = networkService.loadCryptoNamesFromJson()
        let models: [CryptoCurrencyModel?] = currencyResponse.map { response in
            let currencyName = currencyNameResponse.first(where: { $0.key.lowercased() == response.baseAsset.lowercased() })?.value ?? "?"
            return response.makeModel(name: currencyName, isFavorite: checkModelAsFavorite(response.symbol) )
        }
        
        return models.compactMap { $0 }
    }
    
    /// Checks for CryptoCurrencyModels marked as favorite in UserDefaults and saves them locally in the Published array
    func getFavorites() {
        favorites = userDefaultsManager.getFavorites()
    }
    
    
    /// Checks if the local published list contains this model marked as favorite
    /// - Parameter symbol: A unique string value in the CurrencyResponse
    /// - Returns: Bool to confirm if a model is marked as favorite
    private func checkModelAsFavorite(_ symbol: String) -> Bool {
        return favorites.contains { $0.symbol == symbol }
    }
    
    @MainActor
    /// Triggers an API call to load exchange rates in networkService.loadExchangeRate
    /// Returns the exchange rate for SEK to USD
    /// If successful adds the exchange rate and currency SEK to the exchange array, which allows the user to switch currency
    /// Function is marked as MainActor to update UI on the main thread
    func getExchangeRate() async {
        do {
            let exchangeRate = try await networkService.loadExchangeRate()
            guard let exchangeRate = exchangeRate else {
                return
            }
            self.exchange.append(.init(currency: .sek, exchangeRate: exchangeRate))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// User has pressed Switch currency button
    /// USD is index [0] by default and if getExchangeRate was successful, SEK is index [1]
    func switchCurrency() {
        if currentExchangeIndex == 0, exchange.count > 0 {
            currentExchangeIndex = 1
        } else {
            currentExchangeIndex = 0
        }
    }
    
    @MainActor
    /// User has pressed reload button from the empty state
    /// ViewState is put back in loading state, showing placeholder rows and API calls are triggered for a reload
    func reload() async {
        viewState = .loadingState
        await getCryptoCurrencies()
        await getExchangeRate()
    }
    
    /// User has updated the favorite state of a model in a child view
    /// Finding the index of the model in the CurrencyListView
    /// Updates the local state of the CurrencyListView by changing the favorite state of found model
    /// Saving or removing the updated model in UserDefaults
    /// Calling getFavorites to update the local publised array of models marked as favorites
    /// - Parameters:
    ///   - model: Model being shown in child view
    ///   - isFavorite: New value to update
    func didChangeFavorite(model: CryptoCurrencyModel, isFavorite: Bool) {
        guard let index = models.firstIndex(where: { $0.symbol == model.symbol }) else { return }
        models[index].isFavorite = isFavorite
        viewState = .contentState(models: models)
        userDefaultsManager.updateFavorites(model: model)
        getFavorites()
    }
}

extension ViewModel {
    /// States used to render relevant views for the user
    /// Loading state when API calls are not finished, will render a placeholder list
    /// Content state when API has returned a list of models
    /// Empty state when API has returned an error or an empty list
    enum ViewState {
        case loadingState
        case contentState(models: [CryptoCurrencyModel])
        case emptyState(message: String)
    }
}

