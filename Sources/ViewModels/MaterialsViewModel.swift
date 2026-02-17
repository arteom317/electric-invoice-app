import Foundation
import SwiftData
import SwiftUI

@Observable
class MaterialsViewModel {
    var materials: [Material] = []
    var searchText: String = ""
    var selectedCategory: String = "Toate"
    
    var filteredMaterials: [Material] {
        var result = materials
        
        if selectedCategory != "Toate" {
            result = result.filter { $0.category == selectedCategory }
        }
        
        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        return result.sorted { $0.name < $1.name }
    }
    
    func loadMaterials(from context: ModelContext) {
        let descriptor = FetchDescriptor<Material>(sortBy: [SortDescriptor(\.name)])
        do {
            materials = try context.fetch(descriptor)
        } catch {
            print("Error loading materials: \(error)")
        }
    }
    
    func addSampleData(to context: ModelContext) {
        let sampleMaterials = [
            Material(name: "Cablu NYM 3x2.5", category: "Cabluri", unit: "m", unitPrice: 12.50),
            Material(name: "Cablu NYM 3x1.5", category: "Cabluri", unit: "m", unitPrice: 8.50),
            Material(name: "Cablu FY 2.5", category: "Cabluri", unit: "m", unitPrice: 2.80),
            Material(name: "Cablu FY 1.5", category: "Cabluri", unit: "m", unitPrice: 1.90),
            Material(name: "Cablu CYY 3x2.5", category: "Cabluri", unit: "m", unitPrice: 15.00),
            Material(name: "Priză simplă", category: "Prize", unit: "buc", unitPrice: 8.00),
            Material(name: "Priză dublă", category: "Prize", unit: "buc", unitPrice: 12.00),
            Material(name: "Priză Schuko", category: "Prize", unit: "buc", unitPrice: 15.00),
            Material(name: "Întrerupător simplu", category: "Întrerupătoare", unit: "buc", unitPrice: 6.00),
            Material(name: "Întrerupător dublu", category: "Întrerupătoare", unit: "buc", unitPrice: 9.00),
            Material(name: "Întrerupător cap scară", category: "Întrerupătoare", unit: "buc", unitPrice: 12.00),
            Material(name: "Întrerupător cruce", category: "Întrerupătoare", unit: "buc", unitPrice: 15.00),
            Material(name: "Tablou electric 4 module", category: "Tablouri electrice", unit: "buc", unitPrice: 45.00),
            Material(name: "Tablou electric 8 module", category: "Tablouri electrice", unit: "buc", unitPrice: 65.00),
            Material(name: "Tablou electric 12 module", category: "Tablouri electrice", unit: "buc", unitPrice: 85.00),
            Material(name: "Tablou electric 24 module", category: "Tablouri electrice", unit: "buc", unitPrice: 135.00),
            Material(name: "Siguranță automată 10A", category: "Siguranțe automate", unit: "buc", unitPrice: 18.00),
            Material(name: "Siguranță automată 16A", category: "Siguranțe automate", unit: "buc", unitPrice: 20.00),
            Material(name: "Siguranță automată 20A", category: "Siguranțe automate", unit: "buc", unitPrice: 22.00),
            Material(name: "Siguranță automată 25A", category: "Siguranțe automate", unit: "buc", unitPrice: 24.00),
            Material(name: "Siguranță automată 32A", category: "Siguranțe automate", unit: "buc", unitPrice: 28.00),
            Material(name: "Disjunctor diferențial 30mA", category: "Disjunctoare diferențiale", unit: "buc", unitPrice: 95.00),
            Material(name: "Disjunctor diferențial 300mA", category: "Disjunctoare diferențiale", unit: "buc", unitPrice: 110.00),
            Material(name: "Tub PVC 16mm", category: "Tuburi PVC", unit: "m", unitPrice: 3.50),
            Material(name: "Tub PVC 20mm", category: "Tuburi PVC", unit: "m", unitPrice: 4.50),
            Material(name: "Tub PVC 25mm", category: "Tuburi PVC", unit: "m", unitPrice: 5.50),
            Material(name: "Doză simplă", category: "Doze", unit: "buc", unitPrice: 1.50),
            Material(name: "Doză derivație", category: "Doze", unit: "buc", unitPrice: 2.50),
            Material(name: "Cleme conexiune", category: "Accesorii", unit: "buc", unitPrice: 0.50),
            Material(name: "Șuruburi", category: "Accesorii", unit: "buc", unitPrice: 0.20),
            Material(name: "Dibluri", category: "Accesorii", unit: "buc", unitPrice: 0.30)
        ]
        
        for material in sampleMaterials {
            context.insert(material)
        }
        
        do {
            try context.save()
        } catch {
            print("Error saving sample materials: \(error)")
        }
    }
}
