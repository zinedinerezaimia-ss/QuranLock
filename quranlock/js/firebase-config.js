// ==========================================
// QURANLOCK V5 - FIREBASE CONFIG
// ==========================================

const firebaseConfig = {
    apiKey: "AIzaSyD-uEhfR1qzlwAnghzIm4NpkMakOJI_jTo",
    authDomain: "quran-lock-aaa49.firebaseapp.com",
    projectId: "quran-lock-aaa49",
    storageBucket: "quran-lock-aaa49.firebasestorage.app",
    messagingSenderId: "767146002547",
    appId: "1:767146002547:web:fbadc6a9f37a2da4084206"
};

let db = null;
let auth = null;
let firebaseReady = false;

// Init Firebase - non bloquant
try {
    if (typeof firebase !== 'undefined') {
        firebase.initializeApp(firebaseConfig);
        db = firebase.firestore();
        auth = firebase.auth();
        firebaseReady = true;
        console.log('✅ Firebase OK');
    }
} catch (e) {
    console.log('⚠️ Firebase error:', e.message);
}

// Auth functions - avec fallback
function signInWithGoogle() {
    if (!firebaseReady) return Promise.reject('Firebase not ready');
    const provider = new firebase.auth.GoogleAuthProvider();
    return auth.signInWithPopup(provider);
}

function signInWithEmail(email, password) {
    if (!firebaseReady) return Promise.reject('Firebase not ready');
    return auth.signInWithEmailAndPassword(email, password);
}

function signUpWithEmail(email, password) {
    if (!firebaseReady) return Promise.reject('Firebase not ready');
    return auth.createUserWithEmailAndPassword(email, password);
}

function signOut() {
    if (!firebaseReady) return Promise.resolve();
    return auth.signOut();
}

function getCurrentUser() {
    if (!firebaseReady) return null;
    return auth.currentUser;
}

console.log('🔥 Firebase config loaded');
