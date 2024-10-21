import Foundation
import SwiftUI
import UIKit


final class MainViewModel: ObservableObject {
    enum GlobalState {
        case onboarding, main
    }
    @Published private(set) var globalState: GlobalState = StorageManager.shared.onboardingAlreadyPresented ? .main : .onboarding
    
    func setMain() {
        globalState = .main
        StorageManager.shared.onboardingToggle()
    }
}


struct StorageManager {
    static let shared = StorageManager()
    private init() {}
    
    @AppStorage("ONBOARDING_PRESENTED") private(set) var onboardingAlreadyPresented = false
    
    func onboardingToggle() {
        onboardingAlreadyPresented.toggle()
    }
}
