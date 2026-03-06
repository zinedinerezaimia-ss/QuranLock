/**
 * QURANLOCK - Configuration Firebase
 * Sécurisé et optimisé
 */

// Configuration Firebase - NOUVEAU PROJET
const firebaseConfig = {
    apiKey: "AIzaSyD-uEhfR1qzlwAnghzIm4NpkMakOJI_jTo",
    authDomain: "quran-lock-aaa49.firebaseapp.com",
    projectId: "quran-lock-aaa49",
    storageBucket: "quran-lock-aaa49.firebasestorage.app",
    messagingSenderId: "767146002547",
    appId: "1:767146002547:web:fbadc6a9f37a2da4084206"
};

// Initialiser Firebase
firebase.initializeApp(firebaseConfig);

// Services Firebase
const auth = firebase.auth();
const db = firebase.firestore();
const storage = firebase.storage();

// Configuration de l'authentification Google
const googleProvider = new firebase.auth.GoogleAuthProvider();
googleProvider.setCustomParameters({
    prompt: 'select_account'
});

// ============================================
// SÉCURITÉ - Configuration
// ============================================

// Activer la persistance locale pour l'auth
auth.setPersistence(firebase.auth.Auth.Persistence.LOCAL);

// Configuration Firestore avec cache
db.settings({
    cacheSizeBytes: firebase.firestore.CACHE_SIZE_UNLIMITED
});

// Activer la persistance offline
db.enablePersistence({ synchronizeTabs: true }).catch((err) => {
    if (err.code === 'failed-precondition') {
        console.warn('Persistance impossible: plusieurs onglets ouverts');
    } else if (err.code === 'unimplemented') {
        console.warn('Persistance non supportée par ce navigateur');
    }
});

// Configuration générale
const CONFIG = {
    APP_NAME: 'QuranLock',
    VERSION: '1.0.0',
    
    // API Coran (gratuite, pas de clé)
    QURAN_API: 'https://api.alquran.cloud/v1',
    
    // Contact
    WHATSAPP: '+33767282133',
    EMAIL: 'quranlock@gmail.com',
    
    // Buy Me a Coffee
    COFFEE_LINK: 'https://buymeacoffee.com/quranlock',
    
    // Paramètres
    MIN_PASSWORD_LENGTH: 6,
    MAX_STREAK_DAYS: 1000,
    POINTS_PER_SURAH: 10,
    POINTS_PER_QUIZ: 5,
    
    // Sécurité
    MAX_LOGIN_ATTEMPTS: 5,
    LOCKOUT_DURATION: 15 * 60 * 1000, // 15 minutes
    SESSION_TIMEOUT: 24 * 60 * 60 * 1000, // 24 heures
    
    // Local Storage Keys (préfixés pour éviter les collisions)
    STORAGE_KEYS: {
        USER_DATA: 'ql_user',
        SETTINGS: 'ql_settings',
        ONBOARDING_DONE: 'ql_onboarding',
        STREAK_DATA: 'ql_streak',
        COURSE_PROGRESS: 'ql_course',
        DHIKR_HISTORY: 'ql_dhikr',
        LOGIN_ATTEMPTS: 'ql_attempts',
        LOCKOUT_TIME: 'ql_lockout'
    }
};

// ============================================
// UTILITAIRES DE SÉCURITÉ
// ============================================
const Security = {
    // Nettoyer les inputs (anti-XSS)
    sanitize(str) {
        if (typeof str !== 'string') return str;
        const map = {
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#x27;',
            '/': '&#x2F;',
        };
        return str.replace(/[&<>"'/]/g, (char) => map[char]);
    },
    
    // Valider email
    isValidEmail(email) {
        const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return re.test(email);
    },
    
    // Valider mot de passe (min 6 chars)
    isValidPassword(password) {
        return password && password.length >= CONFIG.MIN_PASSWORD_LENGTH;
    },
    
    // Vérifier le rate limiting
    checkRateLimit() {
        const lockoutTime = localStorage.getItem(CONFIG.STORAGE_KEYS.LOCKOUT_TIME);
        if (lockoutTime && Date.now() < parseInt(lockoutTime)) {
            const remaining = Math.ceil((parseInt(lockoutTime) - Date.now()) / 60000);
            return { locked: true, minutes: remaining };
        }
        return { locked: false };
    },
    
    // Incrémenter les tentatives
    incrementAttempts() {
        let attempts = parseInt(localStorage.getItem(CONFIG.STORAGE_KEYS.LOGIN_ATTEMPTS) || '0');
        attempts++;
        localStorage.setItem(CONFIG.STORAGE_KEYS.LOGIN_ATTEMPTS, attempts.toString());
        
        if (attempts >= CONFIG.MAX_LOGIN_ATTEMPTS) {
            const lockoutUntil = Date.now() + CONFIG.LOCKOUT_DURATION;
            localStorage.setItem(CONFIG.STORAGE_KEYS.LOCKOUT_TIME, lockoutUntil.toString());
            return true; // Locked
        }
        return false;
    },
    
    // Reset les tentatives
    resetAttempts() {
        localStorage.removeItem(CONFIG.STORAGE_KEYS.LOGIN_ATTEMPTS);
        localStorage.removeItem(CONFIG.STORAGE_KEYS.LOCKOUT_TIME);
    },
    
    // Générer un ID unique sécurisé
    generateSecureId() {
        const array = new Uint32Array(4);
        crypto.getRandomValues(array);
        return Array.from(array, dec => dec.toString(16).padStart(8, '0')).join('');
    }
};

// Exporter la configuration
window.CONFIG = CONFIG;
window.Security = Security;
