import SwiftUI
import SwiftData

@available(iOS 17.0, *)
struct ContentView: View {
    @Query private var invoices: [Invoice]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(invoices) { invoice in
                    VStack(alignment: .leading) {
                        Text(invoice.invoiceNumber)
                            .font(.headline)
                        Text(invoice.clientName)
                            .font(.subheadline)
                        Text("Total: \(invoice.totalAmount, specifier: "%.2f") RON")
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Facturi")
            .toolbar {
                Button {
                    addSampleInvoice()
                } label: {
                    Label("Adaugă factură", systemImage: "plus")
                }
            }
        }
    }
    
    private func addSampleInvoice() {
        let newInvoice = Invoice(
            invoiceNumber: "F-\(Int.random(in: 1000...9999))",
            clientName: "Client Test",
            clientAddress: "Adresa Test",
            totalAmount: 1500.00
        )
        modelContext.insert(newInvoice)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Invoice.self, InvoiceMaterialItem.self], inMemory: true)
}
