//
//  FavoritesListView.swift
//  MarshallTest
//
//  Created by Pontus Croneld on 2024-09-17.
//

import SwiftUI

struct FavoritesListView: View {
    @Environment(\.dismiss) var dismiss
    @State var models: [CryptoCurrencyModel]
    let exchange: CurrentCurrency
    let updateFavorites: (CryptoCurrencyModel) -> ()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(Array(models.enumerated()), id: \.offset) { index, item in
                    FavoritesListCell(model: item, exchange: exchange, isDarkCell: index % 2 == 0, didPressRemove: { removeFavorite(index) })
                }
            }
        }
    }
    
    private func removeFavorite(_ index: Int) {
        updateFavorites(models[index])
        models.remove(at: index)
        if models.isEmpty {
            dismiss()
        }
    }
}

#Preview {
    NavigationStack {
        FavoritesListView(models: [.placeholder, .placeholder, .placeholder], exchange: .init(currency: .usd, exchangeRate: 1.0), updateFavorites: { _ in })
    }
}
