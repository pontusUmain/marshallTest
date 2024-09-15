//
//  NetworkService.swift
//  MarshallTest
//
//  Created by Pontus Croneld on 2024-09-13.
//

import Foundation
import Combine

final class NetworkService {
    private var subscriptions = Set<AnyCancellable>()
    
    private let decoder = JSONDecoder()

    // MARK: Combine
    private func fetchFromUrl(url: String) -> AnyPublisher<[CryptoCurrency], Never> {
        guard let url = URL(string: url) else {
            return Just([])
                .eraseToAnyPublisher()
        }
         let currencyPublisher = URLSession
            .shared
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [CryptoCurrency].self, decoder: decoder)
            .catch { _ in return Just([]) }
            .eraseToAnyPublisher()
        
        return currencyPublisher
    }

    func getCurrenciesWithCombine(url: String) {
        fetchFromUrl(url: url)
            .sink { result in
                if let first = result.first {
                    print("Combine: \(first)")
                } else {
                    print("Combine: fetch empty")
                }
            }
            .store(in: &subscriptions)

    }
        
    // MARK: AsyncAwait
    
    private func load<T: Decodable>(endpoint: Endpoint) async throws -> T {
        guard let url = endpoint.url else {
            throw NetworkError.invalidUrl
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        if (response as! HTTPURLResponse).statusCode != 200 {
            throw NetworkError.fetchFailed
        }
        return try decoder.decode(T.self, from: data)
    }
    
    func loadCurrencies() async throws -> [CryptoCurrency] {
        do {
            let currencyResponse: [CryptoCurrency] = try await load(endpoint: .cryptoApi)
            return currencyResponse
        } catch {
            print(error.localizedDescription)
            throw NetworkError.fetchFailed
        }
    }
    
    func loadExchangeRate() async throws -> Double? {
        do {
            let exchangeRateResponse: ExchangeResult = try await load(endpoint: .exchangeApi)
            let sekExchangeRate = exchangeRateResponse.getExchangeRate(for: "sek")
            return sekExchangeRate
        } catch {
            print(error.localizedDescription)
            throw NetworkError.fetchFailed
        }
    }
}

extension NetworkService {
    enum NetworkError: Error {
        case fetchFailed
        case invalidUrl
    }
}

enum Endpoint {
    case cryptoApi
    case exchangeApi
    
    var url: URL? {
        switch self {
        case .cryptoApi:
            return URL(string: "https://api.wazirx.com/sapi/v1/tickers/24hr")
        case .exchangeApi:
            return URL(string: "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/usd.json")
        }
    }
}
