import Foundation
import SwiftData
import SwiftUI

@Observable
class LaborViewModel {
    var laborItems: [LaborItem] = []
    var searchText: String = ""
    
    var filteredLaborItems: [LaborItem] {
        if searchText.isEmpty {
            return laborItems.sorted { $0.description < $1.description }
        }
        return laborItems
            .filter { $0.description.localizedCaseInsensitiveContains(searchText) }
            .sorted { $0.description < $1.description }
    }
    
    func loadLaborItems(from context: ModelContext) {
        let descriptor = FetchDescriptor<LaborItem>(sortBy: [SortDescriptor(\.description)])
        do {
            laborItems = try context.fetch(descriptor)
        } catch {
            print("Error loading labor items: \(error)")
        }
    }
    
    func addSampleData(to context: ModelContext) {
        let sampleLaborItems = [
            LaborItem(description: "Montaj priză", unit: "buc", rate: 25.00),
            LaborItem(description: "Montaj întrerupător", unit: "buc", rate: 20.00),
            LaborItem(description: "Tragere cablu", unit: "m", rate: 8.00),
            LaborItem(description: "Montaj tablou electric", unit: "buc", rate: 150.00),
            LaborItem(description: "Montaj siguranță automată", unit: "buc", rate: 30.00),
            LaborItem(description: "Montare tub PVC", unit: "m", rate: 12.00),
            LaborItem(description: "Montare doză", unit: "buc", rate: 15.00),
            LaborItem(description: "Ștemuit canal", unit: "m", rate: 35.00),
            LaborItem(description: "Verificare și testare instalație", unit: "forfet", rate: 200.00),
            LaborItem(description: "Montaj disjunctor diferențial", unit: "buc", rate: 40.00)
        ]
        
        for laborItem in sampleLaborItems {
            context.insert(laborItem)
        }
        
        do {
            try context.save()
        } catch {
            print("Error saving sample labor items: \(error)")
        }
    }
}
