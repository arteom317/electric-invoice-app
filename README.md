# ⚡ ElectricBill Pro

Aplicație iOS completă în SwiftUI pentru inginerii electrici, care ușurează calcularea și crearea facturilor de lucru și materiale.

## 📱 Funcționalități

### 1. 📦 Catalog Materiale
- Bază de date cu materiale electrice comune (cabluri, prize, întrerupătoare, tablouri, etc.)
- Fiecare material are: nume, unitate de măsură (buc, m, kg), preț unitar, categorie
- Adăugare, editare și ștergere materiale
- Căutare și filtrare după categorie
- **31 materiale pre-populate** cu prețuri orientative în RON

### 2. 🛠️ Catalog Manoperă
- Tipuri de lucrări electrice comune
- Fiecare lucrare are: descriere, unitate de măsură, tarif per unitate
- Adăugare, editare și ștergere lucrări
- Căutare după descriere
- **10 tipuri de lucrări pre-populate** cu tarife orientative în RON

### 3. 🧮 Calculator Costuri
- Selectare materiale și manoperă din cataloguri
- Calcul automat subtotaluri și total
- Calcul TVA (19% implicit, configurabil)
- Aplicare discount (%)
- Actualizare dinamică a totalurilor

### 4. 🧾 Generator Facturi
- Creare factură profesională cu:
  - Date companie/emitent complete
  - Date client (nume/firmă, CUI opțional, adresă, telefon)
  - Număr factură (auto-incrementat)
  - Data emiterii
  - Tabel materiale și manoperă
  - Calcule complete: subtotaluri, TVA, total
  - Observații
- Export factură ca **PDF** folosind PDFKit
- Partajare PDF prin Share Sheet (email, AirDrop, etc.)

### 5. 📁 Istoric Facturi
- Lista tuturor facturilor create
- Filtrare după status (plătită/neplătită)
- Căutare după client sau număr factură
- Vizualizare detalii factură
- Marcare factură ca plătită/neplătită
- Ștergere factură
- Re-export PDF

### 6. 👤 Profil Companie / Setări
- Setări date companie emitentă:
  - Nume firmă, CUI, Nr. Registrul Comerțului
  - Adresă, Telefon, Email
  - Cont bancar (IBAN)
  - Logo companie (opțional)
- Setare procent TVA implicit (19%)
- Setare monedă (RON implicit, EUR opțional)

## 🛠️ Tehnologii

- **Swift 5.9+**
- **SwiftUI** pentru toată interfața
- **SwiftData** pentru persistența datelor
- **PDFKit** pentru generarea facturilor PDF
- **PhotosUI** pentru selectarea logo-ului companiei
- **Minimum iOS 17.0**

## 📂 Structura Proiectului

```
ElectricBillPro/
├── Package.swift                      # Swift Package Manager configuration
├── Sources/
│   ├── ElectricBillProApp.swift      # Entry point
│   ├── Models/
│   │   ├── Material.swift             # Model material
│   │   ├── LaborItem.swift            # Model lucrare/manoperă
│   │   ├── Invoice.swift              # Model factură
│   │   ├── InvoiceMaterialItem.swift  # Material în factură
│   │   ├── InvoiceLaborItem.swift     # Lucrare în factură
│   │   ├── Client.swift               # Model client
│   │   └── CompanyProfile.swift       # Model profil companie
│   ├── Views/
│   │   ├── ContentView.swift          # Tab bar principal
│   │   ├── Materials/
│   │   │   ├── MaterialsListView.swift
│   │   │   └── AddEditMaterialView.swift
│   │   ├── Labor/
│   │   │   ├── LaborListView.swift
│   │   │   └── AddEditLaborView.swift
│   │   ├── Invoice/
│   │   │   ├── CreateInvoiceView.swift
│   │   │   ├── InvoiceHistoryView.swift
│   │   │   └── InvoiceDetailView.swift
│   │   ├── Calculator/
│   │   │   └── CostCalculatorView.swift
│   │   └── Settings/
│   │       └── CompanyProfileView.swift
│   ├── ViewModels/
│   │   ├── MaterialsViewModel.swift
│   │   ├── LaborViewModel.swift
│   │   ├── InvoiceViewModel.swift
│   │   └── CalculatorViewModel.swift
│   ├── Services/
│   │   └── PDFGenerator.swift         # Generare facturi PDF
│   └── Helpers/
│       ├── Extensions.swift
│       └── Constants.swift
```

