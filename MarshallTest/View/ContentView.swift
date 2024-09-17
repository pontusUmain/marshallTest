//
//  ContentView.swift
//  MarshallTest
//
//  Created by Pontus Croneld on 2024-09-13.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    @State var presentFavorites: Bool = false
    
    var body: some View {
        Group {
            switch viewModel.viewState {
            case .loadingState:
                content(models: [])
            case .contentState(let currencies):
                NavigationStack {
                    ZStack(alignment: .bottomTrailing) {
                        content(models: currencies)
                        if !viewModel.favorites.isEmpty {
                            favoritesButton()
                        }
                    }
                    .sheet(isPresented: $presentFavorites, onDismiss: { viewModel.getFavorites() }) {
                        FavoritesListView(models: viewModel.favorites, exchange: viewModel.exchange[viewModel.currentExchangeIndex], updateFavorites: { model in viewModel.didChangeFavorite(model: model, isFavorite: !model.isFavorite) })
                    }
                }
            case .emptyState(let message):
                emptyState(message)
            }
        }
        .task {
            viewModel.getFavorites()
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
    
    private func favoritesButton() -> some View {
        Button(action: {
            presentFavorites = true
        }) {
            Image(systemName: "heart.fill")
                .accessibilityLabel(Constants.Accessibility.seeFavorites)
                .padding(25)
                .background(.white)
                .clipShape(Circle())
        }
        .padding(20)
    }
    
    private func content(models: [CryptoCurrencyModel]) -> some View {
        let currentCurrency = viewModel.exchange[viewModel.currentExchangeIndex]
        
        return ScrollView {
                LazyVStack(spacing: 0) {
                    if models.isEmpty {
                        ForEach(0...20, id: \.self) { index in
                            CryptoCurrencyListCell(style: .placeholder(darkCell: index % 2 == 0))
                        }
                    } else {
                        ForEach(Array(models.enumerated()), id: \.offset) { index, item in
                            NavigationLink(destination: DetailView(model: item, currentCurrency: currentCurrency, didChangeFavorite:
                                                                    { bool in viewModel.didChangeFavorite(model: item, isFavorite: bool)
                            }
                                                                  )) {
                                CryptoCurrencyListCell(style: .content(model: item, darkCell: index % 2 == 0, exchange: currentCurrency))
                            }
                        }
                    }
                }
            }
            .toolbar {
                if viewModel.exchange.count > 0 {
                    Button(action: {
                        viewModel.switchCurrency()
                    }) {
                        Text("\(Constants.Strings.switchButton) \( currentCurrency.currency.oppositeFlag)")
                    }
                }
            }
    }
}


#Preview {
    ContentView(viewModel: ViewModel())
}
