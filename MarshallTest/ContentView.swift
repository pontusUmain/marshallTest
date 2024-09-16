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
                content(currencies: [])
            case .contentState(let currencies):
                content(currencies: currencies)
            case .emptyState:
                emptyState()
            case .errorState:
                errorState()
            }
        }
        .task {
            await viewModel.getCurrencies()
            await viewModel.getExchangeRate()
        }
    }
    
    private func emptyState() -> some View {
        Text("Nothing to see here :( No cryptos found")
    }
    
    private func errorState() -> some View {
        VStack {
            Text("Oh no something weird happened! D:")
        
            Button(action: {
                Task {
                    await viewModel.reload()
                }
            }) {
                Text("Reload")
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                
            }
        }
        
    }
    
    private func content(currencies: [CryptoCurrencyModel]) -> some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    if currencies.isEmpty {
                        ForEach(0...20, id: \.self) { index in
                            CryptoCurrencyListCell(style: .placeholder(darkCell: index % 2 == 0))
                        }
                    } else {
                        ForEach(Array(currencies.enumerated()), id: \.offset) { index, item in
                            NavigationLink(destination: DetailView(model: item, currentCurrency: viewModel.exchange[viewModel.currentExchangeIndex])) {
                                CryptoCurrencyListCell(style: .content(model: item, darkCell: index % 2 == 0, exchange: viewModel.exchange[viewModel.currentExchangeIndex]))
                            }
                        }
                    }
                }
            }
            .navigationTitle("Title")
            .toolbar(content: {
                if viewModel.exchange.count > 0 {
                    Button(action: {
                        viewModel.switchCurrency()
                    }) {
                        Text("Switch")
                    }
                }
            })
        }
    }
}


#Preview {
    ContentView(viewModel: ViewModel())
}
