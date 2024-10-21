
import Foundation

enum Onboarding: String, CaseIterable, Identifiable {
    var id: Self { self }
    case welcome
    case event
    var image: String {
        switch self {
        case .welcome:
            return "firstImage"
        case .event:
            return "secondImage"
        }
    }
    
    var title: String {
        switch self {
        case .welcome:
            return "Stay on Top of Your Debts"
        case .event:
            return "Never Miss a Payment"
        }
    }
    
    var description: String {
        switch self {
        case .welcome:
            return "Track and organize all your loans and balances. Get a clear view of your obligations."
        case .event:
            return "Set reminders and track progress. Manage your debts with ease."
        }
    }
        
    func next() -> Onboarding? {
        switch self {
        case .welcome:
            return .event
        case .event:
            return nil
        }
    }
}
