//
//  NetworkError.swift
//  MarshallTest
//
//  Created by Pontus Croneld on 2024-09-16.
//

import Foundation

extension NetworkService {
    /// Throwing errors in NetworkService
    enum NetworkError: Error {
        case fetchFailed
        case invalidUrl
    }
}
