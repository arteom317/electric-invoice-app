import SwiftUI
import SwiftData

struct LaborListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = LaborViewModel()
    @State private var showingAddLabor = false
    @State private var selectedLabor: LaborItem?
    
    var body: some View {
        NavigationStack {
            VStack {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Caută lucrare...", text: $viewModel.searchText)
                }
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                // Labor list
                List {
                    ForEach(viewModel.filteredLaborItems) { labor in
                        Button(action: {
                            selectedLabor = labor
                        }) {
                            LaborRow(labor: labor)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .onDelete(perform: deleteLaborItems)
                }
                .listStyle(.plain)
            }
            .navigationTitle("Catalog Manoperă")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddLabor = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddLabor) {
                AddEditLaborView(laborItem: nil)
            }
            .sheet(item: $selectedLabor) { labor in
                AddEditLaborView(laborItem: labor)
            }
            .onAppear {
                viewModel.loadLaborItems(from: modelContext)
                
                // Add sample data if empty
                if viewModel.laborItems.isEmpty {
                    viewModel.addSampleData(to: modelContext)
                    viewModel.loadLaborItems(from: modelContext)
                }
            }
        }
    }
    
    private func deleteLaborItems(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(viewModel.filteredLaborItems[index])
        }
        viewModel.loadLaborItems(from: modelContext)
    }
}

struct LaborRow: View {
    let labor: LaborItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(labor.description)
                    .font(.headline)
                Text("per \(labor.unit)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(labor.rate.toCurrency())
                .font(.headline)
                .foregroundColor(Color(hex: Constants.primaryColor))
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    LaborListView()
        .modelContainer(for: LaborItem.self, inMemory: true)
}
