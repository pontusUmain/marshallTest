//
//  ViewModel.swift
//  MarshallTest
//
//  Created by Pontus Croneld on 2024-09-13.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    
    // Network service
    private let networkService = NetworkService()
    private let url = "https://api.wazirx.com/sapi/v1/tickers/24hr"
    
    @Published var viewState: ViewState = .loadingState
    @Published var exchange: [CurrentCurrency] = [.init(currency: .usd, exchangeRate: 1)]
    @Published var currentExchangeIndex: Int = 0
    
    @MainActor
    func getCurrencies() async {
        do {
            let currencies = try await networkService.loadCurrencies()
            viewState = currencies.isEmpty ? .emptyState : .contentState(currencies: currencies)
        } catch let error {
            print(error)
            viewState = .errorState
        }
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
        await getCurrencies()
        viewState = .loadingState
    }
}

extension ViewModel {
    enum ViewState {
        case loadingState
        case contentState(currencies: [CryptoCurrency])
        case emptyState
        case errorState
    }
}

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
            "$"
        case .sek:
            "SEK"
        }
    }
    
    var oppositeFlag: String {
        switch self {
        case .usd:
            "SEK"
        case .sek:
            "$"
        }
    }
    
    var buttonColor: Color {
        switch self {
        case .usd:
                .yellow
        case .sek:
                .red
        }
    }
}
