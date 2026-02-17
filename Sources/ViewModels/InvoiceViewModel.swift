import Foundation
import SwiftData
import SwiftUI

@Observable
class InvoiceViewModel {
    var invoices: [Invoice] = []
    var searchText: String = ""
    var filterStatus: InvoiceStatus = .all
    
    enum InvoiceStatus: String, CaseIterable {
        case all = "Toate"
        case paid = "Plătite"
        case unpaid = "Neplătite"
    }
    
    var filteredInvoices: [Invoice] {
        var result = invoices
        
        switch filterStatus {
        case .all:
            break
        case .paid:
            result = result.filter { $0.isPaid }
        case .unpaid:
            result = result.filter { !$0.isPaid }
        }
        
        if !searchText.isEmpty {
            result = result.filter { 
                $0.clientName.localizedCaseInsensitiveContains(searchText) ||
                $0.invoiceNumber.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return result.sorted { $0.dateIssued > $1.dateIssued }
    }
    
    func loadInvoices(from context: ModelContext) {
        let descriptor = FetchDescriptor<Invoice>(sortBy: [SortDescriptor(\.dateIssued, order: .reverse)])
        do {
            invoices = try context.fetch(descriptor)
        } catch {
            print("Error loading invoices: \(error)")
        }
    }
    
    func getNextInvoiceNumber(from context: ModelContext) -> String {
        loadInvoices(from: context)
        let year = Calendar.current.component(.year, from: Date())
        let count = invoices.count + 1
        return String(format: "%d-%04d", year, count)
    }
}
