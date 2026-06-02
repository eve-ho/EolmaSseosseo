

import SwiftUI

struct AddItemView: View {
    
    @EnvironmentObject var collectionVM: CollectionViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var category: Category = .figure
    @State private var price: String = ""
    @State private var date: Date = Date()
    @State private var memo: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // MARK: - 이미지 선택
                    Button {
                        showImagePicker = true
                    } label: {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        } else {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(hex: "#F0F0F0"))
                                .frame(height: 200)
                                .overlay(
                                    VStack(spacing: 8) {
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 32))
                                            .foregroundColor(.secondary.opacity(0.5))
                                        Text("사진 추가")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                )
                        }
                    }
                    .padding(.horizontal)
                    
                    // MARK: - 입력 폼
                    VStack(spacing: 16) {
                        
                        // 이름
                        FormField(title: "아이템 이름") {
                            TextField("예) 카나페 피규어 1탄", text: $name)
                                .font(.subheadline)
                        }
                        
                        // 카테고리
                        FormField(title: "카테고리") {
                            Picker("카테고리", selection: $category) {
                                ForEach(Category.allCases, id: \.self) { cat in
                                    Text(cat.rawValue).tag(cat)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .font(.subheadline)
                        }
                        
                        // 가격
                        FormField(title: "구매가 (원)") {
                            TextField("예) 35000", text: $price)
                                .keyboardType(.numberPad)
                                .font(.subheadline)
                        }
                        
                        // 날짜
                        FormField(title: "구매일") {
                            DatePicker(
                                "",
                                selection: $date,
                                displayedComponents: .date
                            )
                            .labelsHidden()
                        }
                        
                        // 메모
                        FormField(title: "메모") {
                            TextField("간단한 메모를 남겨보세요", text: $memo)
                                .font(.subheadline)
                        }
                    }
                    .padding(.horizontal)
                    
                    // MARK: - 추가 버튼
                    Button {
                        saveItem()
                    } label: {
                        Text("컬렉션에 추가하기")
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
            .navigationTitle("아이템 추가")
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
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("입력 오류"),
                    message: Text("이름과 가격을 올바르게 입력해주세요."),
                    dismissButton: .default(Text("확인"))
                )
            }
        }
    }
    
    // MARK: - 유효성 검사
    
    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        Int(price) != nil
    }
    
    // MARK: - 저장
    
    func saveItem() {
        guard let priceInt = Int(price) else {
            showAlert = true
            return
        }
        
        let item = CollectionItem(
            name: name.trimmingCharacters(in: .whitespaces),
            category: category,
            price: priceInt,
            date: date,
            memo: memo,
            imageData: selectedImage?.jpegData(compressionQuality: 0.7)
        )
        
        collectionVM.add(item)
        
        // 햅틱 피드백
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - 폼 필드 래퍼

struct FormField<Content: View>: View {
    let title: String
    let content: () -> Content
    
    init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            content()
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(12)
        }
    }
}
