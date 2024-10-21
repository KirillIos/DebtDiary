import SwiftUI
import RealmSwift

struct DetailView: View {
    
    let record: Debt
    @Environment(\.presentationMode) var presentationMode

    let onDelete: () -> Void 
   
    
    var body: some View {
        VStack {
            Spacer().frame(height: getSafeAreaTopInset())
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {HStack {
                    Image(.arrowLeft)
                    Text("Debts")
                        .foregroundColor(.green)
                        .font(.system(size: 16, weight: .semibold))
                }
                   Spacer()
                }
               Spacer()

            }
            HStack {
                Spacer()
                Button {
                    deleteRecord()
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 32, height: 32)
                        
                        Image(.bin)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color(hex: "#34C759"))
                    }
                }
            }
            
            VStack(spacing: 10) {
                Text(record.debtName)
                    .foregroundStyle(.white)
                    .font(.system(size: 16, weight: .regular))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(record.amount)
                    .foregroundStyle(Color(hex: "#44A244"))
                    .font(.system(size: 16, weight: .regular))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(formattedDate(record.date))
                    .foregroundStyle(.white)
                    .font(.system(size: 16, weight: .regular))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer().frame(height: 10)
                Text(record.desc)
                    .foregroundStyle(.white)
                    .font(.system(size: 16, weight: .regular))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(.settingsCard)
            .cornerRadius(21)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .background(Color.settingsMain)
    }
    
    private func deleteRecord() {
        onDelete()
        presentationMode.wrappedValue.dismiss()
        }
    
    private func formattedDate(_ date: Date?) -> String {
           guard let date = date else {
               return "No deadline"
           }
           let formatter = DateFormatter()
           formatter.dateFormat = "dd/MM/yyyy"
           return formatter.string(from: date)
       }
    
    private func getSafeAreaTopInset() -> CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return 0
        }
        return window.safeAreaInsets.top
    }
    
    private func getSafeAreaBotInset() -> CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return 0
        }
        return window.safeAreaInsets.bottom
    }
}


