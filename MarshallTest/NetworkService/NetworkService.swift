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
    
    /// Private generic function to load data using async/await
    /// Throws url error if the URL is invalid and fetch fail if status code is not 200 OK
    /// - Parameter endpoint: Enum defined in NetworkService/Endpoint
    /// - Returns: Generic data typ
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
    
    /// Function accessible to the viewModel to use the generic async await fetch
    /// Expects an array of CryptoCurrencyResponseItem from the cryptoApi
    /// Throws fetchFailed error if load function fails to decode as expected
    /// - Returns: Array of CryptoCurrencyResponseItem, to be typecase as CryptoCurrencyModel down the line
    func loadCurrencies() async throws -> [CryptoCurrencyResponseItem] {
        do {
            let currencyResponse: [CryptoCurrencyResponseItem] = try await load(endpoint: .cryptoApi)
            return currencyResponse
        } catch {
            print(error.localizedDescription)
            throw NetworkError.fetchFailed
        }
    }
    
    /// Function accessible to the viewModel to use the generic async await fetch
    /// Expects an ExchangeResult from the exchangeApi
    /// Throws fetchFailed error if load function fails to decode as expected
    /// - Returns: Optional exchange rate Double to compare SEK to USD
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
    
    /// Private generic function to load JSON from a bundled source
    /// - Parameter resource: The name of the bundled JSON file
    /// - Returns: The same type as requested when function called
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
    
    /// Function accessible to the viewModel to load values from the cryptocurrencies json file
    /// - Returns: A dictionary with string keys and values
    func loadCryptoNamesFromJson() -> [String: String] {
        let cryptoNameResponse: [String: String]? = loadJson(resource: Constants.Urls.cryptoNameJson)
        return cryptoNameResponse ?? [:]
    }
    
    // MARK: Combine - unused
    /// Functions to fetch CryptoCurrencyResponseItem from the cryptoApi using combine. Ended up using the Async/Await solution instead but left as a remainder for how I would approach the soltuion using combine
    private func load(endpoint: Endpoint) -> AnyPublisher<[CryptoCurrencyResponseItem], Never> {
        guard let url = endpoint.url else {
            return Just([])
                .eraseToAnyPublisher()
        }
         let currencyPublisher = URLSession
            .shared
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [CryptoCurrencyResponseItem].self, decoder: decoder)
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
