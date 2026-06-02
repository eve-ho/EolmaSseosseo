

import Foundation

enum WishlistStatus: String, Codable {
    case want = "갖고싶다"
    case bought = "구매완료"
}

struct WishlistItem: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var category: Category
    var targetPrice: Int
    var memo: String
    var status: WishlistStatus = .want
    var imageData: Data?
}
