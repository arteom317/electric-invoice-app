import Foundation
import SwiftData

@Model
final class Client {
    var id: UUID
    var name: String
    var cui: String?
    var address: String
    var phone: String
    var dateCreated: Date
    
    init(id: UUID = UUID(), name: String, cui: String? = nil, address: String, phone: String, dateCreated: Date = Date()) {
        self.id = id
        self.name = name
        self.cui = cui
        self.address = address
        self.phone = phone
        self.dateCreated = dateCreated
    }
}
