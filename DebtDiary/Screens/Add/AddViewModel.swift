import RealmSwift
import Combine
import Foundation

final class AddViewModel: ObservableObject {

    @Published var isContinueDisabled = true
    
    @Published var debtName = ""
    @Published var amount = ""
    @Published var date: Date? = nil 
    @Published var desc = ""
    
   
    
    private var anyCancellables = Set<AnyCancellable>()
    
    init() {
        $debtName
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateButtonAvailability()
            }
            .store(in: &anyCancellables)
        $amount
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateButtonAvailability()
            }
            .store(in: &anyCancellables)
        $date
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateButtonAvailability()
            }
            .store(in: &anyCancellables)
        $desc
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateButtonAvailability()
            }
            .store(in: &anyCancellables)
    }
    
    func saveModel() {
        guard let realm = try? Realm() else { return }
        let model = Debt()
        model.debtName = debtName
        model.amount = amount
        model.desc = desc
        model.date = date ?? Date.now
        try? realm.write {
            realm.add(model)
        }
    }
    
    private func updateButtonAvailability() {
        isContinueDisabled = debtName.isEmpty
        || amount.isEmpty
        || date == nil
    }
    
}
