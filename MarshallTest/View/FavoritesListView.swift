//
//  FavoritesListView.swift
//  MarshallTest
//
//  Created by Pontus Croneld on 2024-09-17.
//

import SwiftUI

/// View to display list of cryptos marked as favorites
struct FavoritesListView: View {
    @Environment(\.dismiss) var dismiss
    @State var models: [CryptoCurrencyModel]
    let exchange: Currency
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
    
    /// User presses remove button on a list cell
    /// - Parameter index: Using the index to update the correct model. UpdateFavorites triggers a completion that handles the update in the UserDefaultsManager via the ViewModel. Models.remove handles the local view. If the models are empty the view should be dismissed as there are no favorite cryptos to show.
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
