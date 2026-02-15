# 🚀 Guide de Déploiement QuranLock — Depuis Windows

## Vue d'ensemble
Ce guide te permet de déployer QuranLock sur l'App Store 
sans jamais toucher un Mac. Tout se fait depuis ton navigateur.

---

## ÉTAPE 1 — Créer le repo GitHub (2 min)

1. Va sur **github.com** → connecte-toi
2. Clique **"+"** → **"New repository"**
3. Nom : `QuranLock` | Visibilité : **Private** | Coche "Add a README"
4. Clique **"Create repository"**

---

## ÉTAPE 2 — Uploader les fichiers (5 min)

1. Télécharge le zip **QuranLock_GitHub_Deploy.zip**
2. **Dézippe-le** sur ton PC
3. Sur GitHub, dans ton repo, clique **"Add file"** → **"Upload files"**
4. **Drag & drop** TOUT le contenu du dossier `QuranLockDeploy/` 
   (pas le dossier lui-même, mais tout ce qu'il y a dedans)
   
   Tu dois voir ces éléments :
   - `.github/` (dossier)
   - `fastlane/` (dossier)
   - `QuranLock/` (dossier)
   - `QuranLock.xcodeproj/` (dossier)
   - `.gitignore`
   - `Gemfile`
   - `README.md`

5. Message de commit : "Initial QuranLock V4"
6. Clique **"Commit changes"**

⚠️ IMPORTANT : Le dossier `.github` est un dossier caché. 
Sur Windows, active "Afficher les éléments masqués" dans 
l'explorateur de fichiers (Affichage → Éléments masqués).

---

## ÉTAPE 3 — Créer la clé API App Store Connect (5 min)

C'est la clé qui permet à GitHub de publier sur TestFlight.

1. Va sur **appstoreconnect.apple.com**
2. Clique sur **"Utilisateurs et accès"** (menu en haut)
3. Clique sur l'onglet **"Intégrations"**  
4. Clique sur **"Clés d'API App Store Connect"**
5. Clique **"+"** pour créer une nouvelle clé
6. Nom : `GitHub Actions` | Accès : **Admin**
7. Clique **"Générer"**

Tu obtiens 3 infos à noter :
- **Key ID** : affiché dans la liste (ex: ABC123DEF4)
- **Issuer ID** : affiché en haut de la page (ex: 12345678-abcd-...)
- **Fichier .p8** : clique **"Télécharger"** 
  ⚠️ Tu ne peux le télécharger qu'UNE SEULE FOIS !

---

## ÉTAPE 4 — Créer le certificat de distribution (10 min)

Comme tu n'as pas de Mac, on va créer le certificat en ligne.

### Option A : Depuis developer.apple.com
1. Va sur **developer.apple.com** → Account → Certificates
2. Clique **"+"** pour créer un nouveau certificat
3. Sélectionne **"Apple Distribution"**
4. Il demande un fichier CSR...

### Option B : Plus simple — via l'API (recommandé)
On peut générer le certificat automatiquement via Fastlane 
lors du premier build. Pour ça il faut ajouter cette étape 
dans le workflow. Dis-le moi et je modifie le fichier.

### Option C : Si tu as déjà un certificat
Si tu as déjà créé un certificat de distribution avant 
(avec ton Mac ou via une précédente tentative) :
1. Va sur **developer.apple.com** → Account → Certificates
2. Télécharge le certificat (.cer)
3. Tu auras aussi besoin du fichier .p12 correspondant

---

## ÉTAPE 5 — Créer le Provisioning Profile (3 min)

1. Va sur **developer.apple.com** → Account → Profiles
2. Clique **"+"**
3. Sélectionne **"App Store Connect"** (sous Distribution)
4. Sélectionne l'App ID **com.zetaentreprise.quranlock**
   (Si elle n'existe pas, va d'abord dans Identifiers → "+" 
   → App IDs → "QuranLock" → com.zetaentreprise.quranlock)
5. Sélectionne ton certificat de distribution
6. Nom : **QuranLock AppStore**
7. Télécharge le fichier .mobileprovision

---

## ÉTAPE 6 — Configurer les Secrets GitHub (5 min)

1. Va sur ton repo GitHub → **Settings** → **Secrets and variables** → **Actions**
2. Clique **"New repository secret"** pour chaque secret :

| Nom du secret | Valeur |
|---|---|
| `APP_STORE_API_KEY_ID` | Le Key ID de l'étape 3 |
| `APP_STORE_API_ISSUER_ID` | L'Issuer ID de l'étape 3 |
| `APP_STORE_API_KEY_CONTENT` | Le contenu du fichier .p8 (ouvre-le avec Notepad, copie tout) |
| `CERTIFICATE_BASE64` | Voir ci-dessous |
| `CERTIFICATE_PASSWORD` | Le mot de passe de ton .p12 |
| `PROVISIONING_PROFILE_BASE64` | Voir ci-dessous |

### Pour encoder en Base64 (sur Windows PowerShell) :

Pour le certificat .p12 :
```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("chemin\vers\certificate.p12"))
```

Pour le provisioning profile :
```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("chemin\vers\QuranLock.mobileprovision"))
```

Copie le résultat et colle-le comme secret GitHub.

---

## ÉTAPE 7 — Lancer le build ! (2 min)

1. Va sur ton repo GitHub → onglet **"Actions"**
2. Tu verras le workflow **"Build & Deploy to TestFlight"**
3. Clique dessus → **"Run workflow"** → **"Run workflow"**
4. Attends ~10-15 min
5. Si tout est vert ✅ → le build est sur TestFlight !

---

## ÉTAPE 8 — Soumettre à l'App Store (5 min)

1. Va sur **appstoreconnect.apple.com** → QuranLock
2. Onglet **TestFlight** → tu verras le nouveau build
3. Onglet **Distribution** → prépare la fiche (description, screenshots, etc.)
4. Sélectionne le build → **"Soumettre pour examen"**
5. Apple review en 24-48h généralement

---

## 🔄 Pour les futures mises à jour

1. Modifie le code sur GitHub (ou envoie-moi les changements)
2. Push sur `main`
3. GitHub Actions compile et uploade automatiquement
4. Le nouveau build apparaît sur TestFlight
5. Soumets à l'App Store depuis ton navigateur

C'est tout ! 🎉
