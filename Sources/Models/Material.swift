import Foundation
import SwiftData

@Model
final class Material {
    var id: UUID
    var name: String
    var category: String
    var unit: String // buc, m, kg
    var unitPrice: Double
    var dateCreated: Date
    
    init(id: UUID = UUID(), name: String, category: String, unit: String, unitPrice: Double, dateCreated: Date = Date()) {
        self.id = id
        self.name = name
        self.category = category
        self.unit = unit
        self.unitPrice = unitPrice
        self.dateCreated = dateCreated
    }
}
