// ==========================================
// QURANLOCK V5 - APPLICATION PRINCIPALE
// ==========================================

// État global de l'application
const AppState = {
    currentPage: 'home',
    currentSurah: null,
    currentVerse: 1,
    isPlaying: false,
    isRecording: false,
    mediaRecorder: null,
    audioContext: null,
    dhikrCount: 0,
    dhikrTarget: 33,
    quizScore: 0,
    quizQuestions: [],
    quizCurrentIndex: 0,
    user: null,
    settings: {
        theme: 'dark',
        fontSize: 'medium',
        arabicFont: 'Amiri',
        autoPlay: false,
        notifications: true
    }
};

// ==========================================
// INITIALISATION
// ==========================================
document.addEventListener('DOMContentLoaded', () => {
    initApp();
});

async function initApp() {
    console.log('🕌 QuranLock V5 - Initialisation...');
    
    // Charger les paramètres
    loadSettings();
    
    // Initialiser la navigation
    initNavigation();
    
    // Initialiser les composants
    initQuranReader();
    initDhikrCounter();
    initDuaaSection();
    initQuizSection();
    initNamesSection();
    initAssistant();
    initDonationSection();
    initArabicLearning();
    
    // Vérifier l'authentification
    checkAuth();
    
    // Afficher la page d'accueil
    showPage('home');
    
    // Charger le hadith du jour
    loadDailyHadith();
    
    // Cacher le loader et afficher l'app
    setTimeout(() => {
        const loader = document.getElementById('app-loader');
        const app = document.getElementById('app');
        
        if (loader) loader.style.display = 'none';
        if (app) app.classList.remove('hidden');
        
        // Vérifier si c'est la première visite
        const hasVisited = localStorage.getItem('quranlock_visited');
        if (!hasVisited) {
            showOnboarding();
        } else {
            showMainApp();
        }
    }, 1000);
    
    console.log('✅ QuranLock V5 - Prêt!');
}

// ==========================================
// NAVIGATION
// ==========================================
function initNavigation() {
    // Navigation principale
    document.querySelectorAll('[data-page]').forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.preventDefault();
            const page = btn.dataset.page;
            showPage(page);
        });
    });
    
    // Boutons retour
    document.querySelectorAll('.back-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            showPage('home');
        });
    });
    
    // Navigation bottom
    document.querySelectorAll('.nav-item').forEach(item => {
        item.addEventListener('click', () => {
            const page = item.dataset.page;
            if (page) {
                document.querySelectorAll('.nav-item').forEach(i => i.classList.remove('active'));
                item.classList.add('active');
                showPage(page);
            }
        });
    });
}

function showPage(pageId) {
    // Cacher toutes les pages
    document.querySelectorAll('.page').forEach(page => {
        page.classList.remove('active');
    });
    
    // Afficher la page demandée
    const targetPage = document.getElementById(`page-${pageId}`);
    if (targetPage) {
        targetPage.classList.add('active');
        AppState.currentPage = pageId;
        
        // Actions spécifiques par page
        onPageShow(pageId);
    }
    
    // Scroll en haut
    window.scrollTo(0, 0);
}

function onPageShow(pageId) {
    switch(pageId) {
        case 'quran':
            loadSurahList();
            break;
        case 'names':
            loadAllahNames();
            break;
        case 'duaa':
            loadDuaaCategories();
            break;
        case 'quiz':
            showQuizCategories();
            break;
        case 'arabic':
            loadArabicCourses();
            break;
    }
}

// ==========================================
// LECTEUR DE CORAN
// ==========================================
function initQuranReader() {
    const surahList = document.getElementById('surah-list');
    if (surahList) {
        loadSurahList();
    }
}

function loadSurahList() {
    const container = document.getElementById('surah-list');
    if (!container) return;
    
    container.innerHTML = SURAHS.map(surah => `
        <div class="surah-card" onclick="openSurah(${surah.id})">
            <div class="surah-number">${surah.id}</div>
            <div class="surah-info">
                <h3>${surah.name}</h3>
                <p class="surah-arabic">${surah.nameAr}</p>
                <p class="surah-meta">${surah.verses} versets • ${surah.revelation}</p>
            </div>
            <div class="surah-meaning">${surah.meaning}</div>
        </div>
    `).join('');
}

