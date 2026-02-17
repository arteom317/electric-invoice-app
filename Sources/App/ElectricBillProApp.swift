import SwiftUI
import SwiftData

@available(iOS 17.0, *)
@main
struct ElectricBillProApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Invoice.self, InvoiceMaterialItem.self])
    }
}
