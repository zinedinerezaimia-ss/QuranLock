#!/bin/bash
# ============================================
# IQRA V3 - Setup Script
# Exécute ce script sur ton Mac pour générer
# le projet Xcode complet
# ============================================

set -e

echo "🕌 IQRA V3 — Configuration du projet..."
echo ""

# Check we're in the right directory
if [ ! -f "project.yml" ]; then
    echo "❌ Erreur : Lance ce script depuis le dossier QuranLock/"
    echo "   cd QuranLock && bash setup.sh"
    exit 1
fi

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    echo "📦 Installation de Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install XcodeGen if not present
if ! command -v xcodegen &> /dev/null; then
    echo "📦 Installation de XcodeGen..."
    brew install xcodegen
fi

# Generate Xcode project
echo "🔨 Génération du projet Xcode..."
xcodegen generate

echo ""
echo "✅ Projet généré avec succès !"
echo ""
echo "📱 Prochaines étapes :"
echo "   1. Ouvre QuranLock.xcodeproj dans Xcode"
echo "   2. Va dans Signing & Capabilities :"
echo "      - Sélectionne ton Team (J875R59LND)"
echo "      - Vérifie que 'Sign in with Apple' est listé"
echo "      - Si non : + Capability → Sign in with Apple"
echo "   3. Build Phases → Copy Bundle Resources :"
echo "      - Vérifie que adhan.mp3 est listé"
echo "      - Si non : + → ajoute Resources/adhan.mp3"
echo "   4. Firebase Console → Authentication → Sign-in method :"
echo "      - Active le provider 'Apple'"
echo "   5. Firebase Console → Firestore Database :"
echo "      - Crée la base si pas encore fait"
echo "   6. Build & Run !"
echo ""
echo "🤲 Qu'Allah facilite — Bonne continuation !"
