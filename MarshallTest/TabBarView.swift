//
//  TabBarView.swift
//  MarshallTest
//
//  Created by Pontus Croneld on 2024-09-13.
//

import SwiftUI

struct TabBarView: View {
    
    
    var body: some View {
        TabView() {
            Text("View 1")
                .tabItem {
                    Image(systemName: "house")
                }
            Text("View 2")
                .tabItem {
                    Image(systemName: "figure.walk")
                }
            Text("View 3")
                .tabItem {
                    Image(systemName: "cloud")
                }
        }
        
    }
}

#Preview {
    TabBarView()
}
