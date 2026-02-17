import SwiftUI
import SwiftData

struct InvoiceDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let invoice: Invoice
    
    @State private var companyProfile: CompanyProfile?
    @State private var showingShareSheet = false
    @State private var pdfData: Data?
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Informații Factură") {
                    LabeledContent("Număr", value: invoice.invoiceNumber)
                    LabeledContent("Data", value: invoice.dateIssued.formatted())
                    
                    HStack {
                        Text("Status")
                        Spacer()
                        Toggle("", isOn: Binding(
                            get: { invoice.isPaid },
                            set: { newValue in
                                invoice.isPaid = newValue
                                try? modelContext.save()
                            }
                        ))
                        .labelsHidden()
                        Text(invoice.isPaid ? "Plătită" : "Neplătită")
                            .foregroundColor(invoice.isPaid ? .green : .orange)
                    }
                }
                
                Section("Client") {
                    LabeledContent("Nume", value: invoice.clientName)
                    if let cui = invoice.clientCui, !cui.isEmpty {
                        LabeledContent("CUI", value: cui)
                    }
                    LabeledContent("Adresă", value: invoice.clientAddress)
                    LabeledContent("Telefon", value: invoice.clientPhone)
                }
                
                if !invoice.materials.isEmpty {
                    Section("Materiale") {
                        ForEach(invoice.materials) { material in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(material.materialName)
                                    .font(.subheadline)
                                HStack {
                                    Text("\(String(format: "%.2f", material.quantity)) \(material.unit) x \(material.unitPrice.toCurrency(currency: companyProfile?.currency ?? "RON"))")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text(material.subtotal.toCurrency(currency: companyProfile?.currency ?? "RON"))
                                        .font(.caption)
                                        .foregroundColor(Color(hex: Constants.primaryColor))
                                }
                            }
                            .padding(.vertical, 2)
                        }
                        
                        HStack {
                            Text("Subtotal Materiale")
                                .bold()
                            Spacer()
                            Text(invoice.subtotalMaterials.toCurrency(currency: companyProfile?.currency ?? "RON"))
                                .bold()
                        }
                    }
                }
                
                if !invoice.laborItems.isEmpty {
                    Section("Manoperă") {
                        ForEach(invoice.laborItems) { labor in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(labor.description)
                                    .font(.subheadline)
                                HStack {
                                    Text("\(String(format: "%.2f", labor.quantity)) \(labor.unit) x \(labor.rate.toCurrency(currency: companyProfile?.currency ?? "RON"))")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text(labor.subtotal.toCurrency(currency: companyProfile?.currency ?? "RON"))
                                        .font(.caption)
                                        .foregroundColor(Color(hex: Constants.primaryColor))
                                }
                            }
                            .padding(.vertical, 2)
                        }
                        
                        HStack {
                            Text("Subtotal Manoperă")
                                .bold()
                            Spacer()
                            Text(invoice.subtotalLabor.toCurrency(currency: companyProfile?.currency ?? "RON"))
                                .bold()
                        }
                    }
                }
                
                Section("Total") {
                    LabeledContent("Total fără TVA", value: invoice.totalWithoutVAT.toCurrency(currency: companyProfile?.currency ?? "RON"))
                    LabeledContent("TVA \(String(format: "%.0f", invoice.vatRate))%", value: invoice.vatAmount.toCurrency(currency: companyProfile?.currency ?? "RON"))
                    
                    HStack {
                        Text("TOTAL CU TVA")
                            .bold()
                            .font(.headline)
                        Spacer()
                        Text(invoice.totalWithVAT.toCurrency(currency: companyProfile?.currency ?? "RON"))
                            .bold()
                            .font(.headline)
                            .foregroundColor(Color(hex: Constants.primaryColor))
                    }
                }
                
                if !invoice.notes.isEmpty {
                    Section("Observații") {
                        Text(invoice.notes)
                    }
                }
                
                Section {
                    Button(action: {
                        generateAndSharePDF()
                    }) {
                        HStack {
                            Spacer()
                            Label("Generează și Partajează PDF", systemImage: "square.and.arrow.up")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Detalii Factură")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Închide") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                if let pdfData = pdfData {
                    ShareSheet(items: [pdfData])
                }
            }
            .onAppear {
                loadCompanyProfile()
            }
        }
    }
    
    private func loadCompanyProfile() {
        let descriptor = FetchDescriptor<CompanyProfile>()
        do {
            let profiles = try modelContext.fetch(descriptor)
            companyProfile = profiles.first
        } catch {
            print("Error loading company profile: \(error)")
        }
    }
    
    private func generateAndSharePDF() {
        guard let profile = companyProfile else {
            print("No company profile found")
            return
        }
        
        if let data = PDFGenerator.generateInvoicePDF(invoice: invoice, companyProfile: profile) {
            pdfData = data
            showingShareSheet = true
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Invoice.self, configurations: config)
    
    let invoice = Invoice(
        invoiceNumber: "2024-0001",
        clientName: "Test Client",
        clientAddress: "Test Address",
        clientPhone: "0712345678"
    )
    
    return InvoiceDetailView(invoice: invoice)
        .modelContainer(container)
}
