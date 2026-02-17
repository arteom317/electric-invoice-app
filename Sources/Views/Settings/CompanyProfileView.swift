import SwiftUI
import SwiftData
import PhotosUI

struct CompanyProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var companyProfile: CompanyProfile?
    
    @State private var companyName = ""
    @State private var cui = ""
    @State private var regCom = ""
    @State private var address = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var iban = ""
    @State private var vatRate = "19"
    @State private var currency = "RON"
    @State private var selectedItem: PhotosPickerItem?
    @State private var logoImage: Image?
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Date Companie") {
                    TextField("Nume firmă", text: $companyName)
                    TextField("CUI", text: $cui)
                    TextField("Nr. Registrul Comerțului", text: $regCom)
                    TextField("Adresă", text: $address)
                    TextField("Telefon", text: $phone)
                        .keyboardType(.phonePad)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                    TextField("IBAN", text: $iban)
                        .textInputAutocapitalization(.characters)
                }
                
                Section("Logo Companie") {
                    HStack {
                        if let logoImage = logoImage {
                            logoImage
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .cornerRadius(8)
                        } else {
                            Image(systemName: "building.2")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            Text("Selectează Logo")
                        }
                    }
                }
                .onChange(of: selectedItem) { oldValue, newValue in
                    Task {
                        if let data = try? await newValue?.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data) {
                                logoImage = Image(uiImage: uiImage)
                                companyProfile?.logoData = data
                            }
                        }
                    }
                }
                
                Section("Setări Facturi") {
                    HStack {
                        Text("TVA (%)")
                        Spacer()
                        TextField("19", text: $vatRate)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }
                    
                    Picker("Monedă", selection: $currency) {
                        ForEach(Constants.currencies, id: \.self) { curr in
                            Text(curr).tag(curr)
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        saveProfile()
                    }) {
                        HStack {
                            Spacer()
                            Text("Salvează Setări")
                                .bold()
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Profil Companie")
            .onAppear {
                loadProfile()
            }
        }
    }
    
    private func loadProfile() {
        let descriptor = FetchDescriptor<CompanyProfile>()
        do {
            let profiles = try modelContext.fetch(descriptor)
            if let profile = profiles.first {
                companyProfile = profile
                companyName = profile.companyName
                cui = profile.cui
                regCom = profile.regCom
                address = profile.address
                phone = profile.phone
                email = profile.email
                iban = profile.iban
                vatRate = String(format: "%.0f", profile.vatRate)
                currency = profile.currency
                
                if let logoData = profile.logoData, let uiImage = UIImage(data: logoData) {
                    logoImage = Image(uiImage: uiImage)
                }
            } else {
                // Create a new profile
                let newProfile = CompanyProfile()
                modelContext.insert(newProfile)
                companyProfile = newProfile
            }
        } catch {
            print("Error loading profile: \(error)")
        }
    }
    
    private func saveProfile() {
        guard let profile = companyProfile else { return }
        
        profile.companyName = companyName
        profile.cui = cui
        profile.regCom = regCom
        profile.address = address
        profile.phone = phone
        profile.email = email
        profile.iban = iban
        profile.vatRate = Double(vatRate) ?? 19.0
        profile.currency = currency
        
        do {
            try modelContext.save()
        } catch {
            print("Error saving profile: \(error)")
        }
    }
}

#Preview {
    CompanyProfileView()
        .modelContainer(for: CompanyProfile.self, inMemory: true)
}
