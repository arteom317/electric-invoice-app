# 📊 ElectricBill Pro - Documentație Tehnică

## Arhitectură Aplicației

### Design Pattern: MVVM (Model-View-ViewModel)

Aplicația folosește arhitectura MVVM pentru separarea clară a logicii:

- **Models:** Definesc structura datelor și logica de business
- **Views:** UI-ul complet în SwiftUI
- **ViewModels:** Gestionează starea și logica de prezentare

### SwiftData pentru Persistență

SwiftData este folosit pentru persistența datelor cu următoarele avantaje:
- Auto-save
- iCloud sync ready (poate fi activat)
- Type-safe queries
- Automatic migration

## 📁 Detalii Componente

### Models (7 fișiere)

#### 1. Material.swift
```swift
@Model class Material
- id: UUID
- name: String
- category: String
- unit: String (buc, m, kg)
- unitPrice: Double
- dateCreated: Date
```

#### 2. LaborItem.swift
```swift
@Model class LaborItem
- id: UUID
- description: String
- unit: String (buc, m, forfet)
- rate: Double
- dateCreated: Date
```

#### 3. Invoice.swift
```swift
@Model class Invoice
- Informații client
- Materiale și manoperă (relationships)
- Calcule automate (TVA, discount, totaluri)
- Status plată
- Metoda recalculateTotals()
```

#### 4. InvoiceMaterialItem.swift & InvoiceLaborItem.swift
- Snapshot-uri ale materialelor/lucrărilor în facturi
- Prețurile sunt fixate la momentul creării facturii

#### 5. Client.swift
- Model pentru clienți (opțional, pentru extensii viitoare)

#### 6. CompanyProfile.swift
- Date companie
- Setări TVA și monedă
- Logo companie (Data?)

### ViewModels (4 fișiere)

#### MaterialsViewModel.swift
- Gestionează lista de materiale
- Filtrare după categorie
- Căutare după nume
- Adaugă date sample

#### LaborViewModel.swift
- Gestionează lista de lucrări
- Căutare după descriere
- Adaugă date sample

#### CalculatorViewModel.swift
- Gestionează selecția de materiale și manoperă
- Calcule în timp real
- Discount și TVA

#### InvoiceViewModel.swift
- Gestionează lista de facturi
- Filtrare după status
- Căutare după client/număr
- Generare număr factură auto-incrementat

### Views (13 fișiere)

#### ContentView.swift
TabView principal cu 5 tab-uri

#### Materials/ (2 views)
- **MaterialsListView:** Listă cu search și filtrare categorii
- **AddEditMaterialView:** Form pentru CRUD materiale

#### Labor/ (2 views)
- **LaborListView:** Listă cu search
- **AddEditLaborView:** Form pentru CRUD lucrări

#### Calculator/ (1 view)
- **CostCalculatorView:** Calculator interactiv cu steppers

#### Invoice/ (3 views)
- **InvoiceHistoryView:** Listă facturi cu filtrare
- **CreateInvoiceView:** Form complex pentru creare factură
- **InvoiceDetailView:** Vizualizare detalii și export PDF

#### Settings/ (1 view)
- **CompanyProfileView:** Editare profil companie cu PhotosPicker

### Services (1 fișier)

#### PDFGenerator.swift
- Generare PDF profesional A4
- Layout customizat
- Tabele pentru materiale și manoperă
- Footer cu totaluri

### Helpers (2 fișiere)

#### Constants.swift
- Categorii materiale
- Unități de măsură
- Monede
- Culori

#### Extensions.swift
- Double.toCurrency()
- Double.rounded()
- Date.formatted()
- Color(hex:)

## 🔄 Flow-uri Principale

### 1. Flow Creare Factură
```
InvoiceHistoryView 
  → [+] CreateInvoiceView
  → Selectare materiale/manoperă
  → Completare date client
  → Salvare Invoice
  → Redirect la InvoiceHistoryView
```

### 2. Flow Export PDF
```
InvoiceDetailView
  → "Generează PDF"
  → PDFGenerator.generateInvoicePDF()
  → Share Sheet
  → AirDrop/Email/Save
```

### 3. Flow Calculator
```
CostCalculatorView
  → Adaugă materiale
  → Adaugă manoperă
  → Ajustare cantități
  → Vezi totaluri în timp real
  → (Opțional) Folosește în CreateInvoiceView
```

## 📱 Caracteristici UI/UX

### Design Language
- **SF Symbols:** Icoane native iOS
- **SwiftUI:** Modern, declarativ
- **Culori semantice:** Suport Dark Mode automat
- **Liste native:** Swipe to delete, reorder

### Navigație
- **TabView:** 5 tab-uri principale
- **NavigationStack:** Pentru drill-down
- **Sheets:** Pentru forms și modals
- **Alerts:** Pentru confirmări

### Interactivitate
- **Pull to refresh:** (poate fi adăugat)
- **Swipe actions:** Ștergere items
- **Steppers:** Pentru cantități
- **Pickers:** Pentru categorii și unități
- **Toggle:** Pentru status factură
- **PhotosPicker:** Pentru logo companie

## 🔐 Securitate și Validări

### Validări Input
- ✅ Câmpuri obligatorii în forms
- ✅ Validare format numeric pentru prețuri
- ✅ Validare cantități > 0
- ✅ Disable butoane când form invalid

### Securitate Date
- ✅ Date stocate local pe device
- ✅ Nu există transmisie date externe
- ✅ Sandboxing iOS
- ✅ Backup prin iCloud (opțional)

## 📈 Extensii Posibile (Viitoare)

### Nivel 1 (Ușor)
- [ ] Filtru după dată în istoric facturi
- [ ] Export CSV pentru rapoarte
- [ ] Duplicate invoice
- [ ] Templates de facturi
- [ ] Multiple company profiles

### Nivel 2 (Mediu)
- [ ] Gestionare clienți (CRUD complet)
- [ ] Istoric prețuri materiale
- [ ] Statistici și rapoarte
- [ ] Backup/Restore manual
- [ ] Print direct (fără PDF)

### Nivel 3 (Avansat)
- [ ] iCloud sync între device-uri
- [ ] Widget iOS pentru quick stats
- [ ] Apple Watch companion app
- [ ] Siri shortcuts
- [ ] OCR pentru scanare facturi fizice

## 🐛 Troubleshooting Development

### Memory Management
- SwiftData gestionează automat
- `@Observable` pentru ViewModels
- Weak references în closures

### Performance
- Lazy loading pentru liste mari
- Pagination (poate fi adăugat)
- Image caching pentru logo

### Testing
- Unit tests pentru ViewModels
- UI tests pentru flow-uri critice
- Snapshot tests pentru views

## 📚 Resurse Suplimentare

### Documentație Apple
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [SwiftData Documentation](https://developer.apple.com/documentation/swiftdata)
- [PDFKit Documentation](https://developer.apple.com/documentation/pdfkit)

### Best Practices
- MVVM Architecture
- SwiftUI Composition
- Accessibility support
- Localization ready

---

**Versiune:** 1.0.0  
**Ultima actualizare:** Februarie 2024  
**iOS Target:** 17.0+  
**Swift Version:** 5.9+
