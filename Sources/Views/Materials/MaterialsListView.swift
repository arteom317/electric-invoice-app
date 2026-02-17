import SwiftUI
import SwiftData

struct MaterialsListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = MaterialsViewModel()
    @State private var showingAddMaterial = false
    @State private var selectedMaterial: Material?
    
    var body: some View {
        NavigationStack {
            VStack {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Caută material...", text: $viewModel.searchText)
                }
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Category filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        CategoryButton(title: "Toate", isSelected: viewModel.selectedCategory == "Toate") {
                            viewModel.selectedCategory = "Toate"
                        }
                        
                        ForEach(Constants.materialCategories, id: \.self) { category in
                            CategoryButton(title: category, isSelected: viewModel.selectedCategory == category) {
                                viewModel.selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                
                // Materials list
                List {
                    ForEach(viewModel.filteredMaterials) { material in
                        Button(action: {
                            selectedMaterial = material
                        }) {
                            MaterialRow(material: material)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .onDelete(perform: deleteMaterials)
                }
                .listStyle(.plain)
            }
            .navigationTitle("Catalog Materiale")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddMaterial = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddMaterial) {
                AddEditMaterialView(material: nil)
            }
            .sheet(item: $selectedMaterial) { material in
                AddEditMaterialView(material: material)
            }
            .onAppear {
                viewModel.loadMaterials(from: modelContext)
                
                // Add sample data if empty
                if viewModel.materials.isEmpty {
                    viewModel.addSampleData(to: modelContext)
                    viewModel.loadMaterials(from: modelContext)
                }
            }
        }
    }
    
    private func deleteMaterials(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(viewModel.filteredMaterials[index])
        }
        viewModel.loadMaterials(from: modelContext)
    }
}

struct MaterialRow: View {
    let material: Material
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(material.name)
                    .font(.headline)
                Text(material.category)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(material.unitPrice.toCurrency())
                    .font(.headline)
                    .foregroundColor(Color(hex: Constants.primaryColor))
                Text("per \(material.unit)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 4)
    }
}

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color(hex: Constants.primaryColor) : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

#Preview {
    MaterialsListView()
        .modelContainer(for: Material.self, inMemory: true)
}
