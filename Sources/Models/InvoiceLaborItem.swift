import Foundation
import SwiftData

@Model
final class InvoiceLaborItem {
    var id: UUID
    var description: String
    var unit: String
    var quantity: Double
    var rate: Double
    var subtotal: Double
    
    init(id: UUID = UUID(), description: String, unit: String, quantity: Double, rate: Double) {
        self.id = id
        self.description = description
        self.unit = unit
        self.quantity = quantity
        self.rate = rate
        self.subtotal = quantity * rate
    }
}
