//
//  FavoritesListCell.swift
//  MarshallTest
//
//  Created by Pontus Croneld on 2024-09-17.
//

import SwiftUI

struct FavoritesListCell: View {
    
    let model: CryptoCurrencyModel
    let exchange: CurrentCurrency
    let isDarkCell: Bool
    let didPressRemove: () -> ()
    
    var body: some View {
        VStack(spacing: 5) {
            Group {
                textDetailRow(key: model.name, value: "")
                    .bold()
                priceDetailRow(key: Constants.Strings.openPrice, value: model.openPrice)
                priceDetailRow(key: Constants.Strings.lowPrice, value: model.lowPrice)
                priceDetailRow(key: Constants.Strings.highPrice, value: model.highPrice)
                priceDetailRow(key: Constants.Strings.askPrice, value: model.askPrice)
                priceDetailRow(key: Constants.Strings.bidPrice, value: model.bidPrice)
                priceDetailRow(key: Constants.Strings.lastPrice, value: model.lastPrice)
            }
            .foregroundStyle(.foreground)
            
            removeButton()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(Color.red.opacity(isDarkCell ? 0.8 : 0.5))
    }
    
    private func textDetailRow(key: String, value: String) -> some View {
        HStack {
            Text(key)
            Spacer()
            Text(value)
        }
    }
    
    private func priceDetailRow(key: String, value: Double) -> some View {
        let price = String(format: Constants.Format.twoDecimalFormat, model.lastPrice * exchange.exchangeRate)
        
        return HStack {
            Text(key)
            Spacer()
            Text("\(exchange.currency.symbol)\(price)")
        }
    }
    
    private func removeButton() -> some View {
        Button(action: { didPressRemove() }) {
            Text(Constants.Strings.removeFavoriteButton)
        }.buttonStyle(.bordered)
    }
}

#Preview {
    VStack(spacing: 0) {
        FavoritesListCell(model: .placeholder, exchange: .init(currency: .usd, exchangeRate: 1.0), isDarkCell: true, didPressRemove: {})
        FavoritesListCell(model: .placeholder, exchange: .init(currency: .usd, exchangeRate: 1.0), isDarkCell: false, didPressRemove: {})
    }
}