async function openSurah(surahId) {
    AppState.currentSurah = surahId;
    AppState.currentVerse = 1;
    
    const surah = SURAHS.find(s => s.id === surahId);
    if (!surah) return;
    
    // Afficher la page de lecture
    showPage('reader');
    
    // Mettre à jour le header
    const header = document.querySelector('#reader-page .surah-header');
    if (header) {
        header.innerHTML = `
            <h2>${surah.nameAr}</h2>
            <p>${surah.name} - ${surah.meaning}</p>
        `;
    }
    
    // Charger les versets
    await loadSurahVerses(surahId);
}

async function loadSurahVerses(surahId) {
    const container = document.getElementById('verses-container');
    if (!container) return;
    
    // Vérifier si on a le texte local
    if (SURAH_TEXTS[surahId]) {
        displayVerses(SURAH_TEXTS[surahId].verses);
        return;
    }
    
    // Sinon, charger depuis l'API
    container.innerHTML = '<div class="loading"><div class="spinner"></div><p>Chargement des versets...</p></div>';
    
    try {
        const response = await fetch(`https://api.alquran.cloud/v1/surah/${surahId}/ar.alafasy`);
        const data = await response.json();
        
        if (data.code === 200) {
            const verses = data.data.ayahs.map(ayah => ({
                number: ayah.numberInSurah,
                arabic: ayah.text,
                audio: ayah.audio
            }));
            displayVerses(verses);
        }
    } catch (error) {
        console.error('Erreur chargement sourate:', error);
        container.innerHTML = `
            <div class="error-message">
                <p>Impossible de charger la sourate</p>
                <button onclick="loadSurahVerses(${surahId})">Réessayer</button>
            </div>
        `;
    }
}

function displayVerses(verses) {
    const container = document.getElementById('verses-container');
    if (!container) return;
    
    container.innerHTML = verses.map(verse => `
        <div class="verse-card" data-verse="${verse.number}">
            <div class="verse-number">${verse.number}</div>
            <div class="verse-content">
                <p class="verse-arabic">${verse.arabic}</p>
                ${verse.phonetic ? `<p class="verse-phonetic">${verse.phonetic}</p>` : ''}
                ${verse.translation ? `<p class="verse-translation">${verse.translation}</p>` : ''}
            </div>
            <div class="verse-actions">
                ${verse.audio ? `<button class="btn-icon" onclick="playVerse('${verse.audio}')"><i class="fas fa-play"></i></button>` : ''}
                <button class="btn-icon" onclick="startRecording(${verse.number})"><i class="fas fa-microphone"></i></button>
                <button class="btn-icon" onclick="bookmarkVerse(${AppState.currentSurah}, ${verse.number})"><i class="fas fa-bookmark"></i></button>
            </div>
        </div>
    `).join('');
}

function playVerse(audioUrl) {
    if (AppState.isPlaying) {
        stopAudio();
        return;
    }
    
    const audio = new Audio(audioUrl);
    audio.play();
    AppState.isPlaying = true;
    
    audio.onended = () => {
        AppState.isPlaying = false;
    };
}

function stopAudio() {
    AppState.isPlaying = false;
}

// ==========================================
// ENREGISTREMENT VOCAL
// ==========================================
async function startRecording(verseNumber) {
    if (AppState.isRecording) {
        stopRecording();
        return;
    }
    
    try {
        const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
        AppState.mediaRecorder = new MediaRecorder(stream);
        const chunks = [];
        
        AppState.mediaRecorder.ondataavailable = (e) => chunks.push(e.data);
        AppState.mediaRecorder.onstop = () => {
            const blob = new Blob(chunks, { type: 'audio/webm' });
            analyzeRecording(blob, verseNumber);
        };
        
        AppState.mediaRecorder.start();
        AppState.isRecording = true;
        
        showNotification('🎤 Enregistrement en cours...', 'info');
        
        // Arrêt automatique après 30 secondes
        setTimeout(() => {
            if (AppState.isRecording) stopRecording();
        }, 30000);
        
    } catch (error) {
        console.error('Erreur microphone:', error);
        showNotification('Impossible d\'accéder au microphone', 'error');
    }
}

function stopRecording() {
    if (AppState.mediaRecorder && AppState.isRecording) {
        AppState.mediaRecorder.stop();
        AppState.isRecording = false;
        showNotification('✅ Enregistrement terminé', 'success');
    }
}

async function analyzeRecording(audioBlob, verseNumber) {
    showNotification('🔄 Analyse de votre récitation...', 'info');
    
    // Simulation d'analyse (en production, utiliser Google Speech-to-Text)
    setTimeout(() => {
        const score = Math.floor(Math.random() * 30) + 70; // Score entre 70-100
        showRecitationFeedback(score, verseNumber);
    }, 2000);
}

