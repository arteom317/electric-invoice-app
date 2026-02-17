import SwiftUI
import SwiftData

@main
struct ElectricBillProApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Material.self,
            LaborItem.self,
            Invoice.self,
            InvoiceMaterialItem.self,
            InvoiceLaborItem.self,
            Client.self,
            CompanyProfile.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
