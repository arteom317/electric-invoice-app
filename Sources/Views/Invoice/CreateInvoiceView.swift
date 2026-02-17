import SwiftUI
import SwiftData

struct CreateInvoiceView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var calculatorViewModel = CalculatorViewModel()
    @State private var materialsViewModel = MaterialsViewModel()
    @State private var laborViewModel = LaborViewModel()
    @State private var invoiceViewModel = InvoiceViewModel()
    
    @State private var invoiceNumber = ""
    @State private var dateIssued = Date()
    @State private var clientName = ""
    @State private var clientCui = ""
    @State private var clientAddress = ""
    @State private var clientPhone = ""
    @State private var notes = ""
    @State private var showingMaterialsPicker = false
    @State private var showingLaborPicker = false
    @State private var companyProfile: CompanyProfile?
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Date Factură") {
                    TextField("Număr factură", text: $invoiceNumber)
                    DatePicker("Data emiterii", selection: $dateIssued, displayedComponents: .date)
                }
                
                Section("Date Client") {
                    TextField("Nume client / Firmă", text: $clientName)
                    TextField("CUI (opțional)", text: $clientCui)
                    TextField("Adresă", text: $clientAddress)
                    TextField("Telefon", text: $clientPhone)
                        .keyboardType(.phonePad)
                }
                
                Section("Materiale") {
                    ForEach(calculatorViewModel.selectedMaterials) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.material.name)
                                    .font(.subheadline)
                                Text("\(String(format: "%.1f", item.quantity)) x \(item.material.unitPrice.toCurrency())")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Text(item.subtotal.toCurrency(currency: companyProfile?.currency ?? "RON"))
                                .font(.subheadline)
                        }
                    }
                    .onDelete { offsets in
                        calculatorViewModel.removeMaterial(at: offsets)
                    }
                    
                    Button(action: {
                        showingMaterialsPicker = true
                    }) {
                        Label("Adaugă Material", systemImage: "plus.circle.fill")
                    }
                }
                
                Section("Manoperă") {
                    ForEach(calculatorViewModel.selectedLabor) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.laborItem.description)
                                    .font(.subheadline)
                                Text("\(String(format: "%.1f", item.quantity)) x \(item.laborItem.rate.toCurrency())")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Text(item.subtotal.toCurrency(currency: companyProfile?.currency ?? "RON"))
                                .font(.subheadline)
                        }
                    }
                    .onDelete { offsets in
                        calculatorViewModel.removeLabor(at: offsets)
                    }
                    
                    Button(action: {
                        showingLaborPicker = true
                    }) {
                        Label("Adaugă Manoperă", systemImage: "plus.circle.fill")
                    }
                }
                
                Section("Reducere și TVA") {
                    HStack {
                        Text("Reducere (%)")
                        Spacer()
                        TextField("0", value: $calculatorViewModel.discountPercent, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }
                }
                
                Section("Observații") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 80)
                }
                
                Section("Total") {
                    HStack {
                        Text("Subtotal Materiale")
                        Spacer()
                        Text(calculatorViewModel.subtotalMaterials.toCurrency(currency: companyProfile?.currency ?? "RON"))
                    }
                    
                    HStack {
                        Text("Subtotal Manoperă")
                        Spacer()
                        Text(calculatorViewModel.subtotalLabor.toCurrency(currency: companyProfile?.currency ?? "RON"))
                    }
                    
                    HStack {
                        Text("Total fără TVA")
                        Spacer()
                        Text(calculatorViewModel.totalWithoutVAT.toCurrency(currency: companyProfile?.currency ?? "RON"))
                    }
                    
                    HStack {
                        Text("TVA \(String(format: "%.0f", calculatorViewModel.vatRate))%")
                        Spacer()
                        Text(calculatorViewModel.vatAmount.toCurrency(currency: companyProfile?.currency ?? "RON"))
                    }
                    
                    HStack {
                        Text("TOTAL CU TVA")
                            .bold()
                            .font(.headline)
                        Spacer()
                        Text(calculatorViewModel.totalWithVAT.toCurrency(currency: companyProfile?.currency ?? "RON"))
                            .bold()
                            .font(.headline)
                            .foregroundColor(Color(hex: Constants.primaryColor))
                    }
                }
            }
            .navigationTitle("Creare Factură")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Anulează") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Salvează") {
                        saveInvoice()
                    }
                    .disabled(!isValid)
                }
            }
            .sheet(isPresented: $showingMaterialsPicker) {
                MaterialPickerView(viewModel: materialsViewModel) { material in
                    calculatorViewModel.addMaterial(material)
                    showingMaterialsPicker = false
                }
            }
            .sheet(isPresented: $showingLaborPicker) {
                LaborPickerView(viewModel: laborViewModel) { labor in
                    calculatorViewModel.addLabor(labor)
                    showingLaborPicker = false
                }
            }
            .onAppear {
                materialsViewModel.loadMaterials(from: modelContext)
                laborViewModel.loadLaborItems(from: modelContext)
                loadCompanyProfile()
                
                invoiceNumber = invoiceViewModel.getNextInvoiceNumber(from: modelContext)
                
                if let profile = companyProfile {
                    calculatorViewModel.vatRate = profile.vatRate
                }
            }
        }
    }
    
    private var isValid: Bool {
        !invoiceNumber.isEmpty && !clientName.isEmpty && !clientAddress.isEmpty && !clientPhone.isEmpty &&
        (!calculatorViewModel.selectedMaterials.isEmpty || !calculatorViewModel.selectedLabor.isEmpty)
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
    
    private func saveInvoice() {
        // Create invoice material items
        let materials = calculatorViewModel.selectedMaterials.map {
            InvoiceMaterialItem(
                materialName: $0.material.name,
                unit: $0.material.unit,
                quantity: $0.quantity,
                unitPrice: $0.material.unitPrice
            )
        }
        
        // Create invoice labor items
        let laborItems = calculatorViewModel.selectedLabor.map {
            InvoiceLaborItem(
                description: $0.laborItem.description,
                unit: $0.laborItem.unit,
                quantity: $0.quantity,
                rate: $0.laborItem.rate
            )
        }
        
        let invoice = Invoice(
            invoiceNumber: invoiceNumber,
            dateIssued: dateIssued,
            clientName: clientName,
            clientCui: clientCui.isEmpty ? nil : clientCui,
            clientAddress: clientAddress,
            clientPhone: clientPhone,
            materials: materials,
            laborItems: laborItems,
            vatRate: calculatorViewModel.vatRate,
            discountPercent: calculatorViewModel.discountPercent,
            notes: notes
        )
        
        modelContext.insert(invoice)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Error saving invoice: \(error)")
        }
    }
}

#Preview {
    CreateInvoiceView()
        .modelContainer(for: [Invoice.self, Material.self, LaborItem.self, CompanyProfile.self], inMemory: true)
}
