//
//  Endpoint.swift
//  MarshallTest
//
//  Created by Pontus Croneld on 2024-09-16.
//

import Foundation

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
