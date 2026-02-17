import Foundation
import SwiftData

@Model
final class LaborItem {
    var id: UUID
    var description: String
    var unit: String // bucată, metru liniar, forfet
    var rate: Double
    var dateCreated: Date
    
    init(id: UUID = UUID(), description: String, unit: String, rate: Double, dateCreated: Date = Date()) {
        self.id = id
        self.description = description
        self.unit = unit
        self.rate = rate
        self.dateCreated = dateCreated
    }
}