function showRecitationFeedback(score, verseNumber) {
    const modal = document.getElementById('feedback-modal');
    if (!modal) return;
    
    let feedback = '';
    let emoji = '';
    
    if (score >= 90) {
        emoji = '🌟';
        feedback = 'Excellent ! Votre récitation est très bonne.';
    } else if (score >= 75) {
        emoji = '👍';
        feedback = 'Bien ! Continuez à pratiquer.';
    } else {
        emoji = '💪';
        feedback = 'Continuez vos efforts, vous progressez !';
    }
    
    modal.innerHTML = `
        <div class="modal-content feedback-content">
            <span class="close-modal" onclick="closeModal('feedback-modal')">&times;</span>
            <div class="feedback-score">${emoji}</div>
            <h3>Score: ${score}%</h3>
            <p>${feedback}</p>
            <div class="feedback-actions">
                <button class="btn btn-secondary" onclick="closeModal('feedback-modal')">Fermer</button>
                <button class="btn btn-primary" onclick="startRecording(${verseNumber}); closeModal('feedback-modal')">Réessayer</button>
            </div>
        </div>
    `;
    modal.style.display = 'flex';
}

// ==========================================
// COMPTEUR DE DHIKR
// ==========================================
function initDhikrCounter() {
    const counter = document.getElementById('dhikr-counter');
    if (!counter) return;
    
    updateDhikrDisplay();
}

function incrementDhikr() {
    AppState.dhikrCount++;
    updateDhikrDisplay();
    
    // Vibration légère si supportée
    if (navigator.vibrate) {
        navigator.vibrate(50);
    }
    
    // Notification à chaque palier
    if (AppState.dhikrCount === AppState.dhikrTarget) {
        showNotification(`🎉 ${AppState.dhikrTarget} dhikr atteints !`, 'success');
        if (navigator.vibrate) {
            navigator.vibrate([100, 50, 100]);
        }
    }
}

function resetDhikr() {
    AppState.dhikrCount = 0;
    updateDhikrDisplay();
}

function setDhikrTarget(target) {
    AppState.dhikrTarget = target;
    updateDhikrDisplay();
}

function updateDhikrDisplay() {
    const countDisplay = document.getElementById('dhikr-count');
    const progressBar = document.getElementById('dhikr-progress');
    const targetDisplay = document.getElementById('dhikr-target');
    
    if (countDisplay) countDisplay.textContent = AppState.dhikrCount;
    if (targetDisplay) targetDisplay.textContent = AppState.dhikrTarget;
    if (progressBar) {
        const percentage = Math.min((AppState.dhikrCount / AppState.dhikrTarget) * 100, 100);
        progressBar.style.width = `${percentage}%`;
    }
}

// ==========================================
// SECTION DUAAS
// ==========================================
function initDuaaSection() {
    loadDuaaCategories();
}

function loadDuaaCategories() {
    const container = document.getElementById('duaa-categories');
    if (!container) return;
    
    container.innerHTML = DUAA_CATEGORIES.map(cat => `
        <button class="category-btn ${cat.id === 'all' ? 'active' : ''}" 
                onclick="filterDuaas('${cat.id}')">
            <span class="cat-icon">${cat.icon}</span>
            <span>${cat.name}</span>
        </button>
    `).join('');
    
    // Charger toutes les duaas
    filterDuaas('all');
}

function filterDuaas(category) {
    // Mettre à jour les boutons actifs
    document.querySelectorAll('.category-btn').forEach(btn => {
        btn.classList.remove('active');
        if (btn.textContent.includes(DUAA_CATEGORIES.find(c => c.id === category)?.name || 'Toutes')) {
            btn.classList.add('active');
        }
    });
    
    const filtered = category === 'all' 
        ? DUAAS 
        : DUAAS.filter(d => d.category === category);
    
    displayDuaas(filtered);
}

function displayDuaas(duaas) {
    const container = document.getElementById('duaa-list');
    if (!container) return;
    
    container.innerHTML = duaas.map(duaa => `
        <div class="duaa-card" onclick="showDuaaDetail(${duaa.id})">
            <div class="duaa-category">${duaa.category}</div>
            <h3>${duaa.title}</h3>
            <p class="duaa-arabic">${duaa.arabic}</p>
            <p class="duaa-translation">${duaa.translation}</p>
            <span class="duaa-source">${duaa.source}</span>
        </div>
    `).join('');
}

