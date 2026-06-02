

import Foundation

func formatPrice(_ value: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
}

func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM.dd"
    return formatter.string(from: date)
}

func formatMonthDay(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "M월 d일"
    return formatter.string(from: date)
}
