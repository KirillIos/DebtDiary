

import SwiftUI

final class SettingsViewModel: ObservableObject {
    
    @Published var settingItems = [SettingType]()
    @Published var showShareView = false
    
    func fetchModels() {
        var dictionary: NSDictionary?
        if let path = Bundle.main.path(forResource: "Settings", ofType: "plist") {
            dictionary = NSDictionary(contentsOfFile: path)
        }
        
        guard let dictionary else { return }
        guard let items = dictionary["items"] as? [String] else { return }
        settingItems = items.compactMap { item -> SettingType? in
            return SettingType(rawValue: item)
        }
    }
    
}
