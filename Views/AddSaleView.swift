

import SwiftUI

struct AddSaleView: View {
    
    @EnvironmentObject var statsVM: StatsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var itemName: String = ""
    @State private var salePrice: String = ""
    @State private var date: Date = Date()
    
    var isValid: Bool {
        !itemName.trimmingCharacters(in: .whitespaces).isEmpty &&
        Int(salePrice) != nil
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    
                    FormField(title: "판매한 아이템 이름") {
                        TextField("예) 카나페 피규어 1탄", text: $itemName)
                            .font(.subheadline)
                    }
                    
                    FormField(title: "판매가 (원)") {
                        TextField("예) 25000", text: $salePrice)
                            .keyboardType(.numberPad)
                            .font(.subheadline)
                    }
                    
                    FormField(title: "판매일") {
                        DatePicker(
                            "",
                            selection: $date,
                            displayedComponents: .date
                        )
                        .labelsHidden()
                    }
                    
                    Button {
                        saveRecord()
                    } label: {
                        Text("판매 기록 추가")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isValid ? Color(hex: "#4ECDC4") : Color.gray.opacity(0.4))
                            .cornerRadius(16)
                    }
                    .disabled(!isValid)
                    .padding(.top, 4)
                }
                .padding()
            }
            .background(Color(hex: "#F7F7F7").ignoresSafeArea())
            .navigationTitle("판매 기록 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(Color(hex: "#FF6B6B"))
                }
            }
        }
    }
    
    func saveRecord() {
        guard let price = Int(salePrice) else { return }
        
        let record = SaleRecord(
            itemName: itemName.trimmingCharacters(in: .whitespaces),
            salePrice: price,
            date: date
        )
        
        statsVM.addSaleRecord(record)
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        presentationMode.wrappedValue.dismiss()
    }
}
