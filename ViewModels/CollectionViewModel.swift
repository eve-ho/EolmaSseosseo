

import Foundation
import SwiftUI

class CollectionViewModel: ObservableObject {
    
    @Published var items: [CollectionItem] = []
    @Published var selectedCategory: Category? = nil
    
    private let manager = UserDefaultsManager.shared
    
    init() {
        load()
    }
    
    // MARK: - Filtered
    
    var filteredItems: [CollectionItem] {
        guard let category = selectedCategory else { return items }
        return items.filter { $0.category == category }
    }
    
    // MARK: - CRUD
    
    func add(_ item: CollectionItem) {
        items.append(item)
        save()
    }
    
    func update(_ item: CollectionItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
            save()
        }
    }
    
    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }
    
    func delete(item: CollectionItem) {
        items.removeAll { $0.id == item.id }
        save()
    }
    
    // MARK: - Save / Load
    
    func save() {
        manager.saveCollection(items)
    }
    
    func load() {
        items = manager.loadCollection()
    }
    
    // MARK: - Stats 용 계산
    
    var totalSpent: Int {
        items.reduce(0) { $0 + $1.price }
    }
    
    var totalCount: Int {
        items.count
    }
    
    // 카테고리별 합계 (StatsView에서 사용)
    func totalSpent(for category: Category) -> Int {
        items.filter { $0.category == category }
             .reduce(0) { $0 + $1.price }
    }
    
    // 월별 합계 (StatsView 바 차트에서 사용)
    // 반환: [(월 이름, 합계)] 최근 6개월
    func monthlySpending() -> [(label: String, total: Int)] {
        let calendar = Calendar.current
        let now = Date()
        
        return (0..<6).reversed().map { offset -> (String, Int) in
            guard let targetMonth = calendar.date(byAdding: .month, value: -offset, to: now) else {
                return ("", 0)
            }
            let comps = calendar.dateComponents([.year, .month], from: targetMonth)
            let total = items.filter {
                let c = calendar.dateComponents([.year, .month], from: $0.date)
                return c.year == comps.year && c.month == comps.month
            }.reduce(0) { $0 + $1.price }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "M월"
            return (formatter.string(from: targetMonth), total)
        }
    }
    
    // 최근 추가 아이템 (HomeView용)
    func recentItems(count: Int = 5) -> [CollectionItem] {
        items.sorted { $0.date > $1.date }
             .prefix(count)
             .map { $0 }
    }
    
    // 이달 지출 (HomeView용)
    var thisMonthSpent: Int {
        let calendar = Calendar.current
        let now = Date()
        return items.filter {
            calendar.isDate($0.date, equalTo: now, toGranularity: .month)
        }.reduce(0) { $0 + $1.price }
    }
}
