//
//  CurrencyListCell.swift
//  MarshallTest
//
//  Created by Pontus Croneld on 2024-09-13.
//

import SwiftUI

extension CryptoCurrencyListCell {
    enum Style {
        case placeholder(darkCell: Bool)
        case content(currency: CryptoCurrency, darkCell: Bool, exchange: CurrentCurrency)
        
        var isDarkCell: Bool {
            switch self {
            case .placeholder(let isDarkCell):
                return isDarkCell
            case .content(_, let isDarkCell, _):
                return isDarkCell
            }
        }
    }
}

struct CryptoCurrencyListCell: View {
    
    private let style: Style
    
    init(style: Style) {
        self.style = style
    }
    
    var body: some View {
        VStack {
            switch style {
            case .placeholder(_):
                cellContent(currencyName: "Placeholder", price: "SEK 123", redacted: true)
            case .content(let currency, _, let exchange):
                cellContent(currencyName: currency.getName, price: "\(exchange.currency.flag) \(currency.getPrice(rate: exchange.exchangeRate))")
            }
        }
        .foregroundStyle(.foreground)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(Color.green.opacity(style.isDarkCell ? 0.9 : 0.5))
    }
    
    private func cellContent(currencyName: String, price: String, redacted: Bool = false) -> some View {
        HStack {
            Text(currencyName)
                .redacted(reason: redacted ? .placeholder : [])
            Spacer()
            Text(price)
                .redacted(reason: redacted ? .placeholder : [])
        }
    }
}

#Preview {
    let placeHolder = CryptoCurrency(symbol: "symbol", baseAsset: "btc", quoteAsset: "quoteAsset", openPrice: "openPrice", lowPrice: "lowPrice", highPrice: "highPrice", lastPrice: "5.0", volume: "volume", bidPrice: "bidPrice", askPrice: "askPrice", at: 10)
    let mockCurrency2 = CryptoCurrency(symbol: "symbol", baseAsset: "wrx", quoteAsset: "quoteAsset", openPrice: "openPrice", lowPrice: "lowPrice", highPrice: "highPrice", lastPrice: "12", volume: "volume", bidPrice: "bidPrice", askPrice: "askPrice", at: 10)
    let mockCurrency3 = CryptoCurrency(symbol: "symbol", baseAsset: "dht", quoteAsset: "quoteAsset", openPrice: "openPrice", lowPrice: "lowPrice", highPrice: "highPrice", lastPrice: "32", volume: "volume", bidPrice: "bidPrice", askPrice: "askPrice", at: 10)
    
    return VStack(spacing: 0) {
        CryptoCurrencyListCell(style: .placeholder(darkCell: true))
        CryptoCurrencyListCell(style: .content(currency: mockCurrency2, darkCell: false, exchange: .init(currency: .usd, exchangeRate: 1)))
        CryptoCurrencyListCell(style: .placeholder(darkCell: true))

    }
}
