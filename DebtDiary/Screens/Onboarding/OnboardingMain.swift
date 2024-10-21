import SwiftUI
import StoreKit

struct OnboardingMain: View {
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @EnvironmentObject var mainViewModel: MainViewModel
    
    var body: some View {
        switch onboardingViewModel.state {
        case .welcome:
            OnboardingTypeView(type: .welcome, action: {
                onboardingViewModel.state = .event
            })
            .onAppear {
                requestAction()
            }
        case .event:
            OnboardingTypeView(type: .event, action: {
                mainViewModel.setMain()
            })
        }
    }
    
    private func requestAction() {
        Task { @MainActor in
            if let scene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive })
                as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }
}

final class OnboardingViewModel: ObservableObject {
    @Published var state: Onboarding = .welcome
}

struct OnboardingTypeView: View {
    let type: Onboarding
    let action: () -> Void
    
    var body: some View {
        ZStack {
          
            if type == .welcome {
                Image("firstBack")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            } else {
                Image("secondBack")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }
            
            VStack {
                Spacer()
                
                Text(type.title)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                    .textCase(.uppercase)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer().frame(height: 20)
                
                Text(type.description)
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                
                Spacer().frame(height: 40)
                
                Button(action: {
                    action()
                }) {
                    Text("Continue")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .bold))
                        .frame(width: 243, height: 61)
                        .background(Color.green)
                        .cornerRadius(30)
                }
                
                Spacer().frame(height: 35)
                
               
                footer
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
    }
}

@ViewBuilder private var footer: some View {
    HStack {
        NavigationLink {
            PrivacyPolicyView()
        } label: {
            Text("Privacy Policy")
                .foregroundColor(.white)
                .underline()
        }
        
        Spacer().frame(width: 32)
        
        NavigationLink {
            TermsOfUseView()
        } label: {
            Text("Terms of use")
                .foregroundColor(.white)
                .underline()
        }
    }
    .frame(maxWidth: .infinity)
    .font(.footnote)
    .foregroundColor(.gray)
    .padding(.horizontal)
    .padding(.bottom)
}

struct OnboardingMain_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingMain()
            .environmentObject(MainViewModel())
    }
}
