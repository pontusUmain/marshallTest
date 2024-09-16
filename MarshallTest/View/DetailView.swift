//
//  DetailView.swift
//  MarshallTest
//
//  Created by Pontus Croneld on 2024-09-16.
//

import SwiftUI

struct DetailView: View {
    
    let model: CryptoCurrencyModel
    let currentCurrency: CurrentCurrency
    
    init(model: CryptoCurrencyModel, currentCurrency: CurrentCurrency) {
        self.model = model
        self.currentCurrency = currentCurrency
    }
    
    var body: some View {
        VStack {
            Image("crypto")
                .resizable()
                .scaledToFit()
                .padding(.bottom, 20)
                
            detailItem(name: Constants.Strings.baseAsset, value: model.name)
            detailItem(name: Constants.Strings.symbol, value: model.symbol)
            detailItem(name: Constants.Strings.quoteAsset, value: model.quoteAsset)
            priceItem(name: Constants.Strings.openPrice, value: model.openPrice)
            priceItem(name: Constants.Strings.lowPrice, value: model.lowPrice)
            priceItem(name: Constants.Strings.highPrice, value: model.highPrice)
            priceItem(name: Constants.Strings.lastPrice, value: model.lastPrice)
            detailItem(name: Constants.Strings.volume, value: model.volume)
            priceItem(name: Constants.Strings.bidPrice, value: model.bidPrice)
            priceItem(name: Constants.Strings.askPrice, value: model.askPrice)
            detailItem(name: Constants.Strings.at, value: "\(model.at)")
            Spacer()
        }
        .ignoresSafeArea()

    }
    
    func detailItem(name: String, value: String) -> some View {
        HStack {
            Text("\(name):")
                .bold()
            Spacer()
            Text(value)
        }
        .padding(.horizontal)
    }
    
    func priceItem(name: String, value: Double) -> some View {
        
        let price = String(format: Constants.Format.twoDecimalFormat, value * currentCurrency.exchangeRate)
    
        return HStack {
            Text("\(name):")
                .bold()
            Spacer()
            Text(" \(currentCurrency.currency.flag)\(price)")
        }
        .padding(.horizontal)
    }
}

#Preview {
    let mocky = CryptoCurrencyModel(symbol: "symbol", baseAsset: "dht", quoteAsset: "quoteAsset", openPrice: 10.10, lowPrice: 20.2, highPrice: 33.1, lastPrice: 44.8, volume: "volume", bidPrice: 55, askPrice: 66.555, at: 123, name: "Bitcoin")
    
    return DetailView(model: mocky, currentCurrency: .init(currency: .usd, exchangeRate: 1))
}
