

import SwiftUI
import StoreKit

struct SettingsView: View {
    
    @ObservedObject private var viewModel = SettingsViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
        ScrollView {
            HStack {
                
                Text("Settings")
                    .foregroundStyle(.white)
                    .font(.system(size: 24, weight: .semibold))
                Spacer()
            }
            .padding(.horizontal, 16)
            VStack(alignment: .leading, spacing: 16) {
                ForEach(Array(zip(viewModel.settingItems.indices, viewModel.settingItems)),
                        id: \.1.self) { index, item in
                    makeView(for: item)
                    if index != viewModel.settingItems.count - 1 {
                        
                    }
                }
            }
            .padding()
        }
        .background(Color(.settingsMain))
        
           
        }

        .sheet(isPresented: $viewModel.showShareView) {
            ShareView(activityItems: ["https://apps.apple.com/app/id6621265063"])
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.fetchModels()
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
    
    private func sendEmail() {
        if let url = URL(string: "mailto:mdvslsgsuz@icloud.com") {
            UIApplication.shared.open(url)
        }
    }
    
    @ViewBuilder
    private func makeView(for item: SettingType) -> some View {
        switch item {
        case .helpSupport:
            makeButton(title: item.title,
                       image: item.image) {
                sendEmail()
            }
        case .rate:
            makeButton(title: item.title,
                       image: item.image) {
                requestAction()
            }
        case .share:
            makeButton(title: item.title,
                       image: item.image) {
                viewModel.showShareView.toggle()
            }
        case .privacyPolicy:
            makeNavigationLink(title: item.title,
                               image: item.image,
                               viewToOpen: PrivacyPolicyView())
        case .termOfUse:
            makeNavigationLink(title: item.title,
                               image: item.image,
                               viewToOpen: TermsOfUseView())
        }
    }
    
    private func makeButton(title: String,
                            image: ImageResource,
                            action: @escaping () -> ()) -> some View {
        Button {
            action()
        } label: {
            makeLabel(name: title, image: image)
        }
        
    }
    
    private func makeNavigationLink(title: String,
                                    image: ImageResource,
                                    viewToOpen: some View) -> some View {
        NavigationLink {
            viewToOpen
        } label: {
            makeLabel(name: title, image: image)
        }
       
    }
    
    private func makeLabel(name: String, image: ImageResource) -> some View {
        HStack {
            Image(image)
                .renderingMode(.template)
                .foregroundStyle(.settingsIcons)
            
            
            Text(name)
                .font(.headline)
                .foregroundStyle(.white)
            
            Spacer()
            
            Image(.settingsRight)
                .renderingMode(.template)
                .foregroundStyle(.settingsIcons)
        }
        .padding()
        .background(.settingsCard)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
    }
    
}

