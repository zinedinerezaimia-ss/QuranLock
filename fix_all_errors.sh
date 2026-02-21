#!/bin/bash
# Lancer depuis : ~/OneDrive/Bureau/IQRA_PROJECT/IQRA APP/QuranLock
# bash fix_all_errors.sh

echo "🔧 Correction des erreurs de build..."

# 1. Supprimer les fichiers qui créent des doublons
echo "🗑️  Suppression des fichiers en doublon..."

git rm -f "QuranLock/App/QuranData.swift" 2>/dev/null && echo "✅ Supprimé QuranData.swift" || echo "⚠️  QuranData.swift pas trouvé (ok)"
git rm -f "QuranLock/App/QuranService.swift" 2>/dev/null && echo "✅ Supprimé QuranService.swift" || echo "⚠️  QuranService.swift pas trouvé (ok)"  
git rm -f "QuranLock/App/ColorExtension.swift" 2>/dev/null && echo "✅ Supprimé ColorExtension.swift" || echo "⚠️  ColorExtension.swift pas trouvé (ok)"

# 2. Copier les fichiers corrigés (doivent être dans le dossier courant)
echo ""
echo "📁 Application des corrections..."

if [ -f "QuranLockApp_fixed.swift" ]; then
    cp "QuranLockApp_fixed.swift" "QuranLock/App/QuranLockApp.swift"
    git add "QuranLock/App/QuranLockApp.swift"
    echo "✅ QuranLockApp.swift corrigé"
else
    echo "❌ QuranLockApp_fixed.swift manquant !"
fi

if [ -f "QuranReadingView_fixed.swift" ]; then
    cp "QuranReadingView_fixed.swift" "QuranLock/Views/QuranReadingView.swift"
    git add "QuranLock/Views/QuranReadingView.swift"
    echo "✅ QuranReadingView.swift corrigé"
else
    echo "❌ QuranReadingView_fixed.swift manquant !"
fi

echo ""
echo "📝 Commit..."
git commit -m "fix: supprime doublons QuranData/QuranService/ColorExtension, corrige QuranLockApp + QuranReadingView"

echo ""
echo "🚀 Push..."
git push origin main

echo ""
echo "✨ Done! Vérifie GitHub Actions pour le résultat du build."
