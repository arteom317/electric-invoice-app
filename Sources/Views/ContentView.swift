import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MaterialsListView()
                .tabItem {
                    Label("Materiale", systemImage: "shippingbox.fill")
                }
            
            LaborListView()
                .tabItem {
                    Label("Manoperă", systemImage: "wrench.and.screwdriver.fill")
                }
            
            CostCalculatorView()
                .tabItem {
                    Label("Calculator", systemImage: "plus.forwardslash.minus")
                }
            
            InvoiceHistoryView()
                .tabItem {
                    Label("Facturi", systemImage: "doc.text.fill")
                }
            
            CompanyProfileView()
                .tabItem {
                    Label("Setări", systemImage: "gear")
                }
        }
        .accentColor(Color(hex: Constants.primaryColor))
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Material.self, LaborItem.self, Invoice.self, CompanyProfile.self], inMemory: true)
}
