

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("홈")
                }
            
            CollectionView()
                .tabItem {
                    Image(systemName: "gift.fill")
                    Text("컬렉션")
                }
            
            StatsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("지출 통계")
                }
            
            WishlistView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("위시리스트")
                }
        }
        .accentColor(Color(hex: "#FF6B6B"))
    }
}