## 🚀 Instrucțiuni de Build

### Cerințe
- macOS 13.0 sau mai nou
- Xcode 15.0 sau mai nou
- iOS 17.0+ (simulator sau device)

### Compilare

1. **Clonează repository-ul:**
```bash
git clone https://github.com/arteom317/electric-invoice-app.git
cd electric-invoice-app
```

2. **Creează un proiect Xcode nou:**
   - Deschide Xcode
   - File → New → Project
   - Selectează "iOS" → "App"
   - Product Name: "ElectricBillPro"
   - Interface: SwiftUI
   - Language: Swift
   - Storage: SwiftData
   - Minimum Deployment: iOS 17.0

3. **Copiază fișierele:**
   - Copiază toate fișierele din directorul `Sources/` în proiectul Xcode

4. **Configurare suplimentară:**
   - În Project Settings → Target → Info
   - Adaugă următoarele permisiuni dacă este necesar:
     - Photo Library Usage Description: "Pentru a selecta logo-ul companiei"

5. **Build și Run:**
   - Selectează un simulator sau device iOS 17.0+
   - Apasă ⌘R pentru a compila și rula aplicația

### Alternativ: Build cu Swift Package Manager

```bash
swift build
```

## 🎨 Design

- **Culoare principală:** Albastru electric (#0066CC)
- **Interfață:** Modernă, curată, profesională
- **Dark Mode:** Complet suportat
- **Limbă:** Română
- **Icoane:** SF Symbols

## 📱 Navigare

Aplicația folosește un TabView cu 5 tab-uri:
1. **Materiale** (📦) - Catalog materiale electrice
2. **Manoperă** (🔧) - Catalog lucrări
3. **Calculator** (➕➖) - Calculator costuri
4. **Facturi** (📄) - Istoric facturi
5. **Setări** (⚙️) - Profil companie

## 💾 Date Pre-populate

La prima rulare, aplicația populează automat:

### Materiale (31 articole):
- **Cabluri:** NYM 3x2.5, NYM 3x1.5, FY 2.5, FY 1.5, CYY 3x2.5
- **Prize:** Simple, duble, Schuko
- **Întrerupătoare:** Simple, duble, cap scară, cruce
- **Tablouri:** 4, 8, 12, 24 module
- **Siguranțe:** 10A, 16A, 20A, 25A, 32A
- **Disjunctoare:** 30mA, 300mA
- **Tuburi PVC:** 16mm, 20mm, 25mm
- **Doze:** Simple, derivație
- **Accesorii:** Cleme, șuruburi, dibluri

### Lucrări (10 tipuri):
- Montaj priză/întrerupător
- Tragere cablu
- Montaj tablou electric
- Montaj siguranță/disjunctor
- Montare tub PVC/doză
- Ștemuit canal
- Verificare și testare instalație

## 📄 Generare PDF

Facturile generate includ:
- **Header:** Date companie și logo (opțional)
- **Detalii factură:** Număr, dată
- **Date client:** Nume, CUI, adresă, telefon
- **Tabel materiale:** Detaliat cu prețuri
- **Tabel manoperă:** Detaliat cu tarife
- **Footer:** Subtotaluri, TVA, total final
- **Observații:** Note adiționale
- **Format:** A4 standard

## 🔐 Persistență Date

Toate datele sunt stocate local folosind **SwiftData**:
- Materiale și lucrări sunt persistente
- Facturile sunt salvate automat
- Profilul companiei este stocat persistent
- Nu există sincronizare cloud (datele rămân pe device)

## 📝 Licență

Copyright © 2024 ElectricBill Pro. Toate drepturile rezervate.

## 👨‍💻 Autor

Creat pentru inginerii electrici care au nevoie de un instrument rapid și profesional pentru calcularea și emiterea facturilor.

---

**Notă:** Această aplicație este concepută pentru iOS și necesită un Mac cu Xcode pentru compilare și testare.
