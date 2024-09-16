//
//  ContentView.swift
//  MarshallTest
//
//  Created by Pontus Croneld on 2024-09-13.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        Group {
            switch viewModel.viewState {
            case .loadingState:
                content(models: [])
            case .contentState(let currencies):
                content(models: currencies)
            case .emptyState(let message):
                emptyState(message)
            }
        }
        .task {
            await viewModel.getCryptoCurrencies()
            await viewModel.getExchangeRate()
        }
    }
    
    private func emptyState(_ message: String) -> some View {
        VStack {
            Text(message)
        
            Button(action: {
                Task {
                    await viewModel.reload()
                }
            }) {
                Text(Constants.Strings.reloadButton)
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                
            }
        }
    }
    
    private func content(models: [CryptoCurrencyModel]) -> some View {
        let currentCurrency = viewModel.exchange[viewModel.currentExchangeIndex]
        
        return NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    if models.isEmpty {
                        ForEach(0...20, id: \.self) { index in
                            CryptoCurrencyListCell(style: .placeholder(darkCell: index % 2 == 0))
                        }
                    } else {
                        ForEach(Array(models.enumerated()), id: \.offset) { index, item in
                            NavigationLink(destination: DetailView(model: item, currentCurrency: currentCurrency)) {
                                CryptoCurrencyListCell(style: .content(model: item, darkCell: index % 2 == 0, exchange: currentCurrency))
                            }
                        }
                    }
                }
            }
            .toolbar(content: {
                if viewModel.exchange.count > 0 {
                    Button(action: {
                        viewModel.switchCurrency()
                    }) {
                        Text("\(Constants.Strings.switchButton) \( currentCurrency.currency.oppositeFlag)")
                    }
                }
            })
        }
    }
}


#Preview {
    ContentView(viewModel: ViewModel())
}
