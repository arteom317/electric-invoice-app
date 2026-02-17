import Foundation
import SwiftData

@Model
final class Invoice {
    var id: UUID
    var invoiceNumber: String
    var dateIssued: Date
    
    // Client information
    var clientName: String
    var clientCui: String?
    var clientAddress: String
    var clientPhone: String
    
    // Items
    @Relationship(deleteRule: .cascade) var materials: [InvoiceMaterialItem]
    @Relationship(deleteRule: .cascade) var laborItems: [InvoiceLaborItem]
    
    // Calculations
    var subtotalMaterials: Double
    var subtotalLabor: Double
    var totalWithoutVAT: Double
    var vatRate: Double
    var vatAmount: Double
    var totalWithVAT: Double
    var discountPercent: Double
    
    // Status
    var isPaid: Bool
    var notes: String
    
    init(id: UUID = UUID(), invoiceNumber: String, dateIssued: Date = Date(),
         clientName: String, clientCui: String? = nil, clientAddress: String, clientPhone: String,
         materials: [InvoiceMaterialItem] = [], laborItems: [InvoiceLaborItem] = [],
         vatRate: Double = 19.0, discountPercent: Double = 0.0,
         isPaid: Bool = false, notes: String = "") {
        
        self.id = id
        self.invoiceNumber = invoiceNumber
        self.dateIssued = dateIssued
        self.clientName = clientName
        self.clientCui = clientCui
        self.clientAddress = clientAddress
        self.clientPhone = clientPhone
        self.materials = materials
        self.laborItems = laborItems
        self.vatRate = vatRate
        self.discountPercent = discountPercent
        self.isPaid = isPaid
        self.notes = notes
        
        // Calculate totals
        self.subtotalMaterials = materials.reduce(0) { $0 + $1.subtotal }
        self.subtotalLabor = laborItems.reduce(0) { $0 + $1.subtotal }
        
        let baseTotal = subtotalMaterials + subtotalLabor
        let discountAmount = baseTotal * (discountPercent / 100.0)
        self.totalWithoutVAT = baseTotal - discountAmount
        self.vatAmount = totalWithoutVAT * (vatRate / 100.0)
        self.totalWithVAT = totalWithoutVAT + vatAmount
    }
    
    func recalculateTotals() {
        subtotalMaterials = materials.reduce(0) { $0 + $1.subtotal }
        subtotalLabor = laborItems.reduce(0) { $0 + $1.subtotal }
        
        let baseTotal = subtotalMaterials + subtotalLabor
        let discountAmount = baseTotal * (discountPercent / 100.0)
        totalWithoutVAT = baseTotal - discountAmount
        vatAmount = totalWithoutVAT * (vatRate / 100.0)
        totalWithVAT = totalWithoutVAT + vatAmount
    }
}
