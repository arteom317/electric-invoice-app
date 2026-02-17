# Configurare Proiect Xcode - ElectricBill Pro

## 📋 Checklist Configurare

Urmărește acești pași pentru a configura corect proiectul în Xcode:

### 1. ⚙️ General Settings

**Project Navigator → Project → General Tab:**

- [ ] **Display Name:** ElectricBill Pro
- [ ] **Bundle Identifier:** com.yourcompany.ElectricBillPro
- [ ] **Version:** 1.0
- [ ] **Build:** 1
- [ ] **Minimum Deployments:** iOS 17.0
- [ ] **Supported Destinations:** iPhone, iPad
- [ ] **Device Orientation:**
  - ✅ Portrait
  - ✅ Landscape Left
  - ✅ Landscape Right
  - ⬜ Upside Down (opțional)

### 2. 🔐 Signing & Capabilities

**Project Navigator → Target → Signing & Capabilities:**

- [ ] **Automatically manage signing:** ✅ Enabled
- [ ] **Team:** Selectează team-ul tău Apple Developer
- [ ] **Bundle Identifier:** Verifică că e unic

**Capabilities (Opțional pentru viitor):**
- [ ] iCloud (pentru sync între device-uri)
  - Key-Value Storage
  - CloudKit
- [ ] Background Modes (pentru auto-save)

### 3. 📱 Info.plist Configuration

Adaugă sau verifică următoarele keys în Info.plist:

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>ElectricBill Pro are nevoie de acces la galeria foto pentru a selecta logo-ul companiei.</string>

<key>UIUserInterfaceStyle</key>
<string>Automatic</string>

<key>CFBundleDisplayName</key>
<string>ElectricBill Pro</string>
```

### 4. 🎨 Asset Catalog

**Assets.xcassets:**

1. **AppIcon:**
   - Creează sau importă icon-ul aplicației
   - Dimensiuni necesare: 1024x1024 (App Store)
   - Tip recomandat: PNG fără transparență
   - Tema: Electric blue (#0066CC) sau iconuri electrice

2. **AccentColor:**
   - Setează culoarea principală: #0066CC (Electric Blue)
   - Any Appearance: RGB(0, 102, 204)
   - Dark Appearance: Same sau variație mai luminoasă

3. **LaunchImage (Opțional):**
   - Imagine pentru splash screen
   - Poate fi logo-ul aplicației

### 5. 🏗️ Build Settings

**Project Navigator → Target → Build Settings:**

Verifică următoarele setări:

- [ ] **Swift Language Version:** Swift 5
- [ ] **iOS Deployment Target:** 17.0
- [ ] **Build Active Architecture Only:**
  - Debug: YES
  - Release: NO
- [ ] **Optimization Level:**
  - Debug: None [-Onone]
  - Release: Optimize for Speed [-O]

### 6. 📦 Frameworks și Libraries

Verifică că sunt incluse (auto-incluse de Xcode):

- [ ] SwiftUI.framework
- [ ] SwiftData.framework
- [ ] PDFKit.framework
- [ ] PhotosUI.framework
- [ ] Foundation.framework
- [ ] UIKit.framework

### 7. 🗂️ File Organization

Organizează fișierele în Xcode astfel:

```
ElectricBillPro
├── 📄 ElectricBillProApp.swift
├── 📁 Models/
│   ├── Material.swift
│   ├── LaborItem.swift
│   ├── Invoice.swift
│   ├── InvoiceMaterialItem.swift
│   ├── InvoiceLaborItem.swift
│   ├── Client.swift
│   └── CompanyProfile.swift
├── 📁 Views/
│   ├── ContentView.swift
│   ├── 📁 Materials/
│   │   ├── MaterialsListView.swift
│   │   └── AddEditMaterialView.swift
│   ├── 📁 Labor/
│   │   ├── LaborListView.swift
│   │   └── AddEditLaborView.swift
│   ├── 📁 Invoice/
│   │   ├── CreateInvoiceView.swift
│   │   ├── InvoiceHistoryView.swift
│   │   └── InvoiceDetailView.swift
│   ├── 📁 Calculator/
│   │   └── CostCalculatorView.swift
│   └── 📁 Settings/
│       └── CompanyProfileView.swift
├── 📁 ViewModels/
│   ├── MaterialsViewModel.swift
│   ├── LaborViewModel.swift
│   ├── InvoiceViewModel.swift
│   └── CalculatorViewModel.swift
├── 📁 Services/
│   └── PDFGenerator.swift
├── 📁 Helpers/
│   ├── Extensions.swift
│   └── Constants.swift
└── 📁 Assets.xcassets/
    ├── AppIcon
    ├── AccentColor
    └── (other assets)
```

### 8. 🧪 Scheme Configuration

**Product → Scheme → Edit Scheme:**

**Run:**
- [ ] Build Configuration: Debug
- [ ] Executable: ElectricBillPro.app

**Test:**
- [ ] Build Configuration: Debug

**Archive:**
- [ ] Build Configuration: Release

### 9. ✅ Pre-Build Checklist

Înainte de prima compilare, verifică:

- [ ] Toate fișierele .swift au target membership către ElectricBillPro
- [ ] Nu există fișiere duplicate
- [ ] Info.plist este configurat corect
- [ ] Bundle Identifier este unic
- [ ] Team de signing este selectat
- [ ] Simulator sau device iOS 17.0+ este selectat

### 10. 🚀 First Build

1. Selectează destinația (Simulator sau Device)
2. Apasă ⌘B pentru build sau ⌘R pentru build & run
3. Verifică că nu există erori de compilare
4. Testează funcționalitățile principale

### 11. 📊 Verificări Post-Build

După prima compilare reușită:

- [ ] Aplicația se deschide fără crash
- [ ] Toate cele 5 tab-uri sunt vizibile
- [ ] Datele sample se încarcă automat
- [ ] Poți naviga între ecrane
- [ ] Poți adăuga materiale/lucrări noi
- [ ] Poți crea facturi
- [ ] Export PDF funcționează

## 🎯 Optimizări Opționale

### Pentru Development
- Enable "Show build time in toolbar"
- Enable "Parallel builds"
- Reduce simulator device count

### Pentru Production
- Add proper App Icon
- Configure proper Bundle ID
- Set up proper signing certificates
- Add privacy policy (dacă publici pe App Store)

## 📝 Notes

- **Xcode Version:** Minimum 15.0
- **macOS Version:** Minimum 13.0 (Ventura)
- **Swift Version:** 5.9+
- **iOS Target:** 17.0+

## ⚠️ Troubleshooting

### Build Failed - SwiftData not found
**Soluție:** Verifică iOS Deployment Target >= 17.0

### Signing Error
**Soluție:** Adaugă Apple ID în Xcode → Settings → Accounts

### Simulator not available
**Soluție:** Xcode → Settings → Platforms → Download iOS 17.0+ Simulator

### Files not found
**Soluție:** Verifică că toate fișierele au correct target membership

## 🔄 Update Strategy

Când actualizezi codul:
1. Fă backup la proiectul curent
2. Commit changes în Git
3. Build și test după fiecare update major
4. Verifică că datele existente nu sunt corupte

---

**Success!** 🎉 După configurare, aplicația ar trebui să funcționeze perfect!
