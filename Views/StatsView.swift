

import SwiftUI

struct StatsView: View {
    
    @EnvironmentObject var collectionVM: CollectionViewModel
    @EnvironmentObject var statsVM: StatsViewModel
    
    @State private var showAddSale = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // MARK: - 총 구매액 / 총 판매액 카드
                    HStack(spacing: 16) {
                        SummaryCard(
                            title: "총 구매액",
                            value: "\(formatPrice(collectionVM.totalSpent))원",
                            color: Color(hex: "#FF6B6B")
                        )
                        SummaryCard(
                            title: "총 판매액",
                            value: "\(formatPrice(statsVM.totalSaleAmount))원",
                            color: Color(hex: "#4ECDC4")
                        )
                    }
                    .padding(.horizontal)
                    
                    // MARK: - 순지출 카드
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("실제 순지출")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("\(formatPrice(statsVM.netSpent(totalBought: collectionVM.totalSpent)))원")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color(hex: "#FF6B6B"))
                        }
                        Spacer()
                        Image(systemName: "arrow.left.arrow.right.circle.fill")
                            .font(.system(size: 44))
                            .foregroundColor(Color(hex: "#4ECDC4").opacity(0.3))
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                    .padding(.horizontal)
                    
                    // MARK: - 카테고리별 지출 비율
                    VStack(alignment: .leading, spacing: 14) {
                        Text("카테고리별 지출")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        let ratios = statsVM.categoryRatios(from: collectionVM.items)
                        
                        if ratios.isEmpty {
                            EmptyStateSmall(message: "아직 지출 데이터가 없어요")
                        } else {
                            VStack(spacing: 12) {
                                ForEach(ratios, id: \.category) { data in
                                    CategoryBar(
                                        category: data.category,
                                        ratio: data.ratio,
                                        amount: collectionVM.totalSpent(for: data.category)
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // MARK: - 월별 지출 바 차트
                    VStack(alignment: .leading, spacing: 14) {
                        Text("월별 지출")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        let monthly = collectionVM.monthlySpending()
                        let maxVal  = monthly.map { $0.total }.max() ?? 1
                        
                        VStack(spacing: 0) {
                            HStack(alignment: .bottom, spacing: 8) {
                                ForEach(monthly, id: \.label) { data in
                                    MonthlyBar(
                                        label: data.label,
                                        total: data.total,
                                        maxTotal: maxVal
                                    )
                                }
                            }
                            .frame(height: 180)
                            .padding()
                        }
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                        .padding(.horizontal)
                    }
                    
                    // MARK: - 판매 기록
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text("판매 기록")
                                .font(.headline)
                            Spacer()
                            Button {
                                showAddSale = true
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(Color(hex: "#FF6B6B"))
                            }
                        }
                        .padding(.horizontal)
                        
                        if statsVM.saleRecords.isEmpty {
                            EmptyStateSmall(message: "판매 기록이 없어요")
                        } else {
                            VStack(spacing: 10) {
                                ForEach(statsVM.saleRecords) { record in
                                    SaleRecordRow(record: record)
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
            .navigationTitle("지출 통계")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showAddSale) {
                AddSaleView()
            }
        }
    }
}

// MARK: - 카테고리 바

struct CategoryBar: View {
    let category: Category
    let ratio: Double
    let amount: Int
    
    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text(category.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
                Text("\(formatPrice(amount))원")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(String(format: "%.1f%%", ratio * 100))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(category.color)
                    .frame(width: 48, alignment: .trailing)
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(category.color.opacity(0.15))
                        .frame(height: 10)
                    RoundedRectangle(cornerRadius: 6)
                        .fill(category.color)
                        .frame(width: geo.size.width * CGFloat(ratio), height: 10)
                }
            }
            .frame(height: 10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 1)
    }
}

// MARK: - 월별 바

struct MonthlyBar: View {
    let label: String
    let total: Int
    let maxTotal: Int
    
    var ratio: CGFloat {
        guard maxTotal > 0 else { return 0 }
        return CGFloat(total) / CGFloat(maxTotal)
    }
    
    var body: some View {
        VStack(spacing: 4) {
            if total > 0 {
                Text("\(total / 10000)만")
                    .font(.system(size: 9))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(hex: "#FF6B6B").opacity(0.8))
                .frame(height: total > 0 ? max(ratio * 120, 8) : 4)
            
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - 판매 기록 행

struct SaleRecordRow: View {
    
    @EnvironmentObject var statsVM: StatsViewModel
    let record: SaleRecord
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(record.itemName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(formatDate(record.date))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("+\(formatPrice(record.salePrice))원")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "#4ECDC4"))
            
            Button {
                statsVM.deleteSaleRecord(record)
            } label: {
                Image(systemName: "trash")
                    .font(.system(size: 14))
                    .foregroundColor(.red.opacity(0.6))
            }
            .padding(.leading, 8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 1)
    }
}
