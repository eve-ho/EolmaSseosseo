

import SwiftUI

struct CollectionView: View {
    
    @EnvironmentObject var collectionVM: CollectionViewModel
    @State private var showAddItem = false
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                // MARK: - 카테고리 필터
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        FilterChip(
                            title: "전체",
                            isSelected: collectionVM.selectedCategory == nil,
                            color: Color(hex: "#FF6B6B")
                        ) {
                            collectionVM.selectedCategory = nil
                        }
                        
                        ForEach(Category.allCases, id: \.self) { category in
                            FilterChip(
                                title: category.rawValue,
                                isSelected: collectionVM.selectedCategory == category,
                                color: category.color
                            ) {
                                collectionVM.selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                }
                .background(Color.white)
                
                // MARK: - 그리드
                if collectionVM.filteredItems.isEmpty {
                    EmptyStateView(message: "아직 컬렉션이 없어요\n아이템을 추가해보세요!")
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(collectionVM.filteredItems) { item in
                                NavigationLink(destination: ItemDetailView(item: item)) {
                                    CollectionItemCard(item: item)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(16)
                    }
                    .background(Color(hex: "#F7F7F7"))
                }
            }
            .navigationTitle("컬렉션")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddItem = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(Color(hex: "#FF6B6B"))
                    }
                }
            }
            .sheet(isPresented: $showAddItem) {
                AddItemView()
            }
        }
    }
}

// MARK: - 필터 칩

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? .white : color)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(isSelected ? color : color.opacity(0.12))
                .cornerRadius(20)
        }
    }
}

// MARK: - 컬렉션 아이템 카드

struct CollectionItemCard: View {
    let item: CollectionItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            // 이미지
            if let data = item.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 130)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(item.category.color.opacity(0.2))
                    .frame(height: 130)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 30))
                            .foregroundColor(item.category.color.opacity(0.5))
                    )
            }
            
            // 카테고리 뱃지
            Text(item.category.rawValue)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(item.category.color)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(item.category.color.opacity(0.15))
                .cornerRadius(6)
            
            // 이름
            Text(item.name)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .lineLimit(1)
            
            // 가격 + 날짜
            Text("\(formatPrice(item.price))원")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "#FF6B6B"))
            
            Text(formatDate(item.date))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

// MARK: - 빈 상태 (대형)

struct EmptyStateView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "tray.fill")
                .font(.system(size: 52))
                .foregroundColor(.secondary.opacity(0.3))
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color(hex: "#F7F7F7"))
    }
}
