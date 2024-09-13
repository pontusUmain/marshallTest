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
    @Published var exchange: Exchange = .usd
    
    @MainActor
    func getCurrencies() async {
        do {
            let currencies = try await networkService.getCurrenciesWithAsync(url: url)
            viewState = currencies.isEmpty ? .emptyState : .contentState(currencies: currencies)
        } catch let error {
            print(error)
            viewState = .errorState
        }
    }
    
    func switchExchange() {
        if exchange == .usd {
            exchange = .sek
        } else {
            exchange = .usd
        }
    }
}

extension ViewModel {
    enum ViewState {
        case loadingState
        case contentState(currencies: [Currency])
        case emptyState
        case errorState
    }
}

enum Exchange {
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
