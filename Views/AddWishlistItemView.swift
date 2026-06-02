

import SwiftUI

struct AddWishlistItemView: View {
    
    @EnvironmentObject var wishlistVM: WishlistViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var category: Category = .figure
    @State private var targetPrice: String = ""
    @State private var memo: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    
    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        Int(targetPrice) != nil
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // MARK: - 이미지
                    Button {
                        showImagePicker = true
                    } label: {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 180)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        } else {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(hex: "#F0F0F0"))
                                .frame(height: 180)
                                .overlay(
                                    VStack(spacing: 8) {
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 32))
                                            .foregroundColor(.secondary.opacity(0.5))
                                        Text("사진 추가 (선택)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                )
                        }
                    }
                    .padding(.horizontal)
                    
                    // MARK: - 입력 폼
                    VStack(spacing: 16) {
                        
                        FormField(title: "아이템 이름") {
                            TextField("예) 라부부 핑크 에디션", text: $name)
                                .font(.subheadline)
                        }
                        
                        FormField(title: "카테고리") {
                            Picker("카테고리", selection: $category) {
                                ForEach(Category.allCases, id: \.self) { cat in
                                    Text(cat.rawValue).tag(cat)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                        
                        FormField(title: "목표 가격 (원)") {
                            TextField("예) 50000", text: $targetPrice)
                                .keyboardType(.numberPad)
                                .font(.subheadline)
                        }
                        
                        FormField(title: "메모") {
                            TextField("어디서 살지, 언제 나오는지 등", text: $memo)
                                .font(.subheadline)
                        }
                    }
                    .padding(.horizontal)
                    
                    // MARK: - 추가 버튼
                    Button {
                        saveItem()
                    } label: {
                        Text("위시리스트에 추가")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isValid ? Color(hex: "#FF6B6B") : Color.gray.opacity(0.4))
                            .cornerRadius(16)
                    }
                    .disabled(!isValid)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .padding(.top)
            }
            .background(Color(hex: "#F7F7F7").ignoresSafeArea())
            .navigationTitle("위시리스트 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(Color(hex: "#FF6B6B"))
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }
    
    func saveItem() {
        guard let price = Int(targetPrice) else { return }
        
        let item = WishlistItem(
            name: name.trimmingCharacters(in: .whitespaces),
            category: category,
            targetPrice: price,
            memo: memo,
            imageData: selectedImage?.jpegData(compressionQuality: 0.7)
        )
        
        wishlistVM.add(item)
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        presentationMode.wrappedValue.dismiss()
    }
}
