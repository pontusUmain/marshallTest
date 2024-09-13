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
                loadingState()
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
        }
    }
    
    private func emptyState() -> some View {
        Text("Nothing to see here :(")
    }
    
    private func loadingState() -> some View {
        Text("Almost there...")
    }
    
    private func errorState() -> some View {
        Text("Oh no something weird happened! D:")
    }
    
    private func content(currencies: [Currency]) -> some View {
        NavigationStack {
            ScrollView {
                LazyVStack(content: {
                    ForEach(Array(currencies.enumerated()), id: \.offset) { index, item in
                        CurrencyListCell(currency: item, darkCell: index % 2 == 0, exchange: viewModel.exchange)
                    }
                })
            }
            .navigationTitle("Title")
            .toolbar(content: {
                Button(action: {
                    viewModel.switchExchange()
                }) {
                    Text(viewModel.exchange.oppositeFlag)
                        .padding()
                        .background(viewModel.exchange.buttonColor)
                        .clipShape(Circle())
                }
            })
        }
    }
}


#Preview {
    ContentView()
}
