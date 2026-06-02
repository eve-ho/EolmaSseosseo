

import Foundation

struct CollectionItem: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var category: Category
    var price: Int
    var date: Date
    var memo: String
    var imageData: Data?
}