function showDuaaDetail(duaaId) {
    const duaa = DUAAS.find(d => d.id === duaaId);
    if (!duaa) return;
    
    const modal = document.getElementById('duaa-modal');
    if (!modal) return;
    
    modal.innerHTML = `
        <div class="modal-content duaa-detail">
            <span class="close-modal" onclick="closeModal('duaa-modal')">&times;</span>
            <div class="duaa-category">${duaa.category}</div>
            <h2>${duaa.title}</h2>
            <p class="duaa-arabic large">${duaa.arabic}</p>
            <p class="duaa-transliteration">${duaa.transliteration}</p>
            <p class="duaa-translation">${duaa.translation}</p>
            <div class="duaa-source">Source: ${duaa.source}</div>
            <div class="duaa-actions">
                <button class="btn btn-icon" onclick="shareDuaa(${duaa.id})"><i class="fas fa-share"></i></button>
                <button class="btn btn-icon" onclick="copyDuaa(${duaa.id})"><i class="fas fa-copy"></i></button>
                <button class="btn btn-icon" onclick="saveDuaa(${duaa.id})"><i class="fas fa-heart"></i></button>
            </div>
        </div>
    `;
    modal.style.display = 'flex';
}

function copyDuaa(duaaId) {
    const duaa = DUAAS.find(d => d.id === duaaId);
    if (!duaa) return;
    
    const text = `${duaa.arabic}\n\n${duaa.transliteration}\n\n${duaa.translation}\n\nSource: ${duaa.source}`;
    navigator.clipboard.writeText(text).then(() => {
        showNotification('✅ Duaa copiée !', 'success');
    });
}

// ==========================================
// 99 NOMS D'ALLAH
// ==========================================
function initNamesSection() {
    loadAllahNames();
}

function loadAllahNames() {
    const container = document.getElementById('names-grid');
    if (!container) return;
    
    container.innerHTML = ALLAH_NAMES.map(name => `
        <div class="name-card" onclick="showNameDetail(${name.id})">
            <span class="name-number">${name.id}</span>
            <h3 class="name-arabic">${name.arabic}</h3>
            <p class="name-transliteration">${name.transliteration}</p>
            <p class="name-meaning">${name.meaning}</p>
        </div>
    `).join('');
}

function showNameDetail(nameId) {
    const name = ALLAH_NAMES.find(n => n.id === nameId);
    if (!name) return;
    
    const modal = document.getElementById('name-modal');
    if (!modal) return;
    
    modal.innerHTML = `
        <div class="modal-content name-detail">
            <span class="close-modal" onclick="closeModal('name-modal')">&times;</span>
            <span class="name-number-large">${name.id}</span>
            <h2 class="name-arabic-large">${name.arabic}</h2>
            <p class="name-transliteration-large">${name.transliteration}</p>
            <p class="name-meaning-large">${name.meaning}</p>
        </div>
    `;
    modal.style.display = 'flex';
}

// ==========================================
// QUIZ ISLAMIQUE
// ==========================================
function initQuizSection() {
    showQuizCategories();
}

function showQuizCategories() {
    const container = document.getElementById('quiz-categories');
    if (!container) return;
    
    container.innerHTML = `
        <h3>Choisissez une catégorie</h3>
        <div class="categories-grid">
            ${QUIZ_CATEGORIES.map(cat => `
                <button class="quiz-category-btn" onclick="selectQuizCategory('${cat.id}')">
                    <span class="cat-icon">${cat.icon}</span>
                    <span>${cat.name}</span>
                </button>
            `).join('')}
        </div>
        <h3>Niveau de difficulté</h3>
        <div class="levels-grid">
            ${QUIZ_LEVELS.map(level => `
                <button class="quiz-level-btn" data-level="${level.id}" onclick="selectQuizLevel('${level.id}')">
                    <span class="level-icon">${level.icon}</span>
                    <span>${level.name}</span>
                </button>
            `).join('')}
        </div>
        <button class="btn btn-primary btn-large" onclick="startQuiz()" id="start-quiz-btn" disabled>
            Commencer le Quiz
        </button>
    `;
}

let selectedCategory = null;
let selectedLevel = null;

function selectQuizCategory(catId) {
    selectedCategory = catId;
    document.querySelectorAll('.quiz-category-btn').forEach(btn => btn.classList.remove('selected'));
    event.target.closest('.quiz-category-btn').classList.add('selected');
    checkQuizReady();
}

function selectQuizLevel(levelId) {
    selectedLevel = levelId;
    document.querySelectorAll('.quiz-level-btn').forEach(btn => btn.classList.remove('selected'));
    event.target.closest('.quiz-level-btn').classList.add('selected');
    checkQuizReady();
}

