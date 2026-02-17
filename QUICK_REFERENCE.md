# 📱 ElectricBill Pro - Quick Reference Card

## 🎯 One-Line Summary
**Complete iOS invoice management app for electrical engineers with materials catalog, labor tracking, cost calculator, and professional PDF invoice generation.**

## 📊 By The Numbers

| Metric | Value |
|--------|-------|
| Swift Files | 25 |
| Lines of Code | ~2,300 |
| Models | 7 |
| Views | 13 |
| ViewModels | 4 |
| Services | 1 |
| Pre-loaded Materials | 31 |
| Pre-loaded Labor Items | 10 |
| Material Categories | 9 |
| Documentation Files | 5 |
| iOS Target | 17.0+ |
| Swift Version | 5.9+ |

## 🏗️ Architecture

```
┌─────────────────────────────────────────┐
│          ElectricBillProApp             │
│              (Entry Point)              │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│           ContentView                    │
│            (TabView)                     │
└──────┬──────┬──────┬──────┬─────────────┘
       │      │      │      │      │
       ▼      ▼      ▼      ▼      ▼
    ┌───┐  ┌───┐  ┌───┐  ┌───┐  ┌───┐
    │ 📦 │  │ 🔧 │  │ ➕ │  │ 📄 │  │ ⚙️ │
    └───┘  └───┘  └───┘  └───┘  └───┘
  Materials Labor Calc Invoice Settings
```

## 🗂️ File Structure Quick Map

```
ElectricBillPro/
├── 📦 Package.swift          # SPM config
├── 📄 Info.plist             # App metadata
├── 📚 Documentation/
│   ├── README.md             # Main docs
│   ├── SETUP_GUIDE.md        # Setup steps
│   ├── TECHNICAL_DOCUMENTATION.md
│   ├── XCODE_CONFIGURATION.md
│   └── PROJECT_SUMMARY.md
└── 💻 Sources/
    ├── 🚀 ElectricBillProApp.swift
    ├── 📊 Models/ (7 files)
    │   ├── Material, LaborItem, Invoice
    │   ├── InvoiceMaterialItem, InvoiceLaborItem
    │   ├── Client, CompanyProfile
    ├── 🎨 Views/ (13 files)
    │   ├── ContentView
    │   ├── Materials/ (2)
    │   ├── Labor/ (2)
    │   ├── Calculator/ (1)
    │   ├── Invoice/ (3)
    │   └── Settings/ (1)
    ├── 🧠 ViewModels/ (4 files)
    │   ├── MaterialsViewModel
    │   ├── LaborViewModel
    │   ├── CalculatorViewModel
    │   └── InvoiceViewModel
    ├── ⚙️ Services/ (1 file)
    │   └── PDFGenerator
    └── 🛠️ Helpers/ (2 files)
        ├── Constants
        └── Extensions
```

## 🎨 UI Components Map

```
TabView (5 tabs)
├── Tab 1: Materials 📦
│   ├── MaterialsListView
│   │   ├── Search bar
│   │   ├── Category filter (horizontal scroll)
│   │   ├── Materials list
│   │   └── + button → AddEditMaterialView
│   └── AddEditMaterialView (sheet)
│       └── Form: name, category, unit, price
│
├── Tab 2: Labor 🔧
│   ├── LaborListView
│   │   ├── Search bar
│   │   ├── Labor items list
│   │   └── + button → AddEditLaborView
│   └── AddEditLaborView (sheet)
│       └── Form: description, unit, rate
│
├── Tab 3: Calculator ➕➖
│   └── CostCalculatorView
│       ├── Materials section
│       │   ├── Selected materials with steppers
│       │   ├── + Add material → MaterialPicker
│       │   └── Subtotal
│       ├── Labor section
│       │   ├── Selected labor with steppers
│       │   ├── + Add labor → LaborPicker
│       │   └── Subtotal
│       ├── Discount & VAT section
│       └── Totals section
│
├── Tab 4: Invoices 📄
│   ├── InvoiceHistoryView
│   │   ├── Search bar
│   │   ├── Status filter (segmented)
│   │   ├── Invoices list
│   │   ├── + button → CreateInvoiceView
│   │   └── Tap invoice → InvoiceDetailView
│   ├── CreateInvoiceView (sheet)
│   │   └── Form: invoice data, client, materials, labor, notes
│   └── InvoiceDetailView (sheet)
│       ├── All invoice details
│       ├── Toggle paid/unpaid
│       └── Generate & Share PDF button
│
└── Tab 5: Settings ⚙️
    └── CompanyProfileView
        └── Form: company data, logo, VAT, currency
```

