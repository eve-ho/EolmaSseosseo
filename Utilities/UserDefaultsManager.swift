

import Foundation

class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    private init() {}
    
    private let collectionKey = "collection_items"
    private let wishlistKey   = "wishlist_items"
    private let saleKey       = "sale_records"
    
    // MARK: - CollectionItem
    
    func saveCollection(_ items: [CollectionItem]) {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: collectionKey)
        }
    }
    
    func loadCollection() -> [CollectionItem] {
        guard let data = UserDefaults.standard.data(forKey: collectionKey),
              let items = try? JSONDecoder().decode([CollectionItem].self, from: data)
        else { return [] }
        return items
    }
    
    // MARK: - WishlistItem
    
    func saveWishlist(_ items: [WishlistItem]) {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: wishlistKey)
        }
    }
    
    func loadWishlist() -> [WishlistItem] {
        guard let data = UserDefaults.standard.data(forKey: wishlistKey),
              let items = try? JSONDecoder().decode([WishlistItem].self, from: data)
        else { return [] }
        return items
    }
    
    // MARK: - SaleRecord
    
    func saveSaleRecords(_ records: [SaleRecord]) {
        if let encoded = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(encoded, forKey: saleKey)
        }
    }
    
    func loadSaleRecords() -> [SaleRecord] {
        guard let data = UserDefaults.standard.data(forKey: saleKey),
              let records = try? JSONDecoder().decode([SaleRecord].self, from: data)
        else { return [] }
        return records
    }
}
