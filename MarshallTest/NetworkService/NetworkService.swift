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

    // MARK: Combine
    private func fetchFromUrl(url: String) -> AnyPublisher<[Currency], Never> {
        guard let url = URL(string: url) else {
            return Just([])
                .eraseToAnyPublisher()
        }
         let currencyPublisher = URLSession
            .shared
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Currency].self, decoder: JSONDecoder())
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
    private func fetchFromUrl(url: String) async throws -> [Currency] {
        guard let url = URL(string: url) else {
            throw NetworkError.invalidUrl
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Currency].self, from: data)
    }
    
    func getCurrenciesWithAsync(url: String) async throws -> [Currency] {
        do {
            return try await fetchFromUrl(url: url)
        } catch let error {
            print("Async error")
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
