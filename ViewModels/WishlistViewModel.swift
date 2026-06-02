

import Foundation

class WishlistViewModel: ObservableObject {
    
    @Published var items: [WishlistItem] = []
    
    private let manager = UserDefaultsManager.shared
    
    init() {
        load()
    }
    
    // MARK: - CRUD
    
    func add(_ item: WishlistItem) {
        items.append(item)
        save()
    }
    
    func update(_ item: WishlistItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
            save()
        }
    }
    
    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }
    
    func delete(item: WishlistItem) {
        items.removeAll { $0.id == item.id }
        save()
    }
    
    // MARK: - 구매완료 → 컬렉션 이동
    // 반환값을 CollectionViewModel에 전달해서 add() 호출
    
    func markAsBought(_ item: WishlistItem) -> CollectionItem {
        // 위시리스트에서 상태 변경
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].status = .bought
            save()
        }
        
        // CollectionItem으로 변환해서 반환
        return CollectionItem(
            name: item.name,
            category: item.category,
            price: item.targetPrice,
            date: Date(),
            memo: item.memo,
            imageData: item.imageData
        )
    }
    
    // 구매완료 항목을 위시리스트에서 완전히 제거
    func removeBought(_ item: WishlistItem) {
        items.removeAll { $0.id == item.id }
        save()
    }
    
    // MARK: - 필터
    
    var wantItems: [WishlistItem] {
        items.filter { $0.status == .want }
    }
    
    var boughtItems: [WishlistItem] {
        items.filter { $0.status == .bought }
    }
    
    // MARK: - Save / Load
    
    func save() {
        manager.saveWishlist(items)
    }
    
    func load() {
        items = manager.loadWishlist()
    }
}