## 🔄 Data Flow

```
User Action → View → ViewModel → SwiftData
                ↓         ↓
              UI Update ← Data Change
```

## 📱 Screen Flow Examples

### Creating an Invoice
```
1. Tap "Facturi" tab
2. Tap "+" button
3. Fill invoice number (auto-generated)
4. Enter client details
5. Tap "Adaugă Material" → Select material → Set quantity
6. Tap "Adaugă Manoperă" → Select labor → Set quantity
7. (Optional) Add discount
8. Review totals
9. Add notes
10. Tap "Salvează"
```

### Exporting PDF
```
1. Open invoice from history
2. Tap "Generează și Partajează PDF"
3. Choose sharing option:
   - AirDrop
   - Email
   - Messages
   - Save to Files
   - More...
```

## 🎯 Key Features Checklist

### Materials Management ✅
- [x] List with 31 pre-loaded items
- [x] Search functionality
- [x] Category filtering (9 categories)
- [x] Add/Edit/Delete operations
- [x] Price in RON

### Labor Management ✅
- [x] List with 10 pre-loaded items
- [x] Search functionality
- [x] Add/Edit/Delete operations
- [x] Rate in RON

### Cost Calculator ✅
- [x] Select multiple materials
- [x] Select multiple labor items
- [x] Adjust quantities with stepper
- [x] Apply discount (%)
- [x] Calculate VAT (configurable)
- [x] Real-time total updates

### Invoice Generator ✅
- [x] Auto-increment invoice numbers
- [x] Client information
- [x] Materials table
- [x] Labor table
- [x] Discount and VAT
- [x] Notes/observations
- [x] Professional PDF export
- [x] Share functionality

### Invoice History ✅
- [x] List all invoices
- [x] Search by client/number
- [x] Filter by status
- [x] View details
- [x] Toggle paid/unpaid
- [x] Delete invoices
- [x] Re-export PDF

### Company Settings ✅
- [x] Full company profile
- [x] Logo upload
- [x] VAT configuration
- [x] Currency selection
- [x] Persistent storage

## 🚀 Quick Start Commands

```bash
# Clone repository
git clone https://github.com/arteom317/electric-invoice-app.git
cd electric-invoice-app

# View structure
tree -L 2 Sources/

# Count lines
find Sources -name "*.swift" | xargs wc -l

# Open in Xcode (after creating project)
open ElectricBillPro.xcodeproj
```

## 📝 Most Important Files

| File | Purpose | Lines |
|------|---------|-------|
| ElectricBillProApp.swift | App entry, SwiftData setup | 25 |
| ContentView.swift | Main tab bar | 35 |
| MaterialsListView.swift | Materials catalog UI | 140 |
| CreateInvoiceView.swift | Invoice creation | 240 |
| InvoiceDetailView.swift | Invoice view & PDF | 190 |
| PDFGenerator.swift | PDF generation logic | 240 |
| Invoice.swift | Invoice model & calculations | 70 |
| MaterialsViewModel.swift | Materials business logic | 100 |

## 🎨 Color Scheme

| Element | Light Mode | Dark Mode |
|---------|-----------|-----------|
| Primary | #0066CC (Electric Blue) | #0066CC |
| Background | White | Black |
| Text | Black | White |
| Secondary | Gray | Light Gray |
| Success | Green | Light Green |
| Warning | Orange | Light Orange |

## 💡 Pro Tips

1. **First Run:** App auto-loads 31 materials and 10 labor items
2. **Company Setup:** Configure company profile first for better PDFs
3. **Material Categories:** Use filters for quick access
4. **Calculator:** Great for quick estimates without creating invoices
5. **PDF Quality:** Logo makes PDFs look more professional
6. **Backup:** All data is local, use iCloud backup
7. **Customization:** Adjust prices to match your market
8. **Dark Mode:** Automatically follows system settings

## 🔗 Quick Links

- **Main Documentation:** README.md
- **Setup Guide:** SETUP_GUIDE.md
- **Technical Docs:** TECHNICAL_DOCUMENTATION.md
- **Xcode Config:** XCODE_CONFIGURATION.md
- **Full Summary:** PROJECT_SUMMARY.md

## 📞 Support

For issues or questions:
1. Check documentation files
2. Review Xcode configuration
3. Verify iOS version (17.0+)
4. Create GitHub issue

---

**Version:** 1.0.0  
**Status:** ✅ Production Ready  
**Last Update:** February 2024