function checkQuizReady() {
    const btn = document.getElementById('start-quiz-btn');
    if (btn) {
        btn.disabled = !(selectedCategory && selectedLevel);
    }
}

function startQuiz() {
    if (!selectedCategory || !selectedLevel) return;
    
    // Filtrer les questions
    AppState.quizQuestions = QUIZ_QUESTIONS.filter(q => 
        q.category === selectedCategory && q.level === selectedLevel
    );
    
    // Mélanger les questions
    AppState.quizQuestions = shuffleArray(AppState.quizQuestions).slice(0, 10);
    AppState.quizCurrentIndex = 0;
    AppState.quizScore = 0;
    
    if (AppState.quizQuestions.length === 0) {
        showNotification('Pas assez de questions dans cette catégorie', 'warning');
        return;
    }
    
    showQuizQuestion();
}

function showQuizQuestion() {
    const container = document.getElementById('quiz-container') || document.getElementById('quiz-categories');
    if (!container) return;
    
    const question = AppState.quizQuestions[AppState.quizCurrentIndex];
    const progress = ((AppState.quizCurrentIndex + 1) / AppState.quizQuestions.length) * 100;
    
    container.innerHTML = `
        <div class="quiz-progress">
            <div class="progress-bar">
                <div class="progress-fill" style="width: ${progress}%"></div>
            </div>
            <span>Question ${AppState.quizCurrentIndex + 1}/${AppState.quizQuestions.length}</span>
        </div>
        <div class="quiz-question">
            <h3>${question.question}</h3>
            <div class="quiz-options">
                ${question.options.map((opt, i) => `
                    <button class="quiz-option" onclick="answerQuiz(${i})">
                        ${opt}
                    </button>
                `).join('')}
            </div>
        </div>
        <div class="quiz-score">Score: ${AppState.quizScore}</div>
    `;
}

function answerQuiz(answerIndex) {
    const question = AppState.quizQuestions[AppState.quizCurrentIndex];
    const isCorrect = answerIndex === question.correct;
    
    // Mettre à jour le score
    if (isCorrect) {
        AppState.quizScore += 10;
    }
    
    // Afficher le feedback
    const options = document.querySelectorAll('.quiz-option');
    options.forEach((opt, i) => {
        opt.disabled = true;
        if (i === question.correct) {
            opt.classList.add('correct');
        } else if (i === answerIndex && !isCorrect) {
            opt.classList.add('wrong');
        }
    });
    
    // Afficher l'explication
    const questionDiv = document.querySelector('.quiz-question');
    if (questionDiv) {
        const explanation = document.createElement('div');
        explanation.className = `quiz-explanation ${isCorrect ? 'correct' : 'wrong'}`;
        explanation.innerHTML = `
            <p>${isCorrect ? '✅ Correct !' : '❌ Incorrect'}</p>
            <p>${question.explanation}</p>
        `;
        questionDiv.appendChild(explanation);
    }
    
    // Passer à la question suivante après 2 secondes
    setTimeout(() => {
        AppState.quizCurrentIndex++;
        if (AppState.quizCurrentIndex < AppState.quizQuestions.length) {
            showQuizQuestion();
        } else {
            showQuizResults();
        }
    }, 2500);
}

function showQuizResults() {
    const container = document.getElementById('quiz-container') || document.getElementById('quiz-categories');
    if (!container) return;
    
    const percentage = (AppState.quizScore / (AppState.quizQuestions.length * 10)) * 100;
    let message = '';
    let emoji = '';
    
    if (percentage >= 80) {
        emoji = '🏆';
        message = 'Excellent ! Vous êtes un expert !';
    } else if (percentage >= 60) {
        emoji = '👍';
        message = 'Bien joué ! Continuez à apprendre.';
    } else {
        emoji = '📚';
        message = 'Continuez à étudier, vous progresserez !';
    }
    
    container.innerHTML = `
        <div class="quiz-results">
            <div class="result-emoji">${emoji}</div>
            <h2>Quiz Terminé !</h2>
            <div class="result-score">${AppState.quizScore} points</div>
            <div class="result-percentage">${percentage}%</div>
            <p>${message}</p>
            <div class="result-actions">
                <button class="btn btn-secondary" onclick="showQuizCategories()">
                    Choisir un autre quiz
                </button>
                <button class="btn btn-primary" onclick="startQuiz()">
                    Rejouer
                </button>
            </div>
        </div>
    `;
    
    // Sauvegarder le score
    saveQuizScore(selectedCategory, selectedLevel, AppState.quizScore);
}

