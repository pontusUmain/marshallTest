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
    
    @Published var viewState: ViewState = .loadingState
    @Published var exchange: [CurrentCurrency] = [.init(currency: .usd, exchangeRate: 1)]
    @Published var currentExchangeIndex: Int = 0
    @Published var models = [CryptoCurrencyModel]()
    @Published var favorites = [CryptoCurrencyModel]()
    
    @MainActor
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
    
    private func loadCurrencyModels(currencyResponse: [CryptoCurrencyResponse]) -> [CryptoCurrencyModel] {
        let currencyNameResponse = networkService.loadCryptoNamesFromJson()
        let models: [CryptoCurrencyModel?] = currencyResponse.map { response in
            let currencyName = currencyNameResponse.first(where: { $0.key.lowercased() == response.baseAsset.lowercased() })?.value ?? "?"
            return response.makeModel(name: currencyName, isFavorite: checkModelAsFavorite(response.symbol) )
        }
        
        return models.compactMap { $0 }
    }
    
    func getFavorites() {
        favorites = userDefaultsManager.getFavorites()
    }
    
    private func checkModelAsFavorite(_ symbol: String) -> Bool {
        return favorites.contains { $0.symbol == symbol }
    }
    
    @MainActor
    func getExchangeRate() async {
        do {
            let exchangeRate = try await networkService.loadExchangeRate()
            guard let exchangeRate = exchangeRate else {
                // Show error, exchange rate is unavailable
                return
            }
            self.exchange.append(.init(currency: .sek, exchangeRate: exchangeRate))
        } catch {
            print(error.localizedDescription)
            // Show error, exchange rate is unavailable
        }
    }
    
    @MainActor
    func switchCurrency() {
        if currentExchangeIndex == 0, exchange.count > 0 {
            currentExchangeIndex = 1
        } else {
            currentExchangeIndex = 0
        }
    }
    
    @MainActor
    func reload() async {
        await getCryptoCurrencies()
        await getExchangeRate()
        viewState = .loadingState
    }
    
    func didChangeFavorite(model: CryptoCurrencyModel, isFavorite: Bool, index: Int) {
        models[index].isFavorite = isFavorite
        viewState = .contentState(models: models)
        userDefaultsManager.updateFavorites(model: model)
        getFavorites()
    }
    
    
}

extension ViewModel {
    enum ViewState {
        case loadingState
        case contentState(models: [CryptoCurrencyModel])
        case emptyState(message: String)
    }
}

