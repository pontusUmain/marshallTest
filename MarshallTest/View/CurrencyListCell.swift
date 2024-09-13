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
    private let exchange: Exchange
    
    init(currency: Currency, darkCell: Bool, exchange: Exchange) {
        self.currency = currency
        self.darkCell = darkCell
        self.exchange = exchange
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(currency.getCurrencyName() ?? "ERROR")
                Spacer()
                Text("\(exchange.flag) \(currency.lastPrice)")
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
        .background(Color.green.opacity(darkCell ? 0.9 : 0.5))
    }
}

#Preview {
    let mockCurrency1 = Currency(symbol: "symbol", baseAsset: "btc", quoteAsset: "quoteAsset", openPrice: "openPrice", lowPrice: "lowPrice", highPrice: "highPrice", lastPrice: "5.0", volume: "volume", bidPrice: "bidPrice", askPrice: "askPrice", at: 10)
    let mockCurrency2 = Currency(symbol: "symbol", baseAsset: "wrx", quoteAsset: "quoteAsset", openPrice: "openPrice", lowPrice: "lowPrice", highPrice: "highPrice", lastPrice: "12", volume: "volume", bidPrice: "bidPrice", askPrice: "askPrice", at: 10)
    let mockCurrency3 = Currency(symbol: "symbol", baseAsset: "dht", quoteAsset: "quoteAsset", openPrice: "openPrice", lowPrice: "lowPrice", highPrice: "highPrice", lastPrice: "32", volume: "volume", bidPrice: "bidPrice", askPrice: "askPrice", at: 10)
    
    return VStack(spacing: 0) {
        CurrencyListCell(currency: mockCurrency1, darkCell: true, exchange: .sek)
        CurrencyListCell(currency: mockCurrency2, darkCell: false, exchange: .usd)
        CurrencyListCell(currency: mockCurrency3, darkCell: true, exchange: .sek)
    }
}