function saveQuizScore(category, level, score) {
    const scores = JSON.parse(localStorage.getItem('quranlock_quiz_scores') || '[]');
    scores.push({
        category,
        level,
        score,
        date: new Date().toISOString()
    });
    localStorage.setItem('quranlock_quiz_scores', JSON.stringify(scores));
}

// ==========================================
// ASSISTANT SPIRITUEL
// ==========================================
function initAssistant() {
    const input = document.getElementById('assistant-input');
    const sendBtn = document.getElementById('assistant-send');
    
    if (input && sendBtn) {
        sendBtn.addEventListener('click', () => sendAssistantMessage());
        input.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') sendAssistantMessage();
        });
    }
}

function sendAssistantMessage() {
    const input = document.getElementById('assistant-input');
    const chatContainer = document.getElementById('assistant-chat');
    
    if (!input || !chatContainer) return;
    
    const message = input.value.trim();
    if (!message) return;
    
    // Afficher le message de l'utilisateur
    appendMessage(chatContainer, message, 'user');
    input.value = '';
    
    // Simuler une réponse (en production, utiliser une API)
    setTimeout(() => {
        const response = generateAssistantResponse(message);
        appendMessage(chatContainer, response, 'assistant');
    }, 1000);
}

function appendMessage(container, message, type) {
    const msgDiv = document.createElement('div');
    msgDiv.className = `chat-message ${type}`;
    msgDiv.innerHTML = `<p>${message}</p>`;
    container.appendChild(msgDiv);
    container.scrollTop = container.scrollHeight;
}

function generateAssistantResponse(question) {
    const q = question.toLowerCase();
    
    if (q.includes('prière') || q.includes('salat')) {
        return "La prière (Salat) est le deuxième pilier de l'Islam. Elle est obligatoire 5 fois par jour : Fajr (aube), Dhuhr (midi), Asr (après-midi), Maghrib (coucher du soleil) et Isha (nuit). Souhaitez-vous en savoir plus sur les conditions ou les étapes de la prière ?";
    }
    
    if (q.includes('ramadan') || q.includes('jeûne')) {
        return "Le Ramadan est le mois sacré du jeûne, le quatrième pilier de l'Islam. Du lever au coucher du soleil, les musulmans s'abstiennent de manger, boire et relations intimes. C'est un mois de spiritualité intense, de lecture du Coran et de générosité.";
    }
    
    if (q.includes('hajj') || q.includes('pèlerinage')) {
        return "Le Hajj est le pèlerinage à La Mecque, obligatoire une fois dans la vie pour tout musulman qui en a les moyens. Il se déroule du 8 au 12 Dhul Hijja et comprend plusieurs rites dont le Tawaf, le Sa'i et la station à Arafat.";
    }
    
    if (q.includes('zakat') || q.includes('aumône')) {
        return "La Zakat est l'aumône obligatoire, le troisième pilier de l'Islam. Elle représente 2,5% des économies annuelles au-delà du nisab (seuil minimum). Elle purifie les biens et aide les nécessiteux.";
    }
    
    if (q.includes('wudu') || q.includes('ablution')) {
        return "Les ablutions (Wudu) sont obligatoires avant la prière. Les étapes sont : intention, laver les mains 3x, rincer la bouche 3x, le nez 3x, le visage 3x, les avant-bras jusqu'aux coudes 3x, passer les mains mouillées sur la tête et les oreilles, et laver les pieds 3x.";
    }
    
    return "As-salamu alaykum ! Je suis l'assistant spirituel de QuranLock. Je peux vous aider avec des questions sur l'Islam, le Coran, les hadiths, la prière, le jeûne, et plus encore. Que souhaitez-vous savoir ?";
}

// ==========================================
// SECTION DONS
// ==========================================
function initDonationSection() {
    // Les boutons de don sont gérés par les liens PayPal/Stripe
}

function donate(amount, type) {
    // Rediriger vers la page de paiement appropriée
    if (type === 'developer') {
        // Soutenir le développeur
        window.open(`https://paypal.me/quranlock/${amount}`, '_blank');
    } else {
        // Don caritatif
        showNotification('Redirection vers notre partenaire caritatif...', 'info');
        // En production, rediriger vers l'association caritative
    }
}

// ==========================================
// APPRENTISSAGE ARABE
// ==========================================
function initArabicLearning() {
    loadArabicCourses();
}

