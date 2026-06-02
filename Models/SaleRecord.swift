

import Foundation

struct SaleRecord: Identifiable, Codable {
    var id: UUID = UUID()
    var itemName: String
    var salePrice: Int
    var date: Date
}
