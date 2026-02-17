import SwiftUI
import SwiftData

struct InvoiceHistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = InvoiceViewModel()
    @State private var showingCreateInvoice = false
    @State private var selectedInvoice: Invoice?
    
    var body: some View {
        NavigationStack {
            VStack {
                // Search and filter
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Caută factură...", text: $viewModel.searchText)
                }
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top, 8)
                
                Picker("Status", selection: $viewModel.filterStatus) {
                    ForEach(InvoiceViewModel.InvoiceStatus.allCases, id: \.self) { status in
                        Text(status.rawValue).tag(status)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                // Invoices list
                if viewModel.filteredInvoices.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "doc.text")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("Nu există facturi")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("Apasă + pentru a crea prima factură")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(viewModel.filteredInvoices) { invoice in
                            Button(action: {
                                selectedInvoice = invoice
                            }) {
                                InvoiceRow(invoice: invoice)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .onDelete(perform: deleteInvoices)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Facturi")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingCreateInvoice = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingCreateInvoice) {
                CreateInvoiceView()
            }
            .sheet(item: $selectedInvoice) { invoice in
                InvoiceDetailView(invoice: invoice)
            }
            .onAppear {
                viewModel.loadInvoices(from: modelContext)
            }
        }
    }
    
    private func deleteInvoices(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(viewModel.filteredInvoices[index])
        }
        viewModel.loadInvoices(from: modelContext)
    }
}

struct InvoiceRow: View {
    let invoice: Invoice
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("Factură \(invoice.invoiceNumber)")
                    .font(.headline)
                Text(invoice.clientName)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(invoice.dateIssued.formatted())
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 6) {
                Text(invoice.totalWithVAT.toCurrency())
                    .font(.headline)
                    .foregroundColor(Color(hex: Constants.primaryColor))
                
                if invoice.isPaid {
                    Label("Plătită", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                } else {
                    Label("Neplătită", systemImage: "clock.fill")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    InvoiceHistoryView()
        .modelContainer(for: Invoice.self, inMemory: true)
}
