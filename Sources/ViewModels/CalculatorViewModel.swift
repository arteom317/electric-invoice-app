import Foundation
import SwiftData
import SwiftUI

struct CalculatorMaterialItem: Identifiable {
    let id = UUID()
    var material: Material
    var quantity: Double = 1.0
    
    var subtotal: Double {
        material.unitPrice * quantity
    }
}

struct CalculatorLaborItem: Identifiable {
    let id = UUID()
    var laborItem: LaborItem
    var quantity: Double = 1.0
    
    var subtotal: Double {
        laborItem.rate * quantity
    }
}

@Observable
class CalculatorViewModel {
    var selectedMaterials: [CalculatorMaterialItem] = []
    var selectedLabor: [CalculatorLaborItem] = []
    var discountPercent: Double = 0.0
    var vatRate: Double = 19.0
    
    var subtotalMaterials: Double {
        selectedMaterials.reduce(0) { $0 + $1.subtotal }
    }
    
    var subtotalLabor: Double {
        selectedLabor.reduce(0) { $0 + $1.subtotal }
    }
    
    var totalWithoutVAT: Double {
        let baseTotal = subtotalMaterials + subtotalLabor
        let discountAmount = baseTotal * (discountPercent / 100.0)
        return baseTotal - discountAmount
    }
    
    var vatAmount: Double {
        totalWithoutVAT * (vatRate / 100.0)
    }
    
    var totalWithVAT: Double {
        totalWithoutVAT + vatAmount
    }
    
    func addMaterial(_ material: Material) {
        if !selectedMaterials.contains(where: { $0.material.id == material.id }) {
            selectedMaterials.append(CalculatorMaterialItem(material: material))
        }
    }
    
    func removeMaterial(at offsets: IndexSet) {
        selectedMaterials.remove(atOffsets: offsets)
    }
    
    func addLabor(_ laborItem: LaborItem) {
        if !selectedLabor.contains(where: { $0.laborItem.id == laborItem.id }) {
            selectedLabor.append(CalculatorLaborItem(laborItem: laborItem))
        }
    }
    
    func removeLabor(at offsets: IndexSet) {
        selectedLabor.remove(atOffsets: offsets)
    }
    
    func reset() {
        selectedMaterials.removeAll()
        selectedLabor.removeAll()
        discountPercent = 0.0
    }
}
