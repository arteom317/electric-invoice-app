# 🚀 Ghid Rapid de Setup - ElectricBill Pro

## Opțiuni pentru Compilare

### Opțiunea 1: Creare Proiect Xcode Nou (Recomandat)

1. **Deschide Xcode** (versiune 15.0+)

2. **Creează un proiect nou:**
   - File → New → Project
   - Selectează **iOS** → **App**
   - Configurare:
     - Product Name: `ElectricBillPro`
     - Team: Alege-ți team-ul de dezvoltare
     - Organization Identifier: `com.yourcompany` (sau ID-ul tău)
     - Interface: **SwiftUI**
     - Language: **Swift**
     - Storage: **SwiftData**
     - Include Tests: Da (opțional)
     - Minimum Deployment: **iOS 17.0**

3. **Adaugă fișierele surse:**
   - Șterge fișierele generate automat (ContentView.swift, etc.)
   - Trage directorul `Sources/` în proiectul Xcode
   - Asigură-te că "Copy items if needed" este bifat
   - "Create groups" trebuie selectat
   - Target-ul "ElectricBillPro" trebuie bifat

4. **Build și Run:**
   - Selectează un simulator sau device (iOS 17.0+)
   - Apasă ⌘R sau click pe butonul Run

### Opțiunea 2: Import Swift Package

1. **Deschide Xcode** și creează un proiect gol
2. File → Add Package Dependencies
3. Adaugă repository-ul Git local sau remote
4. Xcode va detecta automat `Package.swift`

### Opțiunea 3: Utilizare Command Line (Advanced)

```bash
# Asigură-te că ai Xcode Command Line Tools instalat
xcode-select --install

# Navighează la directorul proiectului
cd electric-invoice-app

# Build cu Swift Package Manager
swift build

# Pentru a crea un Xcode project din Package.swift
swift package generate-xcodeproj
```

## 📱 Testare pe Device Real

1. **Conectează iPhone-ul/iPad-ul** (iOS 17.0+)
2. În Xcode, selectează device-ul din lista de device-uri
3. Dacă este prima dată:
   - Xcode → Settings → Accounts → Adaugă Apple ID
   - Selectează Team-ul în Project Settings → Signing & Capabilities
   - Enable "Automatically manage signing"
4. Build și Run (⌘R)

## 🐛 Troubleshooting Comun

### Eroare: "Minimum deployment target"
- Asigură-te că iOS Deployment Target este setat la 17.0 sau mai mare
- Project Settings → General → Minimum Deployments → iOS 17.0

### Eroare: "SwiftData not found"
- Asigură-te că folosești Xcode 15.0+ și iOS 17.0+
- SwiftData este disponibil doar din iOS 17.0

### Eroare: "Code Signing"
- Adaugă un Apple ID în Xcode → Settings → Accounts
- Selectează Team-ul corect în Project Settings
- Enable "Automatically manage signing"

### Build-ul durează mult
- Este normal la prima compilare
- Compilările ulterioare vor fi mai rapide datorită cache-ului

## 📂 Structura După Import

După importul fișierelor, structura proiectului în Xcode va arăta astfel:

```
ElectricBillPro
├── ElectricBillProApp.swift
├── Models/
│   ├── Material.swift
│   ├── LaborItem.swift
│   ├── Invoice.swift
│   ├── InvoiceMaterialItem.swift
│   ├── InvoiceLaborItem.swift
│   ├── Client.swift
│   └── CompanyProfile.swift
├── Views/
│   ├── ContentView.swift
│   ├── Materials/
│   ├── Labor/
│   ├── Invoice/
│   ├── Calculator/
│   └── Settings/
├── ViewModels/
├── Services/
└── Helpers/
```

## ✅ Verificare Finală

După build, aplicația ar trebui să:
- ✅ Se deschidă cu un TabView cu 5 tab-uri
- ✅ Tab-ul "Materiale" să arate 31 materiale pre-populate
- ✅ Tab-ul "Manoperă" să arate 10 lucrări pre-populate
- ✅ Calculator-ul să permită adăugarea de materiale și manoperă
- ✅ Să poți crea facturi noi
- ✅ Să poți exporta PDF-uri
- ✅ Să poți edita profilul companiei

## 🎯 Pași Următori

1. **Configurează profilul companiei:**
   - Mergi la tab-ul "Setări"
   - Completează datele companiei tale
   - Adaugă un logo (opțional)
   - Salvează setările

2. **Adaugă materiale și lucrări suplimentare:**
   - Personalizează catalogurile cu prețurile tale
   - Adaugă materiale specifice

3. **Creează prima factură:**
   - Mergi la tab-ul "Facturi"
   - Apasă "+" pentru a crea o factură nouă
   - Adaugă materiale și manoperă
   - Completează datele clientului
   - Salvează și exportă PDF

## 💡 Tips

- **Dark Mode:** Aplicația suportă automat Dark Mode
- **Persistent Data:** Toate datele sunt salvate automat pe device
- **PDF Export:** PDF-urile pot fi partajate prin AirDrop, Email, etc.
- **Customization:** Poți modifica prețurile și adăuga materiale noi oricând

## 📞 Suport

Pentru probleme sau întrebări:
- Verifică README.md principal pentru detalii complete
- Caută în Issues pe GitHub
- Creează un Issue nou dacă problema persistă

---

**Notă:** Această aplicație necesită macOS cu Xcode pentru compilare. Nu poate fi compilată pe Windows sau Linux.
