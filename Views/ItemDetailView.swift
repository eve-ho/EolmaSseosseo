

import SwiftUI

struct ItemDetailView: View {
    
    @EnvironmentObject var collectionVM: CollectionViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let item: CollectionItem
    
    @State private var showEditView = false
    @State private var showDeleteAlert = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // MARK: - 이미지
                if let data = item.imageData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 280)
                        .clipped()
                } else {
                    RoundedRectangle(cornerRadius: 0)
                        .fill(item.category.color.opacity(0.2))
                        .frame(height: 280)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 52))
                                .foregroundColor(item.category.color.opacity(0.4))
                        )
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: - 카테고리 뱃지 + 이름
                    VStack(alignment: .leading, spacing: 8) {
                        Text(item.category.rawValue)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(item.category.color)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(item.category.color.opacity(0.15))
                            .cornerRadius(8)
                        
                        Text(item.name)
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                    Divider()
                    
                    // MARK: - 상세 정보
                    VStack(spacing: 14) {
                        DetailRow(
                            icon: "wonsign.circle.fill",
                            title: "구매가",
                            value: "\(formatPrice(item.price))원",
                            color: Color(hex: "#FF6B6B")
                        )
                        DetailRow(
                            icon: "calendar",
                            title: "구매일",
                            value: formatDate(item.date),
                            color: Color(hex: "#4ECDC4")
                        )
                        
                        if !item.memo.isEmpty {
                            DetailRow(
                                icon: "note.text",
                                title: "메모",
                                value: item.memo,
                                color: Color(hex: "#FFE66D")
                            )
                        }
                    }
                    
                    Divider()
                    
                    // MARK: - 삭제 버튼
                    Button {
                        showDeleteAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "trash.fill")
                            Text("컬렉션에서 삭제")
                                .fontWeight(.medium)
                        }
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.08))
                        .cornerRadius(14)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("편집") {
                    showEditView = true
                }
                .foregroundColor(Color(hex: "#FF6B6B"))
            }
        }
        .sheet(isPresented: $showEditView) {
            EditItemView(item: item)
        }
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("정말 삭제할까요?"),
                message: Text("'\(item.name)'을(를) 삭제하면 복구할 수 없어요."),
                primaryButton: .destructive(Text("삭제")) {
                    collectionVM.delete(item: item)
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel(Text("취소"))
            )
        }
    }
}

// MARK: - 상세 정보 행

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 28)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}
