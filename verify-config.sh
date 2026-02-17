#!/bin/bash

# Script pentru verificarea configurației Xcode project
# Acest script verifică că toate setările pentru SwiftData sunt corecte

echo "🔍 Verificare configurație ElectricBill Pro..."
echo ""

PROJECT_FILE="ElectricBillPro.xcodeproj/project.pbxproj"

if [ ! -f "$PROJECT_FILE" ]; then
    echo "❌ Eroare: Nu am găsit fișierul $PROJECT_FILE"
    exit 1
fi

echo "✅ Fișier proiect găsit: $PROJECT_FILE"
echo ""

# Verifică iOS Deployment Target
echo "📱 Verificare iOS Deployment Target..."
DEPLOYMENT_TARGET=$(grep "IPHONEOS_DEPLOYMENT_TARGET" "$PROJECT_FILE" | head -n 1)
if echo "$DEPLOYMENT_TARGET" | grep -q "17.0"; then
    echo "✅ iOS Deployment Target: 17.0 (CORECT)"
else
    echo "❌ iOS Deployment Target: NU este setat la 17.0"
    exit 1
fi
echo ""

# Verifică platformele suportate
echo "🖥️  Verificare platforme suportate..."
SUPPORTED_PLATFORMS=$(grep "SUPPORTED_PLATFORMS" "$PROJECT_FILE" | head -n 1)
if echo "$SUPPORTED_PLATFORMS" | grep -q "iphoneos iphonesimulator"; then
    echo "✅ Supported Platforms: iphoneos iphonesimulator (CORECT)"
else
    echo "❌ Supported Platforms: NU este setat corect"
    exit 1
fi
echo ""

# Verifică suportul Mac Catalyst
echo "🍎 Verificare suport macOS..."
MAC_CATALYST=$(grep "SUPPORTS_MACCATALYST" "$PROJECT_FILE" | head -n 1)
if echo "$MAC_CATALYST" | grep -q "NO"; then
    echo "✅ Mac Catalyst: Dezactivat (CORECT)"
else
    echo "⚠️  Mac Catalyst: Nu este dezactivat explicit"
fi

MAC_DESIGNED=$(grep "SUPPORTS_MAC_DESIGNED_FOR_IPHONE_IPAD" "$PROJECT_FILE" | head -n 1)
if echo "$MAC_DESIGNED" | grep -q "NO"; then
    echo "✅ Mac Designed for iPad: Dezactivat (CORECT)"
else
    echo "⚠️  Mac Designed for iPad: Nu este dezactivat explicit"
fi
echo ""

# Verifică Package.swift
echo "📦 Verificare Package.swift..."
if [ -f "Package.swift" ]; then
    if grep -q ".iOS(.v17)" "Package.swift"; then
        echo "✅ Package.swift: iOS 17 platform specificată (CORECT)"
    else
        echo "⚠️  Package.swift: iOS 17 platform nu este specificată"
    fi
else
    echo "⚠️  Package.swift nu există"
fi
echo ""

# Verifică @available în modele
echo "🔖 Verificare @available annotations în modele..."
INVOICE_MODEL="Sources/Models/Invoice/Invoice.swift"
MATERIAL_MODEL="Sources/Models/Invoice/InvoiceMaterialItem.swift"

if [ -f "$INVOICE_MODEL" ]; then
    if grep -q "@available(iOS 17.0" "$INVOICE_MODEL"; then
        echo "✅ Invoice.swift: @available annotation prezentă (CORECT)"
    else
        echo "❌ Invoice.swift: @available annotation lipsă"
        exit 1
    fi
else
    echo "❌ Invoice.swift nu există"
    exit 1
fi

if [ -f "$MATERIAL_MODEL" ]; then
    if grep -q "@available(iOS 17.0" "$MATERIAL_MODEL"; then
        echo "✅ InvoiceMaterialItem.swift: @available annotation prezentă (CORECT)"
    else
        echo "❌ InvoiceMaterialItem.swift: @available annotation lipsă"
        exit 1
    fi
else
    echo "❌ InvoiceMaterialItem.swift nu există"
    exit 1
fi
echo ""

echo "=========================================="
echo "✅ TOATE VERIFICĂRILE AU FOST TRECUTE!"
echo "=========================================="
echo ""
echo "Proiectul este configurat corect pentru SwiftData cu iOS 17.0+"
echo "Nu ar trebui să mai existe erori de compilare legate de disponibilitate API."
echo ""
echo "Pentru a compila:"
echo "  1. Deschide ElectricBillPro.xcodeproj în Xcode"
echo "  2. Selectează un simulator iOS 17.0+ sau device"
echo "  3. Build (⌘B)"
echo ""
