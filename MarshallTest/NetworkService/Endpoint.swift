//
//  Endpoint.swift
//  MarshallTest
//
//  Created by Pontus Croneld on 2024-09-16.
//

import Foundation

/// Endpoints used in the NetworkService
/// Can be expanded for baseUrl and queries
enum Endpoint {
    case cryptoApi
    case exchangeApi
    
    var url: URL? {
        switch self {
        case .cryptoApi:
            return URL(string: Constants.Urls.cryptoApi)
        case .exchangeApi:
            return URL(string: Constants.Urls.exchangeApi)
        }
    }
}
