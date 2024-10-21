
import SwiftUI

struct ContentView: View {
    @StateObject private var mainViewModel = MainViewModel()

    var body: some View {
        Group {
            switch mainViewModel.globalState {
            case .onboarding:
                OnboardingMain()
                    .environmentObject(mainViewModel)
            case .main:
                TabBar()
                   
            }
        }
    }
}

#Preview {
    ContentView()
}
