

import SwiftUI

@main
struct EolmaSseosseoApp: App {
    
    @StateObject private var collectionVM = CollectionViewModel()
    @StateObject private var wishlistVM   = WishlistViewModel()
    @StateObject private var statsVM      = StatsViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(collectionVM)
                .environmentObject(wishlistVM)
                .environmentObject(statsVM)
        }
    }
}
