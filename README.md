# IQRA V3 — App Islamique Complète

## 🚀 Installation sur Mac (3 étapes)

### Étape 1 : Dézipper et ouvrir le Terminal
```
# Dézippe le fichier IQRA_V3.zip sur ton bureau
# Ouvre Terminal et tape :
cd ~/Desktop/QuranLock
```

### Étape 2 : Lancer le setup
```
bash setup.sh
```
Ce script installe XcodeGen (si besoin) et génère le projet Xcode.

### Étape 3 : Ouvrir dans Xcode
```
open QuranLock.xcodeproj
```

## ⚙️ Configuration dans Xcode

1. **Signing & Capabilities** :
   - Target QuranLock → Signing & Capabilities
   - Team : ZETA Entreprise (J875R59LND)
   - En mode **Debug** : Automatic signing
   - Vérifie que "Sign in with Apple" apparaît dans les capabilities
   - Si absent : + Capability → Sign in with Apple

2. **Vérifier le fichier adhan.mp3** :
   - Build Phases → Copy Bundle Resources
   - Vérifie que `adhan.mp3` est listé
   - Si non : clique + → ajoute `Resources/adhan.mp3`

3. **Firebase Console** (console.firebase.google.com) :
   - Authentication → Sign-in method → Active "Apple"
   - Firestore Database → Crée la base si pas fait
   - Ajoute les collections : `mosques`, `donations`

4. **Build** : Cmd+B puis Cmd+R

## 📱 Fonctionnalités V3

- ✅ Sign in with Apple (erreur 1000 corrigée)
- ✅ Communauté Firebase (posts, likes, réponses)
- ✅ 28 lettres arabes complètes + voyelles + tajwid
- ✅ 90 questions de quiz (facile/moyen/difficile)
- ✅ Horaires de prière via API Aladhan (méthode UOIF)
- ✅ Adhan personnalisé pour les notifications
- ✅ Système de dons mosquée (IBAN/BIC)
- ✅ Inscription de mosquées via Firebase
- ✅ 3 langues complètes (FR/EN/AR avec RTL)
- ✅ Guide de prière étape par étape
- ✅ Partage duaas/enseignements/posts
- ✅ Enseignements islamiques complets