function loadArabicCourses() {
    const container = document.getElementById('arabic-courses');
    if (!container) return;
    
    container.innerHTML = ARABIC_COURSES.map(course => `
        <div class="course-card" onclick="openCourse(${course.id})">
            <h3>${course.title}</h3>
            <p>${course.description}</p>
            <div class="course-meta">
                <span class="course-level">${course.level}</span>
                <span class="course-duration">${course.duration}</span>
            </div>
            <div class="course-progress">
                <div class="progress-bar">
                    <div class="progress-fill" style="width: 0%"></div>
                </div>
            </div>
        </div>
    `).join('');
}

function openCourse(courseId) {
    showNotification('Cours en cours de développement', 'info');
}

function showAlphabet() {
    const container = document.getElementById('alphabet-container');
    if (!container) return;
    
    container.innerHTML = `
        <div class="alphabet-grid">
            ${ARABIC_ALPHABET.map(letter => `
                <div class="letter-card" onclick="playLetter('${letter.name}')">
                    <span class="letter-arabic">${letter.letter}</span>
                    <span class="letter-name">${letter.name}</span>
                    <span class="letter-trans">${letter.transliteration}</span>
                </div>
            `).join('')}
        </div>
    `;
}

function playLetter(letterName) {
    // En production, jouer l'audio de la lettre
    showNotification(`Lettre: ${letterName}`, 'info');
}

// ==========================================
// HADITH DU JOUR
// ==========================================
function loadDailyHadith() {
    const container = document.getElementById('daily-hadith');
    if (!container) return;
    
    // Sélectionner un hadith basé sur le jour
    const dayOfYear = Math.floor((new Date() - new Date(new Date().getFullYear(), 0, 0)) / 86400000);
    const hadith = DAILY_HADITHS[dayOfYear % DAILY_HADITHS.length];
    
    container.innerHTML = `
        <div class="hadith-card">
            <h3>📜 Hadith du jour</h3>
            <p class="hadith-arabic">${hadith.arabic}</p>
            <p class="hadith-translation">${hadith.translation}</p>
            <p class="hadith-source">${hadith.source} - ${hadith.narrator}</p>
        </div>
    `;
}

// ==========================================
// UTILITAIRES
// ==========================================
function shuffleArray(array) {
    const shuffled = [...array];
    for (let i = shuffled.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]];
    }
    return shuffled;
}

function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    notification.textContent = message;
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.classList.add('show');
    }, 100);
    
    setTimeout(() => {
        notification.classList.remove('show');
        setTimeout(() => notification.remove(), 300);
    }, 3000);
}

function closeModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.style.display = 'none';
    }
}

function loadSettings() {
    const saved = localStorage.getItem('quranlock_settings');
    if (saved) {
        AppState.settings = { ...AppState.settings, ...JSON.parse(saved) };
    }
    applySettings();
}

function saveSettings() {
    localStorage.setItem('quranlock_settings', JSON.stringify(AppState.settings));
    applySettings();
}

function applySettings() {
    document.documentElement.style.setProperty('--font-size', AppState.settings.fontSize);
    document.body.dataset.theme = AppState.settings.theme;
}

function checkAuth() {
    // Vérifier si Firebase Auth est disponible
    if (typeof firebase !== 'undefined' && firebase.auth) {
        firebase.auth().onAuthStateChanged(user => {
            AppState.user = user;
            updateAuthUI();
        });
    }
}

function updateAuthUI() {
    const authBtn = document.getElementById('auth-btn');
    if (authBtn) {
        if (AppState.user) {
            authBtn.textContent = 'Mon Compte';
            authBtn.onclick = () => showPage('profile');
        } else {
            authBtn.textContent = 'Connexion';
            authBtn.onclick = () => showPage('auth');
        }
    }
}

function bookmarkVerse(surahId, verseNumber) {
    const bookmarks = JSON.parse(localStorage.getItem('quranlock_bookmarks') || '[]');
    const bookmark = { surahId, verseNumber, date: new Date().toISOString() };
    
    const exists = bookmarks.find(b => b.surahId === surahId && b.verseNumber === verseNumber);
    if (!exists) {
        bookmarks.push(bookmark);
        localStorage.setItem('quranlock_bookmarks', JSON.stringify(bookmarks));
        showNotification('✅ Verset ajouté aux favoris', 'success');
    } else {
        showNotification('Ce verset est déjà dans vos favoris', 'info');
    }
}

// Fermer les modals en cliquant à l'extérieur
document.addEventListener('click', (e) => {
    if (e.target.classList.contains('modal')) {
        e.target.style.display = 'none';
    }
});

