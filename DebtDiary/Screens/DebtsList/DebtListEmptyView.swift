import SwiftUI


struct DebtListEmptyView: View {
    var body: some View {
        ScrollView{
            VStack {
                Spacer()
                Image(.burn)
                    .resizable()
                   
                Text("No Debts recorded")
                    .foregroundStyle(Color(hex: "#828181"))
                    .font(.system(size: 16, weight: .semibold))
                   
                
                Spacer()
                
                
            }
            
        }
    }
}


