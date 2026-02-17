import SwiftUI
import SwiftData

struct CostCalculatorView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = CalculatorViewModel()
    @State private var materialsViewModel = MaterialsViewModel()
    @State private var laborViewModel = LaborViewModel()
    @State private var showingMaterialsPicker = false
    @State private var showingLaborPicker = false
    @State private var companyProfile: CompanyProfile?
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Materiale") {
                    ForEach(viewModel.selectedMaterials) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.material.name)
                                    .font(.subheadline)
                                Text(item.material.unitPrice.toCurrency() + " / \(item.material.unit)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Stepper(value: Binding(
                                get: { item.quantity },
                                set: { newValue in
                                    if let index = viewModel.selectedMaterials.firstIndex(where: { $0.id == item.id }) {
                                        viewModel.selectedMaterials[index].quantity = newValue
                                    }
                                }
                            ), in: 0.1...9999, step: 0.5) {
                                Text(String(format: "%.1f", item.quantity))
                                    .frame(width: 50, alignment: .trailing)
                            }
                        }
                    }
                    .onDelete { offsets in
                        viewModel.removeMaterial(at: offsets)
                    }
                    
                    Button(action: {
                        showingMaterialsPicker = true
                    }) {
                        Label("Adaugă Material", systemImage: "plus.circle.fill")
                    }
                    
                    HStack {
                        Text("Subtotal Materiale")
                            .bold()
                        Spacer()
                        Text(viewModel.subtotalMaterials.toCurrency(currency: companyProfile?.currency ?? "RON"))
                            .bold()
                            .foregroundColor(Color(hex: Constants.primaryColor))
                    }
                }
                
                Section("Manoperă") {
                    ForEach(viewModel.selectedLabor) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.laborItem.description)
                                    .font(.subheadline)
                                Text(item.laborItem.rate.toCurrency() + " / \(item.laborItem.unit)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Stepper(value: Binding(
                                get: { item.quantity },
                                set: { newValue in
                                    if let index = viewModel.selectedLabor.firstIndex(where: { $0.id == item.id }) {
                                        viewModel.selectedLabor[index].quantity = newValue
                                    }
                                }
                            ), in: 0.1...9999, step: 0.5) {
                                Text(String(format: "%.1f", item.quantity))
                                    .frame(width: 50, alignment: .trailing)
                            }
                        }
                    }
                    .onDelete { offsets in
                        viewModel.removeLabor(at: offsets)
                    }
                    
                    Button(action: {
                        showingLaborPicker = true
                    }) {
                        Label("Adaugă Manoperă", systemImage: "plus.circle.fill")
                    }
                    
                    HStack {
                        Text("Subtotal Manoperă")
                            .bold()
                        Spacer()
                        Text(viewModel.subtotalLabor.toCurrency(currency: companyProfile?.currency ?? "RON"))
                            .bold()
                            .foregroundColor(Color(hex: Constants.primaryColor))
                    }
                }
                
                Section("Reducere și TVA") {
                    HStack {
                        Text("Reducere (%)")
                        Spacer()
                        TextField("0", value: $viewModel.discountPercent, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }
                    
                    HStack {
                        Text("TVA (%)")
                        Spacer()
                        Text(String(format: "%.0f", viewModel.vatRate))
                    }
                }
                
                Section("Total") {
                    HStack {
                        Text("Total fără TVA")
                        Spacer()
                        Text(viewModel.totalWithoutVAT.toCurrency(currency: companyProfile?.currency ?? "RON"))
                    }
                    
                    HStack {
                        Text("TVA")
                        Spacer()
                        Text(viewModel.vatAmount.toCurrency(currency: companyProfile?.currency ?? "RON"))
                    }
                    
                    HStack {
                        Text("TOTAL CU TVA")
                            .bold()
                            .font(.headline)
                        Spacer()
                        Text(viewModel.totalWithVAT.toCurrency(currency: companyProfile?.currency ?? "RON"))
                            .bold()
                            .font(.headline)
                            .foregroundColor(Color(hex: Constants.primaryColor))
                    }
                }
            }
            .navigationTitle("Calculator Costuri")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Resetează") {
                        viewModel.reset()
                    }
                    .disabled(viewModel.selectedMaterials.isEmpty && viewModel.selectedLabor.isEmpty)
                }
            }
            .sheet(isPresented: $showingMaterialsPicker) {
                MaterialPickerView(viewModel: materialsViewModel) { material in
                    viewModel.addMaterial(material)
                    showingMaterialsPicker = false
                }
            }
            .sheet(isPresented: $showingLaborPicker) {
                LaborPickerView(viewModel: laborViewModel) { labor in
                    viewModel.addLabor(labor)
                    showingLaborPicker = false
                }
            }
            .onAppear {
                materialsViewModel.loadMaterials(from: modelContext)
                laborViewModel.loadLaborItems(from: modelContext)
                loadCompanyProfile()
                
                if let profile = companyProfile {
                    viewModel.vatRate = profile.vatRate
                }
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
}

struct MaterialPickerView: View {
    @Environment(\.dismiss) private var dismiss
    let viewModel: MaterialsViewModel
    let onSelect: (Material) -> Void
    
    var body: some View {
        NavigationStack {
            List(viewModel.filteredMaterials) { material in
                Button(action: {
                    onSelect(material)
                }) {
                    MaterialRow(material: material)
                }
            }
            .navigationTitle("Selectează Material")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Închide") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct LaborPickerView: View {
    @Environment(\.dismiss) private var dismiss
    let viewModel: LaborViewModel
    let onSelect: (LaborItem) -> Void
    
    var body: some View {
        NavigationStack {
            List(viewModel.filteredLaborItems) { labor in
                Button(action: {
                    onSelect(labor)
                }) {
                    LaborRow(labor: labor)
                }
            }
            .navigationTitle("Selectează Manoperă")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Închide") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    CostCalculatorView()
        .modelContainer(for: [Material.self, LaborItem.self, CompanyProfile.self], inMemory: true)
}
