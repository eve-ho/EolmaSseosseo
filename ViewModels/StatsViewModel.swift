

import Foundation

class StatsViewModel: ObservableObject {
    
    @Published var saleRecords: [SaleRecord] = []
    
    private let manager = UserDefaultsManager.shared
    
    init() {
        load()
    }
    
    // MARK: - 판매 기록 CRUD
    
    func addSaleRecord(_ record: SaleRecord) {
        saleRecords.append(record)
        save()
    }
    
    func deleteSaleRecord(at offsets: IndexSet) {
        saleRecords.remove(atOffsets: offsets)
        save()
    }
    
    func deleteSaleRecord(_ record: SaleRecord) {
        saleRecords.removeAll { $0.id == record.id }
        save()
    }
    
    // MARK: - 통계 계산
    
    // 총 판매액
    var totalSaleAmount: Int {
        saleRecords.reduce(0) { $0 + $1.salePrice }
    }
    
    // 순지출 = 총 구매액 - 총 판매액
    func netSpent(totalBought: Int) -> Int {
        totalBought - totalSaleAmount
    }
    
    // 카테고리별 비율 (StatsView 바에서 사용)
    // 반환: [(카테고리, 비율 0.0~1.0)]
    func categoryRatios(from items: [CollectionItem]) -> [(category: Category, ratio: Double)] {
        let total = items.reduce(0) { $0 + $1.price }
        guard total > 0 else { return [] }
        
        return Category.allCases.compactMap { category in
            let categoryTotal = items.filter { $0.category == category }
                                     .reduce(0) { $0 + $1.price }
            guard categoryTotal > 0 else { return nil }
            return (category, Double(categoryTotal) / Double(total))
        }
    }
    
    // 월별 지출 (CollectionViewModel에서 받아서 사용)
    // 여기선 판매 기록 월별 집계만 담당
    func monthlySales() -> [(label: String, total: Int)] {
        let calendar = Calendar.current
        let now = Date()
        
        return (0..<6).reversed().map { offset -> (String, Int) in
            guard let targetMonth = calendar.date(byAdding: .month, value: -offset, to: now) else {
                return ("", 0)
            }
            let comps = calendar.dateComponents([.year, .month], from: targetMonth)
            let total = saleRecords.filter {
                let c = calendar.dateComponents([.year, .month], from: $0.date)
                return c.year == comps.year && c.month == comps.month
            }.reduce(0) { $0 + $1.salePrice }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "M월"
            return (formatter.string(from: targetMonth), total)
        }
    }
    
    // MARK: - Save / Load
    
    func save() {
        manager.saveSaleRecords(saleRecords)
    }
    
    func load() {
        saleRecords = manager.loadSaleRecords()
    }
}
