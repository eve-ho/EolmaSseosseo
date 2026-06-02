

import SwiftUI

struct EditItemView: View {
    
    @EnvironmentObject var collectionVM: CollectionViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let item: CollectionItem
    
    @State private var name: String
    @State private var category: Category
    @State private var price: String
    @State private var date: Date
    @State private var memo: String
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    
    init(item: CollectionItem) {
        self.item = item
        _name     = State(initialValue: item.name)
        _category = State(initialValue: item.category)
        _price    = State(initialValue: String(item.price))
        _date     = State(initialValue: item.date)
        _memo     = State(initialValue: item.memo)
        
        if let data = item.imageData, let uiImage = UIImage(data: data) {
            _selectedImage = State(initialValue: uiImage)
        } else {
            _selectedImage = State(initialValue: nil)
        }
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
                                        Text("사진 변경")
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
                            TextField("예) 카나페 피규어 1탄", text: $name)
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
                        
                        FormField(title: "구매가 (원)") {
                            TextField("예) 35000", text: $price)
                                .keyboardType(.numberPad)
                                .font(.subheadline)
                        }
                        
                        FormField(title: "구매일") {
                            DatePicker(
                                "",
                                selection: $date,
                                displayedComponents: .date
                            )
                            .labelsHidden()
                        }
                        
                        FormField(title: "메모") {
                            TextField("간단한 메모를 남겨보세요", text: $memo)
                                .font(.subheadline)
                        }
                    }
                    .padding(.horizontal)
                    
                    // MARK: - 저장 버튼
                    Button {
                        saveEdit()
                    } label: {
                        Text("저장하기")
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
            .navigationTitle("편집")
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
    
    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        Int(price) != nil
    }
    
    func saveEdit() {
        guard let priceInt = Int(price) else { return }
        
        var updated = item
        updated.name      = name.trimmingCharacters(in: .whitespaces)
        updated.category  = category
        updated.price     = priceInt
        updated.date      = date
        updated.memo      = memo
        updated.imageData = selectedImage?.jpegData(compressionQuality: 0.7)
        
        collectionVM.update(updated)
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        presentationMode.wrappedValue.dismiss()
    }
}
