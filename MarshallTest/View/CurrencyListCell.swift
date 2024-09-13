//
//  CurrencyListCell.swift
//  MarshallTest
//
//  Created by Pontus Croneld on 2024-09-13.
//

import SwiftUI

struct CurrencyListCell: View {
    
    private let currency: Currency
    private let darkCell: Bool
    
    init(currency: Currency, darkCell: Bool) {
        self.currency = currency
        self.darkCell = darkCell
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(currency.getCurrencyName() ?? "ERROR")
                    .padding(30)
                Spacer()
            }
        }
        .background(Color.green.opacity(darkCell ? 0.9 : 0.5))
    }
}

#Preview {
    let mockCurrency1 = Currency(symbol: "symbol", baseAsset: "btc", quoteAsset: "quoteAsset", openPrice: "openPrice", lowPrice: "lowPrice", highPrice: "highPrice", lastPrice: "lastPrice", volume: "volume", bidPrice: "bidPrice", askPrice: "askPrice", at: 10)
    let mockCurrency2 = Currency(symbol: "symbol", baseAsset: "abc", quoteAsset: "quoteAsset", openPrice: "openPrice", lowPrice: "lowPrice", highPrice: "highPrice", lastPrice: "lastPrice", volume: "volume", bidPrice: "bidPrice", askPrice: "askPrice", at: 10)
    let mockCurrency3 = Currency(symbol: "symbol", baseAsset: "dht", quoteAsset: "quoteAsset", openPrice: "openPrice", lowPrice: "lowPrice", highPrice: "highPrice", lastPrice: "lastPrice", volume: "volume", bidPrice: "bidPrice", askPrice: "askPrice", at: 10)
    
    return VStack(spacing: 0) {
        CurrencyListCell(currency: mockCurrency1, darkCell: true)
        CurrencyListCell(currency: mockCurrency2, darkCell: false)
        CurrencyListCell(currency: mockCurrency3, darkCell: true)
    }
}
