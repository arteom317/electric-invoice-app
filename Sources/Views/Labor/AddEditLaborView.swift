import SwiftUI
import SwiftData

struct AddEditLaborView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let laborItem: LaborItem?
    
    @State private var description: String
    @State private var unit: String
    @State private var rate: String
    
    init(laborItem: LaborItem?) {
        self.laborItem = laborItem
        _description = State(initialValue: laborItem?.description ?? "")
        _unit = State(initialValue: laborItem?.unit ?? "buc")
        _rate = State(initialValue: laborItem != nil ? String(format: "%.2f", laborItem!.rate) : "")
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Detalii Lucrare") {
                    TextField("Descriere lucrare", text: $description)
                    
                    Picker("Unitate de măsură", selection: $unit) {
                        ForEach(Constants.laborUnits, id: \.self) { u in
                            Text(u).tag(u)
                        }
                    }
                    
                    TextField("Tarif per unitate", text: $rate)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle(laborItem == nil ? "Lucrare Nouă" : "Editează Lucrare")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Anulează") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Salvează") {
                        saveLabor()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
    
    private var isValid: Bool {
        !description.isEmpty && Double(rate) != nil
    }
    
    private func saveLabor() {
        guard let rateValue = Double(rate) else { return }
        
        if let laborItem = laborItem {
            laborItem.description = description
            laborItem.unit = unit
            laborItem.rate = rateValue
        } else {
            let newLabor = LaborItem(description: description, unit: unit, rate: rateValue)
            modelContext.insert(newLabor)
        }
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Error saving labor: \(error)")
        }
    }
}

#Preview {
    AddEditLaborView(laborItem: nil)
        .modelContainer(for: LaborItem.self, inMemory: true)
}
