import SwiftUI

struct TabBar: View {
    
    enum ScreenType: String, CaseIterable {
        case main = "Main"
        case settings = "Setting"
    }
    
    @State private var screen = ScreenType.main
    
    var body: some View {
        VStack(spacing: 0) {
            switch screen {
            case .main:
                DebtsListView()
            case .settings:
                SettingsView()
            }
            
            HStack(spacing: 16) {
                ForEach(ScreenType.allCases, id: \.self) { type in
                    Button(action: {
                        screen = type
                    }) {
                        ZStack {
                            Circle()
                                .fill(screen == type ? Color(hex: "#34C759") : Color(hex: "#F5F5F5"))
                                .frame(width: 60, height: 60)

                            Image(type.rawValue)
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .foregroundColor(screen == type ? Color.white : Color(hex: "#34C759"))
                        }
                    }
                }
            }
            .frame(height: 80)
            .padding(.horizontal, 16)
            .background(Color(hex: "#1C1C1E"))
            .clipShape(Capsule())
            .padding(.bottom, 20)
        }
        .background(Color.settingsMain)
        .ignoresSafeArea(.all)
    }
}


