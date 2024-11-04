import RealmSwift
import Combine

final class DebtListViewModel<T: Object>: ObservableObject {
    
    @Published var list: Results<T>?
    private var notificationToken: NotificationToken?
    
    init() {
           fetchData()
       }
    
    
    func fetchData() {
            guard let realm = try? Realm() else { return }
            
            let results = realm.objects(T.self)
            self.list = results
            
            notificationToken = results.observe { [weak self] changes in
                switch changes {
                case .initial:
                    self?.list = results
                case .update:
                    self?.list = results
                case .error(let error):
                    print("Ошибка при наблюдении за изменениями: \(error.localizedDescription)")
                }
            }
        }
        
    func delete(_ listObject: T) {
        guard let thawedListItem = listObject.thaw(), !thawedListItem.isInvalidated else { return }
        let realm = thawedListItem.realm
        try? realm?.write { [weak thawedListItem] in
            guard let thawedListItem else { return }
            realm?.delete(thawedListItem)
           
        }
        fetchData()
    }
    
    deinit {
           notificationToken?.invalidate()
       }
    
}
