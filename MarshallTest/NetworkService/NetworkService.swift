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
    
    func loadCurrencies() async throws -> [CryptoCurrencyResponse] {
        do {
            let currencyResponse: [CryptoCurrencyResponse] = try await load(endpoint: .cryptoApi)
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
    
    // MARK: JSON
    
    private func loadJson<T: Decodable>(resource: String) -> T? {
        if let url = Bundle.main.url(forResource: resource, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(T.self, from: data)
                
                return jsonData
            } catch {
                print("error:\(error)")
                return nil
            }
        }
        return nil
    }
    
    func loadCryptoNamesFromJson() -> [String: String] {
        let cryptoNameResponse: [String: String]? = loadJson(resource: Constants.Urls.cryptoNameJson)
        return cryptoNameResponse ?? [:]
    }
    
    // MARK: Combine - unused
    private func load(endpoint: Endpoint) -> AnyPublisher<[CryptoCurrency], Never> {
        guard let url = endpoint.url else {
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
        load(endpoint: .cryptoApi)
            .sink { result in
                if let first = result.first {
                    print("Combine: \(first)")
                } else {
                    print("Combine: fetch empty")
                }
            }
            .store(in: &subscriptions)

    }
}
