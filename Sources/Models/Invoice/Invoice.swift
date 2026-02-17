import Foundation
import SwiftData

@available(iOS 17.0, macOS 14.0, *)
@Model
final class Invoice {
    var id: UUID
    var invoiceNumber: String
    var date: Date
    var clientName: String
    var clientAddress: String
    var totalAmount: Double
    var isPaid: Bool
    
    @Relationship(deleteRule: .cascade)
    var materialItems: [InvoiceMaterialItem] = []
    
    init(
        id: UUID = UUID(),
        invoiceNumber: String,
        date: Date = Date(),
        clientName: String,
        clientAddress: String,
        totalAmount: Double = 0.0,
        isPaid: Bool = false
    ) {
        self.id = id
        self.invoiceNumber = invoiceNumber
        self.date = date
        self.clientName = clientName
        self.clientAddress = clientAddress
        self.totalAmount = totalAmount
        self.isPaid = isPaid
    }
}
