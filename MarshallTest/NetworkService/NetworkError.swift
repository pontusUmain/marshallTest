//
//  NetworkError.swift
//  MarshallTest
//
//  Created by Pontus Croneld on 2024-09-16.
//

import Foundation

extension NetworkService {
    enum NetworkError: Error {
        case fetchFailed
        case invalidUrl
    }
}
