import RealmSwift
import UIKit

final class Debt: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var debtName: String
    @Persisted var amount: String
    @Persisted var desc: String
    @Persisted var date: Date
}

