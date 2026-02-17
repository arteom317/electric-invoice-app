import SwiftUI
import SwiftData

struct AddEditMaterialView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let material: Material?
    
    @State private var name: String
    @State private var category: String
    @State private var unit: String
    @State private var unitPrice: String
    
    init(material: Material?) {
        self.material = material
        _name = State(initialValue: material?.name ?? "")
        _category = State(initialValue: material?.category ?? Constants.materialCategories.first ?? "Cabluri")
        _unit = State(initialValue: material?.unit ?? "buc")
        _unitPrice = State(initialValue: material != nil ? String(format: "%.2f", material!.unitPrice) : "")
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Detalii Material") {
                    TextField("Nume material", text: $name)
                    
                    Picker("Categorie", selection: $category) {
                        ForEach(Constants.materialCategories, id: \.self) { cat in
                            Text(cat).tag(cat)
                        }
                    }
                    
                    Picker("Unitate de măsură", selection: $unit) {
                        ForEach(Constants.units, id: \.self) { u in
                            Text(u).tag(u)
                        }
                    }
                    
                    TextField("Preț unitar", text: $unitPrice)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle(material == nil ? "Material Nou" : "Editează Material")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Anulează") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Salvează") {
                        saveMaterial()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
    
    private var isValid: Bool {
        !name.isEmpty && Double(unitPrice) != nil
    }
    
    private func saveMaterial() {
        guard let price = Double(unitPrice) else { return }
        
        if let material = material {
            material.name = name
            material.category = category
            material.unit = unit
            material.unitPrice = price
        } else {
            let newMaterial = Material(name: name, category: category, unit: unit, unitPrice: price)
            modelContext.insert(newMaterial)
        }
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Error saving material: \(error)")
        }
    }
}

#Preview {
    AddEditMaterialView(material: nil)
        .modelContainer(for: Material.self, inMemory: true)
}
