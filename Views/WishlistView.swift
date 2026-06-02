

import SwiftUI

struct WishlistView: View {
    
    @EnvironmentObject var wishlistVM: WishlistViewModel
    @EnvironmentObject var collectionVM: CollectionViewModel
    
    @State private var showAddWishlist = false
    @State private var showBoughtAlert = false
    @State private var selectedItem: WishlistItem? = nil
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // MARK: - 갖고싶다 목록
                    VStack(alignment: .leading, spacing: 12) {
                        Text("갖고싶다 🌟")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if wishlistVM.wantItems.isEmpty {
                            EmptyStateSmall(message: "위시리스트가 비어있어요")
                        } else {
                            VStack(spacing: 10) {
                                ForEach(wishlistVM.wantItems) { item in
                                    WishlistItemRow(
                                        item: item,
                                        onBought: {
                                            selectedItem = item
                                            showBoughtAlert = true
                                        },
                                        onDelete: {
                                            wishlistVM.delete(item: item)
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // MARK: - 구매완료 목록
                    if !wishlistVM.boughtItems.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("구매완료 ✅")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            VStack(spacing: 10) {
                                ForEach(wishlistVM.boughtItems) { item in
                                    WishlistItemRow(
                                        item: item,
                                        onBought: nil,
                                        onDelete: {
                                            wishlistVM.delete(item: item)
                                        }
                                    )
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
            .navigationTitle("위시리스트")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddWishlist = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(Color(hex: "#FF6B6B"))
                    }
                }
            }
            .sheet(isPresented: $showAddWishlist) {
                AddWishlistItemView()
            }
            .alert(isPresented: $showBoughtAlert) {
                Alert(
                    title: Text("구매완료로 이동할까요?"),
                    message: Text("컬렉션 탭으로 자동으로 추가돼요."),
                    primaryButton: .default(Text("컬렉션에 추가")) {
                        if let item = selectedItem {
                            let collectionItem = wishlistVM.markAsBought(item)
                            collectionVM.add(collectionItem)
                        }
                    },
                    secondaryButton: .cancel(Text("취소"))
                )
            }
        }
    }
}

// MARK: - 위시리스트 아이템 행

struct WishlistItemRow: View {
    let item: WishlistItem
    let onBought: (() -> Void)?
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            
            // 이미지 or 플레이스홀더
            if let data = item.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(item.category.color.opacity(0.2))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "star.fill")
                            .foregroundColor(item.category.color.opacity(0.5))
                    )
            }
            
            // 정보
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                Text(item.category.rawValue)
                    .font(.caption)
                    .foregroundColor(item.category.color)
                
                Text("목표가: \(formatPrice(item.targetPrice))원")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // 오른쪽 버튼 영역
            VStack(spacing: 8) {
                // 상태 뱃지
                Text(item.status.rawValue)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(item.status == .want ? Color(hex: "#FF6B6B") : Color(hex: "#4ECDC4"))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(
                        item.status == .want
                        ? Color(hex: "#FF6B6B").opacity(0.12)
                        : Color(hex: "#4ECDC4").opacity(0.12)
                    )
                    .cornerRadius(6)
                
                // 구매완료 버튼 (want 상태일 때만)
                if let onBought = onBought {
                    Button {
                        onBought()
                    } label: {
                        Text("구매완료")
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(hex: "#4ECDC4"))
                            .cornerRadius(8)
                    }
                }
                
                // 삭제 버튼
                Button {
                    onDelete()
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 13))
                        .foregroundColor(.red.opacity(0.6))
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 1)
        .opacity(item.status == .bought ? 0.6 : 1.0)
    }
}
