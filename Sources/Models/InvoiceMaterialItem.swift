import Foundation
import SwiftData

@Model
final class InvoiceMaterialItem {
    var id: UUID
    var materialName: String
    var unit: String
    var quantity: Double
    var unitPrice: Double
    var subtotal: Double
    
    init(id: UUID = UUID(), materialName: String, unit: String, quantity: Double, unitPrice: Double) {
        self.id = id
        self.materialName = materialName
        self.unit = unit
        self.quantity = quantity
        self.unitPrice = unitPrice
        self.subtotal = quantity * unitPrice
    }
}
