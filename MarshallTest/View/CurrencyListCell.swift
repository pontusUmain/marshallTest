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
        case content(model: CryptoCurrencyModel, darkCell: Bool, exchange: CurrentCurrency)
        
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
            case .content(let model, _, let exchange):
                let price = String(format: Constants.Format.twoDecimalFormat, model.lastPrice * exchange.exchangeRate)
                cellContent(currencyName: model.name, price: "\(exchange.currency.symbol)\(price)")
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
    let placeHolder = CryptoCurrencyModel.placeholder
    
    return VStack(spacing: 0) {
        CryptoCurrencyListCell(style: .placeholder(darkCell: true))
        CryptoCurrencyListCell(style: .content(model: placeHolder, darkCell: false, exchange: .init(currency: .usd, exchangeRate: 1)))
    }
}
