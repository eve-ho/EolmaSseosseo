

import SwiftUI

enum Category: String, CaseIterable, Codable {
    case figure = "피규어"
    case keyring = "키링"
    case photocard = "포카"
    case goods = "굿즈"
    case lego = "레고"
    case etc = "기타"
    
    var color: Color {
        switch self {
        case .figure:    return Color(hex: "#FF6B6B")
        case .keyring:   return Color(hex: "#A78BFA")
        case .photocard: return Color(hex: "#FFE66D")
        case .goods:     return Color(hex: "#FFE66D")
        case .lego:      return Color(hex: "#4ECDC4")
        case .etc:       return Color.gray
        }
    }
}
