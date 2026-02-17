import Foundation
import SwiftData

@available(iOS 17.0, macOS 14.0, *)
@Model
final class InvoiceMaterialItem {
    var id: UUID
    var name: String
    var quantity: Double
    var unitPrice: Double
    var unit: String
    
    @Relationship(inverse: \Invoice.materialItems)
    var invoice: Invoice?
    
    var totalPrice: Double {
        quantity * unitPrice
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        quantity: Double,
        unitPrice: Double,
        unit: String = "buc"
    ) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.unitPrice = unitPrice
        self.unit = unit
    }
}