// Gestion du bouton retour du navigateur
window.addEventListener('popstate', () => {
    if (AppState.currentPage !== 'home') {
        showPage('home');
    }
});

console.log('📱 QuranLock V5 - App.js chargé');

// ==========================================
// ONBOARDING & MAIN APP
// ==========================================
function showOnboarding() {
    const onboarding = document.getElementById('onboarding-screen');
    const mainApp = document.getElementById('main-app');
    
    if (onboarding) onboarding.classList.remove('hidden');
    if (mainApp) mainApp.classList.add('hidden');
    
    initOnboardingSlides();
}

function showMainApp() {
    const onboarding = document.getElementById('onboarding-screen');
    const authScreen = document.getElementById('auth-screen');
    const mainApp = document.getElementById('main-app');
    
    if (onboarding) onboarding.classList.add('hidden');
    if (authScreen) authScreen.classList.add('hidden');
    if (mainApp) mainApp.classList.remove('hidden');
}

function initOnboardingSlides() {
    let currentSlide = 0;
    const slides = document.querySelectorAll('.onboarding-slide');
    const dots = document.querySelectorAll('.onboarding-dots .dot');
    const nextBtn = document.getElementById('next-onboarding');
    const skipBtn = document.getElementById('skip-onboarding');
    
    function showSlide(index) {
        slides.forEach((s, i) => {
            s.classList.toggle('active', i === index);
        });
        dots.forEach((d, i) => {
            d.classList.toggle('active', i === index);
        });
        
        if (index === slides.length - 1) {
            nextBtn.textContent = 'Commencer';
        } else {
            nextBtn.textContent = 'Suivant';
        }
    }
    
    if (nextBtn) {
        nextBtn.addEventListener('click', () => {
            if (currentSlide < slides.length - 1) {
                currentSlide++;
                showSlide(currentSlide);
            } else {
                finishOnboarding();
            }
        });
    }
    
    if (skipBtn) {
        skipBtn.addEventListener('click', finishOnboarding);
    }
    
    dots.forEach((dot, i) => {
        dot.addEventListener('click', () => {
            currentSlide = i;
            showSlide(currentSlide);
        });
    });
}

function finishOnboarding() {
    localStorage.setItem('quranlock_visited', 'true');
    
    // Vérifier si l'utilisateur est connecté
    if (auth && auth.currentUser) {
        showMainApp();
    } else {
        // Afficher l'écran de connexion ou directement l'app
        showMainApp(); // On permet l'accès sans compte
    }
}

// Init auth buttons
document.addEventListener('DOMContentLoaded', () => {
    // Google Sign In
    const googleBtn = document.getElementById('google-signin');
    if (googleBtn) {
        googleBtn.addEventListener('click', async () => {
            try {
                await signInWithGoogle();
                showMainApp();
            } catch (e) {
                console.error('Google sign in error:', e);
                showNotification('Erreur de connexion', 'error');
            }
        });
    }
    
    // Email Sign In
    const loginForm = document.getElementById('login-form');
    if (loginForm) {
        loginForm.addEventListener('submit', async (e) => {
            e.preventDefault();
            const email = document.getElementById('login-email').value;
            const password = document.getElementById('login-password').value;
            try {
                await signInWithEmail(email, password);
                showMainApp();
            } catch (e) {
                showNotification('Email ou mot de passe incorrect', 'error');
            }
        });
    }
    
    // Register Form
    const registerForm = document.getElementById('register-form');
    if (registerForm) {
        registerForm.addEventListener('submit', async (e) => {
            e.preventDefault();
            const email = document.getElementById('register-email').value;
            const password = document.getElementById('register-password').value;
            try {
                await signUpWithEmail(email, password);
                showMainApp();
            } catch (e) {
                showNotification('Erreur d\'inscription: ' + e.message, 'error');
            }
        });
    }
    
    // Continue without account
    const skipAuth = document.getElementById('skip-auth');
    if (skipAuth) {
        skipAuth.addEventListener('click', showMainApp);
    }
    
    // Auth tabs
    document.querySelectorAll('.auth-tab').forEach(tab => {
        tab.addEventListener('click', () => {
            const tabName = tab.dataset.tab;
            document.querySelectorAll('.auth-tab').forEach(t => t.classList.remove('active'));
            tab.classList.add('active');
            
            document.querySelectorAll('.auth-form').forEach(f => f.classList.add('hidden'));
            const form = document.getElementById(`${tabName}-form`);
            if (form) form.classList.remove('hidden');
        });
    });
});
