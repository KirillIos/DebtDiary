import SwiftUI

struct DebtsListView: View {
    
    @ObservedObject private var viewModel = DebtListViewModel<Debt>()
    @State private var isAddViewPresented = false
    @State private var isDetailViewPresented = false
    @State private var selectedDebt: Debt? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Debts")
                        .foregroundStyle(.white)
                        .font(.system(size: 16, weight: .semibold))
                        .frame(alignment: .leading)
                    Spacer()
                }
                
                Spacer().frame(height: 54)
                
                if let list = $viewModel.list.wrappedValue, !list.isEmpty {
                    ScrollView {
                            ForEach(list) { item in
                                Button {
                                    selectedDebt = item
                                    isDetailViewPresented = true
                                } label: {
                                    HStack {
                                        VStack(spacing: 6) {
                                            Text(item.debtName)
                                                .font(.system(size: 20))
                                                .foregroundStyle(.white)
                                            Text(item.amount)
                                                .foregroundStyle(.green)
                                                .font(.system(size: 20))
                                        }
                                        Spacer()
                                        Image(.settingsRight)
                                            .renderingMode(.template)
                                            .foregroundStyle(.white)
                                    }
                                    .padding(.vertical, 16)
                                    .padding(.horizontal, 12)
                                    .background(Color.settingsCard)
                                    .cornerRadius(21)
                                }
                                
                                
                            }
                            
                    }
                    
                } else {
                    DebtListEmptyView()
                }
                Button {
                    isAddViewPresented.toggle()
                } label: {
                    Text("Add")
                        .foregroundStyle(.white)
                        .font(.system(size: 20, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(.settingsIcons)
                        .cornerRadius(13)
                    
                }
                .fullScreenCover(isPresented: $isAddViewPresented) {
                    AddView(isPresented: $isAddViewPresented, viewModel: AddViewModel())
                }
                .padding(.bottom, 32)
                
                Spacer()
                
            }
            .padding(.horizontal, 16)
            .background(.settingsMain)
            .fullScreenCover(item: $selectedDebt) { debt in
                DetailView(record: debt) {
                    viewModel.delete(debt)
                    selectedDebt = nil
                }
                
            }
        }
    }
    
}
