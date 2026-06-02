

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var collectionVM: CollectionViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // MARK: - 상단 요약 카드
                    HStack(spacing: 16) {
                        SummaryCard(
                            title: "총 수집 수",
                            value: "\(collectionVM.totalCount)개",
                            color: Color(hex: "#FF6B6B")
                        )
                        SummaryCard(
                            title: "총 지출액",
                            value: "\(formatPrice(collectionVM.totalSpent))원",
                            color: Color(hex: "#4ECDC4")
                        )
                    }
                    .padding(.horizontal)
                    
                    // MARK: - 이달 지출
                    VStack(alignment: .leading, spacing: 10) {
                        Text("이달 지출")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("이번 달 소비")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("\(formatPrice(collectionVM.thisMonthSpent))원")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(hex: "#FF6B6B"))
                            }
                            Spacer()
                            Image(systemName: "calendar.circle.fill")
                                .font(.system(size: 44))
                                .foregroundColor(Color(hex: "#FF6B6B").opacity(0.3))
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                        .padding(.horizontal)
                    }
                    
                    // MARK: - 최근 구매
                    VStack(alignment: .leading, spacing: 10) {
                        Text("최근 구매")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if collectionVM.recentItems().isEmpty {
                            EmptyStateSmall(message: "아직 추가된 컬렉션이 없어요")
                        } else {
                            VStack(spacing: 10) {
                                ForEach(collectionVM.recentItems()) { item in
                                    RecentItemRow(item: item)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding(.top)
            }
            .background(Color(hex: "#F7F7F7").ignoresSafeArea())
            .navigationTitle("얼마썼어!? 🎁")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - 요약 카드

struct SummaryCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// MARK: - 최근 아이템 행

struct RecentItemRow: View {
    let item: CollectionItem
    
    var body: some View {
        HStack(spacing: 12) {
            if let data = item.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 52, height: 52)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(item.category.color.opacity(0.25))
                    .frame(width: 52, height: 52)
                    .overlay(
                        Text(item.category.rawValue.prefix(1))
                            .font(.headline)
                            .foregroundColor(item.category.color)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(item.category.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(formatPrice(item.price))원")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#FF6B6B"))
                Text(formatMonthDay(item.date))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 1)
    }
}

// MARK: - 빈 상태 (소형)

struct EmptyStateSmall: View {
    let message: String
    
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 6) {
                Image(systemName: "tray")
                    .font(.system(size: 28))
                    .foregroundColor(.secondary.opacity(0.5))
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 24)
            Spacer()
        }
        .background(Color.white)
        .cornerRadius(14)
        .padding(.horizontal)
    }
}
