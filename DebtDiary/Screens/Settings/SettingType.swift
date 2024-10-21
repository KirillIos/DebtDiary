
import SwiftUI

enum SettingType: String, CaseIterable, Identifiable, Hashable {
    var id: Self { self }
    
    case helpSupport
    case rate
    case share
    case privacyPolicy
    case termOfUse
}

extension SettingType {
    
    var image: ImageResource {
        switch self {
        case .helpSupport:
            return .settingsHelpSupport
        case .rate:
            return .settingsRate
        case .share:
            return .settingsShare
        case .privacyPolicy:
            return .settingsPrivacyPolicy
        case .termOfUse:
            return .settingsTermOfUse
        }
    }
    
    var title: String {
        switch self {
        case .helpSupport:
            return "Statemant"
        case .rate:
            return "Rate this app"
        case .share:
            return "Share this app"
        case .privacyPolicy:
            return "Privacy Policy"
        case .termOfUse:
            return "Terms of Use"
        }
    }
    
}
