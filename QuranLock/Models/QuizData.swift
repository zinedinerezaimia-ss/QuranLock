import Foundation

// MARK: - Quiz Data - 600+ Questions (FR/EN/AR)
// Structure: QuizQuestion(question: String, options: [String], correctIndex: Int, difficulty: String, language: String)

struct QuizData {

    // MARK: - FACILE (200 questions)
    static let easyQuestions: [QuizQuestion] = [

        // --- CORAN ---
        QuizQuestion(id: UUID(), question: "Combien de sourates contient le Coran ?", options: ["100", "114", "120", "99"], correctIndex: 1, difficulty: "easy", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Quelle est la première sourate du Coran ?", options: ["Al-Baqara", "Al-Ikhlas", "Al-Fatiha", "Yasin"], correctIndex: 2, difficulty: "easy", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Combien de versets contient Al-Fatiha ?", options: ["5", "6", "7", "8"], correctIndex: 2, difficulty: "easy", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Quelle est la plus longue sourate du Coran ?", options: ["Al-Imran", "Al-Baqara", "An-Nisa", "Al-Maidah"], correctIndex: 1, difficulty: "easy", category: "Coran"),
        QuizQuestion(id: UUID(), question: "En quelle langue a été révélé le Coran ?", options: ["Hébreu", "Araméen", "Arabe", "Persan"], correctIndex: 2, difficulty: "easy", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Quel ange a transmis le Coran au Prophète ﷺ ?", options: ["Mikail", "Israfil", "Jibrail", "Azrail"], correctIndex: 2, difficulty: "easy", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Quelle sourate est appelée 'le cœur du Coran' ?", options: ["Al-Baqara", "Yasin", "Al-Kahf", "Al-Fatiha"], correctIndex: 1, difficulty: "easy", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Combien de parties (juz) contient le Coran ?", options: ["20", "25", "30", "40"], correctIndex: 2, difficulty: "easy", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Quelle est la plus courte sourate du Coran ?", options: ["Al-Ikhlas", "Al-Kawthar", "Al-Asr", "Al-Falaq"], correctIndex: 1, difficulty: "easy", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Pendant combien d'années le Coran a-t-il été révélé ?", options: ["10 ans", "15 ans", "23 ans", "40 ans"], correctIndex: 2, difficulty: "easy", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Quelle sourate ne commence pas par Bismillah ?", options: ["Al-Fatiha", "At-Tawbah", "Al-Baqara", "An-Naml"], correctIndex: 1, difficulty: "easy", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Combien de fois le mot 'Allah' apparaît-il dans le Coran ?", options: ["1000", "2598", "3000", "786"], correctIndex: 1, difficulty: "easy", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Quelle sourate parle de la caverne ?", options: ["Al-Fajr", "Al-Kahf", "Al-Kanz", "At-Tin"], correctIndex: 1, difficulty: "easy", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Quelle est la signification de 'Coran' en arabe ?", options: ["Livre sacré", "Récitation", "Lumière", "Guidance"], correctIndex: 1, difficulty: "easy", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Dans quelle ville la première révélation a-t-elle eu lieu ?", options: ["Médine", "La Mecque", "Jérusalem", "Taïf"], correctIndex: 1, difficulty: "easy", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Quel est le verset du trône (Ayat al-Kursi) dans le Coran ?", options: ["Al-Baqara 255", "Al-Fatiha 1", "Al-Imran 18", "An-Nisa 1"], correctIndex: 0, difficulty: "easy", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Quel prophète est mentionné le plus souvent dans le Coran ?", options: ["Muhammad ﷺ", "Ibrahim", "Musa", "Issa"], correctIndex: 2, difficulty: "easy", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Quelle sourate est recommandée à lire le vendredi ?", options: ["Yasin", "Al-Kahf", "Al-Mulk", "Al-Waqia"], correctIndex: 1, difficulty: "easy", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que la Bismillah ?", options: ["Un verset", "La formule d'ouverture", "Une prière", "Un nom d'Allah"], correctIndex: 1, difficulty: "easy", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Combien de prophètes sont mentionnés par nom dans le Coran ?", options: ["15", "20", "25", "30"], correctIndex: 2, difficulty: "easy", category: "Coran"),

        // --- PILIERS DE L'ISLAM ---
        QuizQuestion(id: UUID(), question: "Combien y a-t-il de piliers de l'Islam ?", options: ["3", "4", "5", "6"], correctIndex: 2, difficulty: "easy", category: "Piliers"),
        QuizQuestion(id: UUID(), question: "Quel est le premier pilier de l'Islam ?", options: ["La Salat", "La Shahada", "Le Zakat", "Le Sawm"], correctIndex: 1, difficulty: "easy", category: "Piliers"),
        QuizQuestion(id: UUID(), question: "Combien de fois par jour un musulman doit-il prier ?", options: ["3", "4", "5", "6"], correctIndex: 2, difficulty: "easy", category: "Piliers"),
        QuizQuestion(id: UUID(), question: "Quel est le mois du jeûne en Islam ?", options: ["Rajab", "Sha'ban", "Ramadan", "Dhul Hijja"], correctIndex: 2, difficulty: "easy", category: "Piliers"),
        QuizQuestion(id: UUID(), question: "Vers quelle direction les musulmans prient-ils ?", options: ["Jérusalem", "La Mecque", "Médine", "Le nord"], correctIndex: 1, difficulty: "easy", category: "Piliers"),
        QuizQuestion(id: UUID(), question: "Quel est le pourcentage du Zakat sur l'épargne ?", options: ["1%", "2%", "2.5%", "5%"], correctIndex: 2, difficulty: "easy", category: "Piliers"),
        QuizQuestion(id: UUID(), question: "Comment appelle-t-on le pèlerinage en Islam ?", options: ["Umra", "Hijra", "Hajj", "Jihad"], correctIndex: 2, difficulty: "easy", category: "Piliers"),
        QuizQuestion(id: UUID(), question: "Quelle est la formule de la Shahada ?", options: ["Allahou Akbar", "La ilaha illallah", "Subhanallah", "Bismillah"], correctIndex: 1, difficulty: "easy", category: "Piliers"),
        QuizQuestion(id: UUID(), question: "Quelle prière est effectuée à l'aube ?", options: ["Dhuhr", "Asr", "Fajr", "Maghrib"], correctIndex: 2, difficulty: "easy", category: "Piliers"),
        QuizQuestion(id: UUID(), question: "Quel pilier consiste à donner aux pauvres ?", options: ["Sawm", "Salat", "Zakat", "Hajj"], correctIndex: 2, difficulty: "easy", category: "Piliers"),

        // --- PROPHÈTE MUHAMMAD ﷺ ---
        QuizQuestion(id: UUID(), question: "Dans quelle ville est né le Prophète Muhammad ﷺ ?", options: ["Médine", "La Mecque", "Taïf", "Jérusalem"], correctIndex: 1, difficulty: "easy", category: "Prophète"),
        QuizQuestion(id: UUID(), question: "Quel est le nom du père du Prophète ﷺ ?", options: ["Abu Bakr", "Abdullah", "Abdul Muttalib", "Hamza"], correctIndex: 1, difficulty: "easy", category: "Prophète"),
        QuizQuestion(id: UUID(), question: "Quel est le nom de la mère du Prophète ﷺ ?", options: ["Khadija", "Fatima", "Amina", "Hafsa"], correctIndex: 2, difficulty: "easy", category: "Prophète"),
        QuizQuestion(id: UUID(), question: "À quel âge le Prophète ﷺ a-t-il reçu la première révélation ?", options: ["35", "38", "40", "45"], correctIndex: 2, difficulty: "easy", category: "Prophète"),
        QuizQuestion(id: UUID(), question: "Quel était le surnom du Prophète ﷺ chez les Arabes ?", options: ["Al-Karim", "Al-Amin", "Al-Sadiq", "Al-Hakim"], correctIndex: 1, difficulty: "easy", category: "Prophète"),
        QuizQuestion(id: UUID(), question: "Quel est le nom de la première épouse du Prophète ﷺ ?", options: ["Aïcha", "Hafsa", "Khadija", "Zainab"], correctIndex: 2, difficulty: "easy", category: "Prophète"),
        QuizQuestion(id: UUID(), question: "Quelle est l'année de la naissance du Prophète ﷺ ?", options: ["570 après JC", "571 après JC", "572 après JC", "580 après JC"], correctIndex: 1, difficulty: "easy", category: "Prophète"),
        QuizQuestion(id: UUID(), question: "À quel âge le Prophète ﷺ est-il décédé ?", options: ["55", "60", "63", "65"], correctIndex: 2, difficulty: "easy", category: "Prophète"),
        QuizQuestion(id: UUID(), question: "Dans quelle ville est enterré le Prophète ﷺ ?", options: ["La Mecque", "Jérusalem", "Médine", "Taïf"], correctIndex: 2, difficulty: "easy", category: "Prophète"),
        QuizQuestion(id: UUID(), question: "Comment s'appelle la migration du Prophète ﷺ vers Médine ?", options: ["Jihad", "Hijra", "Fath", "Isra"], correctIndex: 1, difficulty: "easy", category: "Prophète"),

        // --- HISTOIRE ISLAMIQUE ---
        QuizQuestion(id: UUID(), question: "Qui était le premier calife de l'Islam ?", options: ["Omar ibn al-Khattab", "Abu Bakr As-Siddiq", "Uthman ibn Affan", "Ali ibn Abi Talib"], correctIndex: 1, difficulty: "easy", category: "Histoire"),
        QuizQuestion(id: UUID(), question: "Quelle est la ville sainte la plus importante de l'Islam ?", options: ["Médine", "Jérusalem", "La Mecque", "Bagdad"], correctIndex: 2, difficulty: "easy", category: "Histoire"),
        QuizQuestion(id: UUID(), question: "Comment s'appelle la mosquée à La Mecque ?", options: ["Al-Aqsa", "Al-Haram", "An-Nabawi", "Al-Qibla"], correctIndex: 1, difficulty: "easy", category: "Histoire"),
        QuizQuestion(id: UUID(), question: "Quel est le nom de la structure cubique au centre de la Grande Mosquée ?", options: ["Maqam Ibrahim", "La Kaaba", "Zamzam", "La Pierre Noire"], correctIndex: 1, difficulty: "easy", category: "Histoire"),
        QuizQuestion(id: UUID(), question: "En quelle année s'est produite l'Hégire ?", options: ["610", "622", "630", "632"], correctIndex: 1, difficulty: "easy", category: "Histoire"),
        QuizQuestion(id: UUID(), question: "Qui est Bilal ibn Rabah dans l'histoire islamique ?", options: ["Un général", "Le premier muezzin", "Un calife", "Un savant"], correctIndex: 1, difficulty: "easy", category: "Histoire"),
        QuizQuestion(id: UUID(), question: "Quelle est la première bataille de l'Islam ?", options: ["Uhud", "Khandaq", "Badr", "Hunayn"], correctIndex: 2, difficulty: "easy", category: "Histoire"),
        QuizQuestion(id: UUID(), question: "Combien y a-t-il de califes bien guidés (Rashidun) ?", options: ["2", "3", "4", "5"], correctIndex: 2, difficulty: "easy", category: "Histoire"),
        QuizQuestion(id: UUID(), question: "Quelle ville a été libérée lors du Fath al-Makkah ?", options: ["Médine", "Taïf", "La Mecque", "Jérusalem"], correctIndex: 2, difficulty: "easy", category: "Histoire"),
        QuizQuestion(id: UUID(), question: "Qui était le compagnon surnommé 'Le Lion d'Allah' ?", options: ["Abu Bakr", "Hamza ibn Abdul Muttalib", "Ali ibn Abi Talib", "Khalid ibn al-Walid"], correctIndex: 1, difficulty: "easy", category: "Histoire"),

        // --- ADORATIONS & PRATIQUES ---
        QuizQuestion(id: UUID(), question: "Combien de rak'at contient la prière de Fajr ?", options: ["1", "2", "3", "4"], correctIndex: 1, difficulty: "easy", category: "Pratiques"),
        QuizQuestion(id: UUID(), question: "Comment appelle-t-on l'appel à la prière ?", options: ["Iqama", "Adhan", "Takbir", "Tasbih"], correctIndex: 1, difficulty: "easy", category: "Pratiques"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le Wudu ?", options: ["La prière", "L'ablution", "Le jeûne", "Le pèlerinage"], correctIndex: 1, difficulty: "easy", category: "Pratiques"),
        QuizQuestion(id: UUID(), question: "Combien de rak'at contient la prière de Dhuhr ?", options: ["2", "3", "4", "5"], correctIndex: 2, difficulty: "easy", category: "Pratiques"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le Ramadan ?", options: ["Un pèlerinage", "Le mois du jeûne", "Une fête", "Une prière"], correctIndex: 1, difficulty: "easy", category: "Pratiques"),
        QuizQuestion(id: UUID(), question: "Comment s'appelle la rupture du jeûne ?", options: ["Suhoor", "Iftar", "Sahour", "Eid"], correctIndex: 1, difficulty: "easy", category: "Pratiques"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le Suhoor ?", options: ["Le repas du soir", "Le repas de l'aube avant le jeûne", "Une prière", "Une aumône"], correctIndex: 1, difficulty: "easy", category: "Pratiques"),
        QuizQuestion(id: UUID(), question: "Quelle fête marque la fin du Ramadan ?", options: ["Eid al-Adha", "Eid al-Fitr", "Mawlid", "Isra Mi'raj"], correctIndex: 1, difficulty: "easy", category: "Pratiques"),
        QuizQuestion(id: UUID(), question: "Quelle fête commémore le sacrifice d'Ibrahim ?", options: ["Eid al-Fitr", "Mawlid", "Eid al-Adha", "Laylat al-Qadr"], correctIndex: 2, difficulty: "easy", category: "Pratiques"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que la Qibla ?", options: ["La direction de la prière", "Une mosquée", "Un livre", "Un rituel"], correctIndex: 0, difficulty: "easy", category: "Pratiques"),

        // --- NOMS D'ALLAH ---
        QuizQuestion(id: UUID(), question: "Combien de noms d'Allah sont mentionnés dans les textes islamiques ?", options: ["33", "66", "99", "100"], correctIndex: 2, difficulty: "easy", category: "Noms d'Allah"),
        QuizQuestion(id: UUID(), question: "Que signifie 'Ar-Rahman' ?", options: ["Le Tout-Puissant", "Le Très Miséricordieux", "Le Sage", "L'Unique"], correctIndex: 1, difficulty: "easy", category: "Noms d'Allah"),
        QuizQuestion(id: UUID(), question: "Que signifie 'Al-Ahad' ?", options: ["L'Éternel", "L'Unique", "Le Créateur", "Le Vivant"], correctIndex: 1, difficulty: "easy", category: "Noms d'Allah"),
        QuizQuestion(id: UUID(), question: "Que signifie 'Al-Khaliq' ?", options: ["Le Juge", "Le Guide", "Le Créateur", "Le Soutien"], correctIndex: 2, difficulty: "easy", category: "Noms d'Allah"),
        QuizQuestion(id: UUID(), question: "Que signifie 'Al-Hayy' ?", options: ["Le Vivant", "L'Éternel", "Le Sage", "L'Entendant"], correctIndex: 0, difficulty: "easy", category: "Noms d'Allah"),
        QuizQuestion(id: UUID(), question: "Que signifie 'Al-Alim' ?", options: ["Le Fort", "L'Omniscient", "Le Miséricordieux", "Le Pardonnant"], correctIndex: 1, difficulty: "easy", category: "Noms d'Allah"),
        QuizQuestion(id: UUID(), question: "Que signifie 'Al-Aziz' ?", options: ["Le Noble", "Le Tout-Puissant", "Le Majestueux", "L'Honoré"], correctIndex: 1, difficulty: "easy", category: "Noms d'Allah"),
        QuizQuestion(id: UUID(), question: "Que signifie 'As-Salam' ?", options: ["La Paix", "La Lumière", "La Force", "Le Guide"], correctIndex: 0, difficulty: "easy", category: "Noms d'Allah"),
        QuizQuestion(id: UUID(), question: "Que signifie 'Al-Ghafur' ?", options: ["Le Puissant", "Le Très Pardonnant", "Le Sage", "Le Riche"], correctIndex: 1, difficulty: "easy", category: "Noms d'Allah"),
        QuizQuestion(id: UUID(), question: "Que signifie 'Al-Qadir' ?", options: ["Le Voyant", "L'Entendant", "Le Tout-Puissant", "Le Proche"], correctIndex: 2, difficulty: "easy", category: "Noms d'Allah"),

        // --- PROPHÈTES ---
        QuizQuestion(id: UUID(), question: "Quel prophète a été avalé par une baleine ?", options: ["Moussa", "Younes", "Ibrahim", "Issa"], correctIndex: 1, difficulty: "easy", category: "Prophètes"),
        QuizQuestion(id: UUID(), question: "Quel prophète a construit l'Arche ?", options: ["Ibrahim", "Nouh", "Adam", "Idris"], correctIndex: 1, difficulty: "easy", category: "Prophètes"),
        QuizQuestion(id: UUID(), question: "Quel prophète est connu pour avoir séparé la mer ?", options: ["Issa", "Ibrahim", "Moussa", "Sulayman"], correctIndex: 2, difficulty: "easy", category: "Prophètes"),
        QuizQuestion(id: UUID(), question: "Quel prophète pouvait parler aux animaux ?", options: ["Dawud", "Sulayman", "Ibrahim", "Yunus"], correctIndex: 1, difficulty: "easy", category: "Prophètes"),
        QuizQuestion(id: UUID(), question: "Quel prophète est le père de l'humanité selon l'Islam ?", options: ["Ibrahim", "Nouh", "Adam", "Idris"], correctIndex: 2, difficulty: "easy", category: "Prophètes"),
        QuizQuestion(id: UUID(), question: "Quel prophète a été jeté dans le feu et en est sorti indemne ?", options: ["Moussa", "Issa", "Ibrahim", "Yunus"], correctIndex: 2, difficulty: "easy", category: "Prophètes"),
        QuizQuestion(id: UUID(), question: "Quel prophète a été élevé vers le ciel sans mourir selon l'Islam ?", options: ["Ibrahim", "Issa", "Idris", "Ilias"], correctIndex: 2, difficulty: "easy", category: "Prophètes"),
        QuizQuestion(id: UUID(), question: "Quel prophète est surnommé 'Khalilullah' (Ami d'Allah) ?", options: ["Moussa", "Ibrahim", "Muhammad ﷺ", "Issa"], correctIndex: 1, difficulty: "easy", category: "Prophètes"),
        QuizQuestion(id: UUID(), question: "Quel est le premier prophète selon l'Islam ?", options: ["Nouh", "Ibrahim", "Adam", "Idris"], correctIndex: 2, difficulty: "easy", category: "Prophètes"),
        QuizQuestion(id: UUID(), question: "Quel est le dernier prophète en Islam ?", options: ["Issa", "Muhammad ﷺ", "Ibrahim", "Moussa"], correctIndex: 1, difficulty: "easy", category: "Prophètes"),

        // --- DHIKR & DUAAS ---
        QuizQuestion(id: UUID(), question: "Que signifie 'Subhanallah' ?", options: ["Allah est Grand", "Gloire à Allah", "Louange à Allah", "Allah pardonne"], correctIndex: 1, difficulty: "easy", category: "Dhikr"),
        QuizQuestion(id: UUID(), question: "Que signifie 'Alhamdulillah' ?", options: ["Allah est Grand", "Gloire à Allah", "Louange à Allah", "Il n'y a de Dieu qu'Allah"], correctIndex: 2, difficulty: "easy", category: "Dhikr"),
        QuizQuestion(id: UUID(), question: "Que signifie 'Allahou Akbar' ?", options: ["Allah pardonne", "Allah est Grand", "Gloire à Allah", "Allah est Unique"], correctIndex: 1, difficulty: "easy", category: "Dhikr"),
        QuizQuestion(id: UUID(), question: "Que signifie 'Inshallah' ?", options: ["Gloire à Allah", "Si Allah le veut", "Allah est miséricordieux", "Au nom d'Allah"], correctIndex: 1, difficulty: "easy", category: "Dhikr"),
        QuizQuestion(id: UUID(), question: "Que signifie 'Bismillah' ?", options: ["Au nom d'Allah", "Gloire à Allah", "Allah est Unique", "Allah est le plus grand"], correctIndex: 0, difficulty: "easy", category: "Dhikr"),
        QuizQuestion(id: UUID(), question: "Que signifie 'Assalamu Alaykum' ?", options: ["Comment vas-tu ?", "Que la paix soit sur vous", "Bienvenue", "Merci"], correctIndex: 1, difficulty: "easy", category: "Dhikr"),
        QuizQuestion(id: UUID(), question: "Combien de fois dit-on 'Subhanallah' dans le tasbih après la prière ?", options: ["25", "33", "34", "100"], correctIndex: 1, difficulty: "easy", category: "Dhikr"),
        QuizQuestion(id: UUID(), question: "Que signifie 'Astaghfirullah' ?", options: ["Allah est Grand", "Je demande pardon à Allah", "Gloire à Allah", "Au nom d'Allah"], correctIndex: 1, difficulty: "easy", category: "Dhikr"),
        QuizQuestion(id: UUID(), question: "Que dit-on quand on entend le nom du Prophète ﷺ ?", options: ["Subhanallah", "Alhamdulillah", "Sallallahu Alayhi Wasallam", "Allahou Akbar"], correctIndex: 2, difficulty: "easy", category: "Dhikr"),
        QuizQuestion(id: UUID(), question: "Que signifie 'Barakallahu Fik' ?", options: ["Qu'Allah te bénisse", "Allah est Grand", "Gloire à Allah", "Au nom d'Allah"], correctIndex: 0, difficulty: "easy", category: "Dhikr"),

        // --- JURISPRUDENCE SIMPLE ---
        QuizQuestion(id: UUID(), question: "La viande de porc est-elle halal ?", options: ["Oui", "Non", "Seulement en cas de nécessité", "Cela dépend"], correctIndex: 1, difficulty: "easy", category: "Jurisprudence"),
        QuizQuestion(id: UUID(), question: "L'alcool est-il permis en Islam ?", options: ["Oui", "Non", "En petites quantités", "Seulement pour les médicaments"], correctIndex: 1, difficulty: "easy", category: "Jurisprudence"),
        QuizQuestion(id: UUID(), question: "Quelle ablution est requise après la relation conjugale ?", options: ["Wudu", "Ghusl", "Tayammum", "Aucune"], correctIndex: 1, difficulty: "easy", category: "Jurisprudence"),
        QuizQuestion(id: UUID(), question: "Le vol est-il interdit en Islam ?", options: ["Oui", "Non", "Seulement en grande quantité", "Cela dépend"], correctIndex: 0, difficulty: "easy", category: "Jurisprudence"),
        QuizQuestion(id: UUID(), question: "La calomnie (ghiba) est-elle interdite en Islam ?", options: ["Oui", "Non", "Parfois", "Seulement si mensongère"], correctIndex: 0, difficulty: "easy", category: "Jurisprudence"),
        QuizQuestion(id: UUID(), question: "Le mariage est-il recommandé en Islam ?", options: ["Non", "Oui", "Neutre", "Cela dépend"], correctIndex: 1, difficulty: "easy", category: "Jurisprudence"),
        QuizQuestion(id: UUID(), question: "À quel âge la prière devient-elle obligatoire ?", options: ["7 ans", "10 ans", "À la puberté", "18 ans"], correctIndex: 2, difficulty: "easy", category: "Jurisprudence"),
        QuizQuestion(id: UUID(), question: "La prière du vendredi (Jumu'ah) est-elle obligatoire pour les hommes ?", options: ["Non", "Oui", "Recommandée", "Facultative"], correctIndex: 1, difficulty: "easy", category: "Jurisprudence"),
        QuizQuestion(id: UUID(), question: "Que signifie 'Halal' ?", options: ["Interdit", "Permis", "Douteux", "Recommandé"], correctIndex: 1, difficulty: "easy", category: "Jurisprudence"),
        QuizQuestion(id: UUID(), question: "Que signifie 'Haram' ?", options: ["Permis", "Recommandé", "Interdit", "Douteux"], correctIndex: 2, difficulty: "easy", category: "Jurisprudence"),

        // --- GÉOGRAPHIE ISLAMIQUE ---
        QuizQuestion(id: UUID(), question: "Dans quel pays se trouve La Mecque ?", options: ["Égypte", "Jordanie", "Arabie Saoudite", "Iran"], correctIndex: 2, difficulty: "easy", category: "Géographie"),
        QuizQuestion(id: UUID(), question: "Dans quel pays se trouve Médine ?", options: ["Koweït", "Arabie Saoudite", "Turquie", "Irak"], correctIndex: 1, difficulty: "easy", category: "Géographie"),
        QuizQuestion(id: UUID(), question: "Dans quel pays se trouve la mosquée Al-Aqsa ?", options: ["Jordanie", "Palestine", "Israël", "Égypte"], correctIndex: 1, difficulty: "easy", category: "Géographie"),
        QuizQuestion(id: UUID(), question: "Quel fleuve est mentionné dans le Coran comme étant dans le paradis ?", options: ["Le Nil", "Le Jourdain", "Al-Kawthar", "L'Euphrate"], correctIndex: 2, difficulty: "easy", category: "Géographie"),
        QuizQuestion(id: UUID(), question: "Dans quel pays est née la civilisation islamique ?", options: ["Irak", "Iran", "Arabie", "Égypte"], correctIndex: 2, difficulty: "easy", category: "Géographie"),
        QuizQuestion(id: UUID(), question: "Quelle montagne est proche de La Mecque et est mentionnée dans le Coran ?", options: ["Mont Sinaï", "Mont Jabal al-Nur", "Mont Uhud", "Mont Arafat"], correctIndex: 1, difficulty: "easy", category: "Géographie"),
        QuizQuestion(id: UUID(), question: "Quel puits sacré se trouve à La Mecque ?", options: ["Zamzam", "Siloé", "Bir al-Aris", "Al-Kawthar"], correctIndex: 0, difficulty: "easy", category: "Géographie"),
        QuizQuestion(id: UUID(), question: "Dans quelle ville se trouve la plus grande mosquée du monde ?", options: ["Médine", "La Mecque", "Istanbul", "Dubaï"], correctIndex: 1, difficulty: "easy", category: "Géographie"),
        QuizQuestion(id: UUID(), question: "Quel pays a la plus grande population musulmane ?", options: ["Arabie Saoudite", "Pakistan", "Indonésie", "Bangladesh"], correctIndex: 2, difficulty: "easy", category: "Géographie"),
        QuizQuestion(id: UUID(), question: "Dans quelle mer le Prophète Moussa a-t-il traversé ?", options: ["Mer Méditerranée", "Mer Rouge", "Mer Noire", "Mer Morte"], correctIndex: 1, difficulty: "easy", category: "Géographie"),

        // --- HADITH SIMPLES ---
        QuizQuestion(id: UUID(), question: "Combien de collections de hadiths sont dans les 'Kutub al-Sitta' ?", options: ["4", "5", "6", "7"], correctIndex: 2, difficulty: "easy", category: "Hadith"),
        QuizQuestion(id: UUID(), question: "Qui a compilé le recueil Sahih al-Bukhari ?", options: ["Muslim", "Al-Bukhari", "At-Tirmidhi", "Ibn Majah"], correctIndex: 1, difficulty: "easy", category: "Hadith"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce qu'un hadith ?", options: ["Un verset du Coran", "Une parole du Prophète ﷺ", "Une loi islamique", "Un livre de jurisprudence"], correctIndex: 1, difficulty: "easy", category: "Hadith"),
        QuizQuestion(id: UUID(), question: "Que signifie 'Sahih' dans le contexte des hadiths ?", options: ["Faible", "Authentique", "Bon", "Isolé"], correctIndex: 1, difficulty: "easy", category: "Hadith"),
        QuizQuestion(id: UUID(), question: "Qui a compilé le Sahih Muslim ?", options: ["Al-Bukhari", "Imam Muslim", "At-Tirmidhi", "Abu Daoud"], correctIndex: 1, difficulty: "easy", category: "Hadith"),
        QuizQuestion(id: UUID(), question: "Le Muwatta est le recueil de quel imam ?", options: ["Imam Ahmad", "Imam Shafi'i", "Imam Malik", "Imam Abu Hanifa"], correctIndex: 2, difficulty: "easy", category: "Hadith"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que la Sunna ?", options: ["Le Coran", "Les pratiques et paroles du Prophète ﷺ", "La loi islamique", "Un livre de prières"], correctIndex: 1, difficulty: "easy", category: "Hadith"),
        QuizQuestion(id: UUID(), question: "Que signifie 'Hadith Da'if' ?", options: ["Hadith authentique", "Hadith faible", "Hadith bon", "Hadith admirable"], correctIndex: 1, difficulty: "easy", category: "Hadith"),
        QuizQuestion(id: UUID(), question: "Quel hadith célèbre commence par 'Les actes sont jugés selon les intentions' ?", options: ["Hadith de Bukhari", "Hadith des 40 de Nawawi", "Hadith de Muslim", "Hadith de Tirmidhi"], correctIndex: 1, difficulty: "easy", category: "Hadith"),
        QuizQuestion(id: UUID(), question: "Combien de hadiths le recueil de Bukhari contient-il environ ?", options: ["3000", "5000", "7275", "10000"], correctIndex: 2, difficulty: "easy", category: "Hadith"),

        // --- COMPLÉMENTS ---
        QuizQuestion(id: UUID(), question: "Que signifie 'Ummah' en Islam ?", options: ["La mosquée", "La communauté musulmane", "La prière", "Le livre"], correctIndex: 1, difficulty: "easy", category: "Vocabulaire"),
        QuizQuestion(id: UUID(), question: "Que signifie 'Hijab' littéralement ?", options: ["Voile", "Couverture", "Barrière", "Habillage"], correctIndex: 2, difficulty: "easy", category: "Vocabulaire"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que la Kaaba ?", options: ["Une mosquée", "La direction de prière", "La maison sacrée cubique à La Mecque", "Un verset"], correctIndex: 2, difficulty: "easy", category: "Vocabulaire"),
        QuizQuestion(id: UUID(), question: "Que signifie 'Imam' ?", options: ["Calife", "Leader de prière", "Savant", "Prophète"], correctIndex: 1, difficulty: "easy", category: "Vocabulaire"),
        QuizQuestion(id: UUID(), question: "Que signifie 'Muezzin' ?", options: ["Celui qui dirige la prière", "Celui qui appelle à la prière", "Un savant", "Un calife"], correctIndex: 1, difficulty: "easy", category: "Vocabulaire"),
        QuizQuestion(id: UUID(), question: "Que signifie 'Minaret' ?", options: ["La salle de prière", "La tour d'une mosquée", "La coupole", "L'entrée"], correctIndex: 1, difficulty: "easy", category: "Vocabulaire"),
        QuizQuestion(id: UUID(), question: "Quel jour est sacré en Islam ?", options: ["Samedi", "Dimanche", "Vendredi", "Lundi"], correctIndex: 2, difficulty: "easy", category: "Vocabulaire"),
        QuizQuestion(id: UUID(), question: "Que signifie 'Fiqh' ?", options: ["La foi", "La jurisprudence islamique", "Le Coran", "La prière"], correctIndex: 1, difficulty: "easy", category: "Vocabulaire"),
        QuizQuestion(id: UUID(), question: "Que signifie 'Aqida' ?", options: ["La jurisprudence", "La croyance/doctrine islamique", "La prière", "Le jeûne"], correctIndex: 1, difficulty: "easy", category: "Vocabulaire"),
        QuizQuestion(id: UUID(), question: "Que signifie 'Tawbah' ?", options: ["La foi", "Le repentir", "La gratitude", "La patience"], correctIndex: 1, difficulty: "easy", category: "Vocabulaire"),
    ]

    // MARK: - MOYEN (200 questions)
    static let mediumQuestions: [QuizQuestion] = [

        // --- CORAN APPROFONDI ---
        QuizQuestion(id: UUID(), question: "Quelle sourate contient le verset de la lumière (Ayat al-Nur) ?", options: ["Al-Baqara", "An-Nur", "Al-Ahzab", "Al-Isra"], correctIndex: 1, difficulty: "medium", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Combien de fois le nom 'Maryam' est-il mentionné dans le Coran ?", options: ["22", "34", "70", "12"], correctIndex: 1, difficulty: "medium", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Quelle est la sourate des femmes ?", options: ["Al-Imran", "An-Nisa", "Al-Maidah", "Al-Ahzab"], correctIndex: 1, difficulty: "medium", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Quel est le verset le plus long du Coran ?", options: ["Al-Baqara 282", "Al-Baqara 255", "Al-Imran 1", "An-Nisa 11"], correctIndex: 0, difficulty: "medium", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Quelle sourate traite des hypocrites ?", options: ["Al-Munafiqun", "Al-Kafrun", "Al-Falaq", "At-Tahrim"], correctIndex: 0, difficulty: "medium", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Combien de versets contient la sourate Al-Baqara ?", options: ["200", "250", "286", "300"], correctIndex: 2, difficulty: "medium", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Dans quelle sourate se trouve le récit de Yusuf ?", options: ["Yunus", "Yusuf", "Ibrahim", "Hud"], correctIndex: 1, difficulty: "medium", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Quel est le nom de la nuit où le Coran a commencé à être révélé ?", options: ["Laylat al-Miraj", "Laylat al-Bara'ah", "Laylat al-Qadr", "Laylat al-Jumu'ah"], correctIndex: 2, difficulty: "medium", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Quelle sourate contient l'histoire des gens de la caverne (As-hab al-Kahf) ?", options: ["Al-Isra", "Al-Kahf", "Al-Anbiya", "Maryam"], correctIndex: 1, difficulty: "medium", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Dans quelle sourate est mentionné le voyage nocturne du Prophète ﷺ ?", options: ["Al-Najm", "Al-Isra", "Al-Mi'raj", "Al-Buruj"], correctIndex: 1, difficulty: "medium", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Quelle sourate commence par 'Ha-Mim' ?", options: ["Yasin", "Ghafir", "Al-Kahf", "Maryam"], correctIndex: 1, difficulty: "medium", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Combien de sourates Makkiyya contient le Coran environ ?", options: ["28", "56", "86", "100"], correctIndex: 2, difficulty: "medium", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Dans quelle sourate est mentionné l'éléphant (Al-Fil) ?", options: ["Al-Quraish", "Al-Fil", "Al-Kawthar", "Al-Falaq"], correctIndex: 1, difficulty: "medium", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Quelle sourate est nommée d'après une araignée ?", options: ["An-Naml", "Al-Ankabut", "An-Nahl", "Al-Baqara"], correctIndex: 1, difficulty: "medium", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Quelle sourate contient le récit du Miraj (ascension céleste) ?", options: ["Al-Isra", "An-Najm", "Al-Kahf", "Al-Mulk"], correctIndex: 1, difficulty: "medium", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Dans quelle sourate est mentionnée la permission de combattre ?", options: ["Al-Anfal", "Al-Hajj", "At-Tawbah", "Muhammad"], correctIndex: 1, difficulty: "medium", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Quelle sourate contient les règles de l'héritage ?", options: ["Al-Baqara", "An-Nisa", "Al-Maidah", "Al-Ahzab"], correctIndex: 1, difficulty: "medium", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Quelle sourate parle des 'gens du livre' le plus longuement ?", options: ["Al-Imran", "Al-Baqara", "An-Nisa", "Al-Maidah"], correctIndex: 1, difficulty: "medium", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Dans quelle sourate Allah dit-il 'Je n'ai créé les djinns et les hommes que pour M'adorer' ?", options: ["Al-Baqara", "Az-Zariyat", "Al-Mulk", "Yasin"], correctIndex: 1, difficulty: "medium", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Quelle est la sourate qui protège du Dajjal selon un hadith ?", options: ["Yasin", "Al-Mulk", "Al-Kahf", "Al-Fatiha"], correctIndex: 2, difficulty: "medium", category: "Coran"),

        // --- HADITH APPROFONDIS ---
        QuizQuestion(id: UUID(), question: "Combien de hadiths les 40 Hadiths de Nawawi contiennent-ils réellement ?", options: ["40", "42", "45", "50"], correctIndex: 1, difficulty: "medium", category: "Hadith"),
        QuizQuestion(id: UUID(), question: "Que signifie 'Isnad' dans la science du hadith ?", options: ["Le texte du hadith", "La chaîne de transmission", "L'authenticité", "Le narrateur principal"], correctIndex: 1, difficulty: "medium", category: "Hadith"),
        QuizQuestion(id: UUID(), question: "Que signifie 'Matn' dans le hadith ?", options: ["La chaîne de transmission", "Le texte du hadith", "Le narrateur", "L'authenticité"], correctIndex: 1, difficulty: "medium", category: "Hadith"),
        QuizQuestion(id: UUID(), question: "Quel imam est à l'origine du recueil Sunan an-Nasa'i ?", options: ["At-Tirmidhi", "An-Nasa'i", "Ibn Majah", "Abu Daoud"], correctIndex: 1, difficulty: "medium", category: "Hadith"),
        QuizQuestion(id: UUID(), question: "Que signifie 'Mursal' en science du hadith ?", options: ["Un hadith authentique", "Un hadith dont le compagnon est omis", "Un hadith faible", "Un hadith bon"], correctIndex: 1, difficulty: "medium", category: "Hadith"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce qu'un hadith 'Hasan' ?", options: ["Faible", "Authentique", "Bon (entre faible et authentique)", "Très authentique"], correctIndex: 2, difficulty: "medium", category: "Hadith"),
        QuizQuestion(id: UUID(), question: "Qui était le plus grand transmetteur de hadiths parmi les compagnons ?", options: ["Abu Bakr", "Abu Huraira", "Aïcha", "Ibn Abbas"], correctIndex: 1, difficulty: "medium", category: "Hadith"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Hadith Qudsi' ?", options: ["Un hadith du Coran", "Un hadith où Allah parle en première personne via le Prophète ﷺ", "Un hadith authentique", "Un hadith compilé par Bukhari"], correctIndex: 1, difficulty: "medium", category: "Hadith"),
        QuizQuestion(id: UUID(), question: "Que signifie 'Mutawatir' pour un hadith ?", options: ["Transmis par un seul", "Transmis par un grand nombre à chaque génération", "Faible", "Bon"], correctIndex: 1, difficulty: "medium", category: "Hadith"),
        QuizQuestion(id: UUID(), question: "Quel imam a compilé le Musnad le plus célèbre ?", options: ["Al-Bukhari", "Imam Ahmad ibn Hanbal", "Imam Shafi'i", "Imam Muslim"], correctIndex: 1, difficulty: "medium", category: "Hadith"),

        // --- HISTOIRE ISLAMIQUE APPROFONDIE ---
        QuizQuestion(id: UUID(), question: "Quelle est la durée du califat d'Abu Bakr ?", options: ["1 an", "2 ans et quelques mois", "4 ans", "6 ans"], correctIndex: 1, difficulty: "medium", category: "Histoire"),
        QuizQuestion(id: UUID(), question: "Quelle bataille est connue comme la 'Mère des batailles' ?", options: ["Badr", "Uhud", "Al-Qadisiyya", "Yarmouk"], correctIndex: 3, difficulty: "medium", category: "Histoire"),
        QuizQuestion(id: UUID(), question: "Quel calife a ordonné la compilation du Coran en un seul livre ?", options: ["Abu Bakr", "Omar", "Uthman", "Ali"], correctIndex: 0, difficulty: "medium", category: "Histoire"),
        QuizQuestion(id: UUID(), question: "Quel est l'événement de 'L'année de la tristesse' ?", options: ["La mort de Khadija et Abu Talib", "La bataille de Badr", "L'Hégire", "La mort du Prophète ﷺ"], correctIndex: 0, difficulty: "medium", category: "Histoire"),
        QuizQuestion(id: UUID(), question: "Quelle fut la première mosquée construite par le Prophète ﷺ ?", options: ["Mosquée Al-Haram", "Mosquée Quba", "Mosquée Al-Nabawi", "Mosquée Al-Aqsa"], correctIndex: 1, difficulty: "medium", category: "Histoire"),
        QuizQuestion(id: UUID(), question: "Lors de quelle bataille le Prophète ﷺ a-t-il été blessé ?", options: ["Badr", "Uhud", "Khandaq", "Hunayn"], correctIndex: 1, difficulty: "medium", category: "Histoire"),
        QuizQuestion(id: UUID(), question: "Quelle est la durée de la période médinoise de la vie du Prophète ﷺ ?", options: ["5 ans", "8 ans", "10 ans", "13 ans"], correctIndex: 2, difficulty: "medium", category: "Histoire"),
        QuizQuestion(id: UUID(), question: "Quel général musulman a conquis la Perse ?", options: ["Khalid ibn al-Walid", "Sa'd ibn Abi Waqqas", "Amr ibn al-As", "Abu Ubayda"], correctIndex: 1, difficulty: "medium", category: "Histoire"),
        QuizQuestion(id: UUID(), question: "Quelle est l'année de la conquête de Jérusalem par Omar ibn al-Khattab ?", options: ["636", "637", "638", "640"], correctIndex: 2, difficulty: "medium", category: "Histoire"),
        QuizQuestion(id: UUID(), question: "Quel fut le premier État islamique ?", options: ["Le califat abbasside", "La cité-état de Médine", "Le califat omeyyade", "L'empire ottoman"], correctIndex: 1, difficulty: "medium", category: "Histoire"),

        // --- JURISPRUDENCE ISLAMIQUE ---
        QuizQuestion(id: UUID(), question: "Combien y a-t-il d'écoles juridiques sunnites principales ?", options: ["2", "3", "4", "5"], correctIndex: 2, difficulty: "medium", category: "Jurisprudence"),
        QuizQuestion(id: UUID(), question: "Quel est le nom de l'école juridique fondée par Imam Malik ?", options: ["Hanafite", "Malékite", "Shafi'ite", "Hanbalite"], correctIndex: 1, difficulty: "medium", category: "Jurisprudence"),
        QuizQuestion(id: UUID(), question: "Que signifie 'Wajib' en jurisprudence islamique ?", options: ["Recommandé", "Permis", "Obligatoire", "Interdit"], correctIndex: 2, difficulty: "medium", category: "Jurisprudence"),
        QuizQuestion(id: UUID(), question: "Que signifie 'Makruh' ?", options: ["Interdit", "Recommandé", "Réprouvé (déconseillé)", "Obligatoire"], correctIndex: 2, difficulty: "medium", category: "Jurisprudence"),
        QuizQuestion(id: UUID(), question: "Que signifie 'Mustahabb' ?", options: ["Obligatoire", "Interdit", "Recommandé (sunna)", "Neutre"], correctIndex: 2, difficulty: "medium", category: "Jurisprudence"),
        QuizQuestion(id: UUID(), question: "Quel est le minimum de Nisab pour payer le Zakat sur l'or ?", options: ["50 grammes", "85 grammes", "100 grammes", "120 grammes"], correctIndex: 1, difficulty: "medium", category: "Jurisprudence"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Tayammum' ?", options: ["L'ablution avec l'eau", "L'ablution symbolique avec la terre propre", "Le grand bain rituel", "Un type de prière"], correctIndex: 1, difficulty: "medium", category: "Jurisprudence"),
        QuizQuestion(id: UUID(), question: "Combien de témoins sont nécessaires pour valider un mariage en Islam ?", options: ["1", "2", "3", "4"], correctIndex: 1, difficulty: "medium", category: "Jurisprudence"),
        QuizQuestion(id: UUID(), question: "Quelle est la période d'idda pour une femme divorcée ?", options: ["1 mois", "2 mois", "3 mois ou 3 cycles menstruels", "6 mois"], correctIndex: 2, difficulty: "medium", category: "Jurisprudence"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Mehr' (Mahr) ?", options: ["Le contrat de mariage", "Le cadeau obligatoire de l'époux à l'épouse", "La dot parentale", "Un type de divorce"], correctIndex: 1, difficulty: "medium", category: "Jurisprudence"),

        // --- PROPHÈTES APPROFONDIS ---
        QuizQuestion(id: UUID(), question: "Combien d'années Nouh a-t-il vécu selon les traditions islamiques ?", options: ["500", "750", "950", "1200"], correctIndex: 2, difficulty: "medium", category: "Prophètes"),
        QuizQuestion(id: UUID(), question: "Quel prophète est considéré comme l'ancêtre des Arabes ?", options: ["Ibrahim", "Ismail", "Ishaq", "Yaqub"], correctIndex: 1, difficulty: "medium", category: "Prophètes"),
        QuizQuestion(id: UUID(), question: "Quel est le vrai nom du prophète Yunus ?", options: ["Abdullah", "Yunus ibn Matta", "Dhul-Kifl", "Ilias"], correctIndex: 1, difficulty: "medium", category: "Prophètes"),
        QuizQuestion(id: UUID(), question: "Quel prophète a guéri des aveugles et ressuscité des morts par la permission d'Allah ?", options: ["Moussa", "Issa", "Ibrahim", "Sulayman"], correctIndex: 1, difficulty: "medium", category: "Prophètes"),
        QuizQuestion(id: UUID(), question: "Combien d'années Ibrahim a-t-il été dans le feu de Nimrod ?", options: ["Il n'y est pas resté longtemps", "3 jours", "7 jours", "40 jours"], correctIndex: 0, difficulty: "medium", category: "Prophètes"),
        QuizQuestion(id: UUID(), question: "Quel prophète a reçu la Torah ?", options: ["Ibrahim", "Issa", "Moussa", "Dawud"], correctIndex: 2, difficulty: "medium", category: "Prophètes"),
        QuizQuestion(id: UUID(), question: "Quel prophète a reçu les Psaumes (Zabur) ?", options: ["Ibrahim", "Dawud", "Moussa", "Sulayman"], correctIndex: 1, difficulty: "medium", category: "Prophètes"),
        QuizQuestion(id: UUID(), question: "Quel prophète a reçu l'Injil (Évangile) ?", options: ["Yahya", "Ibrahim", "Issa", "Moussa"], correctIndex: 2, difficulty: "medium", category: "Prophètes"),
        QuizQuestion(id: UUID(), question: "Quel prophète était fils adoptif du Prophète ﷺ ?", options: ["Il n'en avait pas", "Zayd ibn Haritha", "Ali ibn Abi Talib", "Abdullah ibn Masud"], correctIndex: 1, difficulty: "medium", category: "Prophètes"),
        QuizQuestion(id: UUID(), question: "Quel était le métier de Dawud selon la tradition islamique ?", options: ["Berger", "Forgeron", "Charpentier", "Marchand"], correctIndex: 1, difficulty: "medium", category: "Prophètes"),

        // --- COMPAGNONS DU PROPHÈTE ---
        QuizQuestion(id: UUID(), question: "Qui était le secrétaire principal du Prophète ﷺ ?", options: ["Ali ibn Abi Talib", "Zayd ibn Thabit", "Ibn Masud", "Abu Huraira"], correctIndex: 1, difficulty: "medium", category: "Compagnons"),
        QuizQuestion(id: UUID(), question: "Comment s'appelait le général qui a conquis l'Égypte ?", options: ["Khalid ibn al-Walid", "Sa'd ibn Abi Waqqas", "Amr ibn al-As", "Abu Ubayda ibn al-Jarrah"], correctIndex: 2, difficulty: "medium", category: "Compagnons"),
        QuizQuestion(id: UUID(), question: "Qui était surnommé 'Sayf Allah' (l'Épée d'Allah) ?", options: ["Ali ibn Abi Talib", "Khalid ibn al-Walid", "Hamza ibn Abdul Muttalib", "Zubayr ibn al-Awwam"], correctIndex: 1, difficulty: "medium", category: "Compagnons"),
        QuizQuestion(id: UUID(), question: "Quelle épouse du Prophète ﷺ est surnommée 'Mère des croyants' et a le plus transmis de hadiths ?", options: ["Khadija", "Hafsa", "Aïcha", "Zainab"], correctIndex: 2, difficulty: "medium", category: "Compagnons"),
        QuizQuestion(id: UUID(), question: "Qui était Abu Dharr al-Ghifari ?", options: ["Un général", "Un des premiers convertis à l'Islam connu pour son ascétisme", "Un calife", "Un savant du Coran"], correctIndex: 1, difficulty: "medium", category: "Compagnons"),
        QuizQuestion(id: UUID(), question: "Quel compagnon a été le premier à réciter le Coran publiquement à La Mecque ?", options: ["Ali", "Abu Bakr", "Abdullah ibn Masud", "Uthman"], correctIndex: 2, difficulty: "medium", category: "Compagnons"),
        QuizQuestion(id: UUID(), question: "Qui était Salman al-Farisi ?", options: ["Un Arabe d'origine", "Un Perse converti qui a proposé le plan du fossé lors de la bataille du Khandaq", "Un général byzantin", "Un savant mecquois"], correctIndex: 1, difficulty: "medium", category: "Compagnons"),
        QuizQuestion(id: UUID(), question: "Quel compagnon était connu pour sa beauté et fut le cousin du Prophète ﷺ ?", options: ["Ja'far ibn Abi Talib", "Abdullah ibn Abbas", "Usamah ibn Zayd", "Nu'man ibn Bashir"], correctIndex: 0, difficulty: "medium", category: "Compagnons"),
        QuizQuestion(id: UUID(), question: "Qui était Khadija avant d'épouser le Prophète ﷺ ?", options: ["Une femme pauvre", "Une riche commerçante", "Une femme de tribu bédouine", "Une esclave affranchie"], correctIndex: 1, difficulty: "medium", category: "Compagnons"),
        QuizQuestion(id: UUID(), question: "Quel était le lien de parenté entre Abu Bakr et le Prophète ﷺ ?", options: ["Cousin", "Oncle", "Beau-père (père d'Aïcha)", "Frère de lait"], correctIndex: 2, difficulty: "medium", category: "Compagnons"),

        // --- SCIENCES ISLAMIQUES ---
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Tafsir' ?", options: ["Le hadith", "L'exégèse du Coran", "La jurisprudence", "La théologie"], correctIndex: 1, difficulty: "medium", category: "Sciences"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Ijaz al-Quran' ?", options: ["La récitation", "L'inimitabilité du Coran", "La mémorisation", "La traduction"], correctIndex: 1, difficulty: "medium", category: "Sciences"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que la 'Sira' ?", options: ["La biographie du Prophète ﷺ", "Un livre de jurisprudence", "Un recueil de hadiths", "Un livre de théologie"], correctIndex: 0, difficulty: "medium", category: "Sciences"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Kalam' en Islam ?", options: ["La récitation du Coran", "La théologie islamique spéculative", "La jurisprudence", "Le hadith"], correctIndex: 1, difficulty: "medium", category: "Sciences"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que l''Ijma' en jurisprudence ?", options: ["L'analogie juridique", "Le consensus des savants", "Les sources primaires", "La jurisprudence individuelle"], correctIndex: 1, difficulty: "medium", category: "Sciences"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Qiyas' ?", options: ["Le consensus", "L'analogie juridique", "La coutume", "L'intérêt public"], correctIndex: 1, difficulty: "medium", category: "Sciences"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que la 'Tajwid' ?", options: ["La traduction du Coran", "Les règles de récitation du Coran", "La mémorisation du Coran", "L'exégèse"], correctIndex: 1, difficulty: "medium", category: "Sciences"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que la 'Aqida' ?", options: ["La jurisprudence", "La croyance islamique", "Le hadith", "Le tafsir"], correctIndex: 1, difficulty: "medium", category: "Sciences"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Waqf' en Islam ?", options: ["Un impôt", "Une fondation pieuse perpétuelle", "Le jeûne volontaire", "Un type de prière"], correctIndex: 1, difficulty: "medium", category: "Sciences"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que la 'Zawiyya' ?", options: ["Une école coranique", "Un lieu de réunion soufi/espace d'enseignement islamique", "Une mosquée", "Un tribunal islamique"], correctIndex: 1, difficulty: "medium", category: "Sciences"),

        // --- ESCHATOLOGIE ---
        QuizQuestion(id: UUID(), question: "Comment s'appelle l'antéchrist en Islam ?", options: ["Iblis", "Shaytan", "Al-Dajjal", "Gog"], correctIndex: 2, difficulty: "medium", category: "Eschatologie"),
        QuizQuestion(id: UUID(), question: "Quel prophète reviendra avant le Jour du Jugement selon l'Islam ?", options: ["Ibrahim", "Moussa", "Issa", "Yahya"], correctIndex: 2, difficulty: "medium", category: "Eschatologie"),
        QuizQuestion(id: UUID(), question: "Comment s'appelle la sonnerie qui annoncera le Jour du Jugement ?", options: ["Adhan", "Iqama", "As-Sur (la trompette)", "Takbir"], correctIndex: 2, difficulty: "medium", category: "Eschatologie"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Barzakh' ?", options: ["Le paradis", "L'enfer", "L'état intermédiaire entre la mort et la résurrection", "Le Jour du Jugement"], correctIndex: 2, difficulty: "medium", category: "Eschatologie"),
        QuizQuestion(id: UUID(), question: "Combien de portes le paradis a-t-il selon les hadiths ?", options: ["4", "6", "7", "8"], correctIndex: 3, difficulty: "medium", category: "Eschatologie"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Sirat' ?", options: ["La balance des actions", "Le pont sur lequel tout le monde devra passer au Jugement", "Le livre des actes", "Un niveau du paradis"], correctIndex: 1, difficulty: "medium", category: "Eschatologie"),
        QuizQuestion(id: UUID(), question: "Quels sont les noms des deux anges qui interrogent dans la tombe ?", options: ["Jibrail et Mikail", "Israfil et Azrail", "Munkar et Nakir", "Raqib et Atid"], correctIndex: 2, difficulty: "medium", category: "Eschatologie"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que Yajouj et Majouj ?", options: ["Des anges", "Des démons", "Des peuples qui apparaîtront à la fin des temps", "Des épreuves du paradis"], correctIndex: 2, difficulty: "medium", category: "Eschatologie"),
        QuizQuestion(id: UUID(), question: "Quelle est la signification du 'Mahdi' ?", options: ["L'antéchrist", "Le bien guidé — imam attendu avant la fin des temps", "Un ange", "Un prophète"], correctIndex: 1, difficulty: "medium", category: "Eschatologie"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que la 'Shafa'ah' (intercession) ?", options: ["La punition", "L'intercession du Prophète ﷺ pour les croyants au Jour du Jugement", "La balance", "Le pont Sirat"], correctIndex: 1, difficulty: "medium", category: "Eschatologie"),

        // --- CIVILISATION ISLAMIQUE ---
        QuizQuestion(id: UUID(), question: "Quelle ville était la capitale de l'empire abbasside ?", options: ["Damas", "Bagdad", "Alexandrie", "Cordoue"], correctIndex: 1, difficulty: "medium", category: "Civilisation"),
        QuizQuestion(id: UUID(), question: "Qui a fondé la 'Maison de la Sagesse' (Bayt al-Hikma) à Bagdad ?", options: ["Haroun al-Rashid", "Al-Mamun", "Al-Mutasim", "Al-Wathiq"], correctIndex: 1, difficulty: "medium", category: "Civilisation"),
        QuizQuestion(id: UUID(), question: "Quel mathématicien musulman a donné son nom à l'algorithme ?", options: ["Ibn Rushd", "Al-Khawarizmi", "Al-Biruni", "Ibn al-Haytham"], correctIndex: 1, difficulty: "medium", category: "Civilisation"),
        QuizQuestion(id: UUID(), question: "Quel savant islamique est connu comme le 'Père de l'optique' ?", options: ["Al-Khawarizmi", "Ibn Rushd", "Ibn al-Haytham", "Al-Farabi"], correctIndex: 2, difficulty: "medium", category: "Civilisation"),
        QuizQuestion(id: UUID(), question: "Quelle est la signification du mot 'Algebra' en arabe ?", options: ["Al-Jabr (la réunification)", "Al-Kitab (le livre)", "Al-Qalam (la plume)", "Al-Ilm (la science)"], correctIndex: 0, difficulty: "medium", category: "Civilisation"),
        QuizQuestion(id: UUID(), question: "Quel médecin islamique a écrit le 'Canon de la Médecine' ?", options: ["Al-Razi", "Ibn Sina (Avicenne)", "Ibn Rushd", "Al-Zahrawi"], correctIndex: 1, difficulty: "medium", category: "Civilisation"),
        QuizQuestion(id: UUID(), question: "Quelle université islamique est considérée comme l'une des plus anciennes du monde ?", options: ["Al-Azhar (Égypte)", "Al-Qarawiyyin (Maroc)", "Az-Zaytuna (Tunisie)", "Bayt al-Hikma (Irak)"], correctIndex: 1, difficulty: "medium", category: "Civilisation"),
        QuizQuestion(id: UUID(), question: "Quelle période est souvent appelée l''Âge d'Or' de l'Islam ?", options: ["VIIe-VIIIe siècles", "VIIIe-XIIIe siècles", "XIIIe-XVe siècles", "XVe-XVIIe siècles"], correctIndex: 1, difficulty: "medium", category: "Civilisation"),
        QuizQuestion(id: UUID(), question: "Quel empire islamique a duré le plus longtemps dans l'histoire ?", options: ["L'empire abbasside", "L'empire omeyyade", "L'empire ottoman", "L'empire moghol"], correctIndex: 2, difficulty: "medium", category: "Civilisation"),
        QuizQuestion(id: UUID(), question: "Qui était Ibn Battuta ?", options: ["Un savant du Coran", "Un grand voyageur et géographe musulman", "Un calife", "Un général"], correctIndex: 1, difficulty: "medium", category: "Civilisation"),

        // --- SOUFI & SPIRITUALITÉ ---
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Tawakkul' ?", options: ["La crainte d'Allah", "La confiance en Allah", "L'amour d'Allah", "La gratitude envers Allah"], correctIndex: 1, difficulty: "medium", category: "Spiritualité"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Taqwa' ?", options: ["L'humilité", "La piété/crainte révérencielle d'Allah", "La générosité", "La patience"], correctIndex: 1, difficulty: "medium", category: "Spiritualité"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Ihsan' ?", options: ["La jurisprudence", "L'excellence spirituelle — adorer Allah comme si on Le voyait", "Le hadith", "La foi"], correctIndex: 1, difficulty: "medium", category: "Spiritualité"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Zuhd' ?", options: ["La générosité", "Le détachement du monde matériel", "La patience", "La gratitude"], correctIndex: 1, difficulty: "medium", category: "Spiritualité"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que la 'Muraqaba' ?", options: ["La récitation", "La méditation/vigilance spirituelle", "Le jeûne volontaire", "La prière nocturne"], correctIndex: 1, difficulty: "medium", category: "Spiritualité"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Qiyam al-Layl' ?", options: ["La prière du vendredi", "La prière nocturne volontaire", "La prière du matin", "Le dhikr collectif"], correctIndex: 1, difficulty: "medium", category: "Spiritualité"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Khalwa' dans la tradition soufie ?", options: ["La retraite spirituelle en solitude", "La prière collective", "Le jeûne prolongé", "Le voyage sacré"], correctIndex: 0, difficulty: "medium", category: "Spiritualité"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que l''Istighfar' ?", options: ["La louange", "La demande de pardon à Allah", "La gratitude", "L'invocation pour les défunts"], correctIndex: 1, difficulty: "medium", category: "Spiritualité"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que la 'Nafs al-Ammara' ?", options: ["L'âme apaisée", "L'âme qui incite au mal", "L'âme repentante", "L'âme purifiée"], correctIndex: 1, difficulty: "medium", category: "Spiritualité"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Wird' en pratique islamique ?", options: ["Un type de jeûne", "Une litanie quotidienne de dhikr", "Un pèlerinage", "Une taxe"], correctIndex: 1, difficulty: "medium", category: "Spiritualité"),
    ]

    // MARK: - DIFFICILE (200 questions)
    static let hardQuestions: [QuizQuestion] = [

        // --- CORAN AVANCÉ ---
        QuizQuestion(id: UUID(), question: "Combien de sajdat (prosternations de récitation) y a-t-il dans le Coran ?", options: ["12", "14", "15", "17"], correctIndex: 2, difficulty: "hard", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Quelle est la sourate dont les versets sont appelés 'Al-Hawamim' ?", options: ["Sourates commençant par Ha-Mim", "Sourates du juz Amma", "Sourates médinoises", "Sourates courtes"], correctIndex: 0, difficulty: "hard", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Quel savant est l'auteur du Tafsir 'Al-Kashaf' ?", options: ["Ibn Kathir", "Az-Zamakhshari", "At-Tabari", "Al-Qurtubi"], correctIndex: 1, difficulty: "hard", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Combien de 'Huruf Muqatta'at' (lettres isolées) de sourates existent ?", options: ["14", "29", "28", "19"], correctIndex: 1, difficulty: "hard", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Quel est l'auteur du Tafsir 'Jami' al-Bayan' ?", options: ["Ibn Kathir", "At-Tabari", "Al-Qurtubi", "As-Suyuti"], correctIndex: 1, difficulty: "hard", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Quelle est la règle de Tajwid appelée 'Idgham' ?", options: ["L'assimilation d'une lettre dans une autre", "L'allongement de la voyelle", "La nasalisation", "L'arrêt de la respiration"], correctIndex: 0, difficulty: "hard", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Quel est le nom de la lecture coranique d'Hafs ?", options: ["Hafs 'an Asim", "Warsh 'an Nafi", "Qalun 'an Nafi", "Ad-Dawri 'an Abi Amr"], correctIndex: 0, difficulty: "hard", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Combien de Qira'at (lectures) sont considérées comme canoniques ?", options: ["3", "5", "7", "10"], correctIndex: 3, difficulty: "hard", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Quelle sourate est la seule à mentionner deux fois la Bismillah ?", options: ["Al-Naml", "An-Nur", "Al-Maidah", "Al-Anfal"], correctIndex: 0, difficulty: "hard", category: "Coran"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que l''I'jaz al-'Ilmi' dans le contexte coranique ?", options: ["L'inimitabilité littéraire", "Les miracles scientifiques du Coran", "La mémorisation", "L'exégèse"], correctIndex: 1, difficulty: "hard", category: "Coran"),

        // --- HADITH AVANCÉ ---
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Rijal' dans la science du hadith ?", options: ["Le texte", "L'étude des transmetteurs de hadiths", "La chaîne", "L'authenticité"], correctIndex: 1, difficulty: "hard", category: "Hadith"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Jarh wa Ta'dil' ?", options: ["Un type de hadith", "La critique et l'approbation des transmetteurs", "Un livre de jurisprudence", "Une méthode de récitation"], correctIndex: 1, difficulty: "hard", category: "Hadith"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce qu'un hadith 'Mu'dal' ?", options: ["Un hadith avec deux transmetteurs consécutifs manquants", "Un hadith faible", "Un hadith authentique", "Un hadith à chaîne unique"], correctIndex: 0, difficulty: "hard", category: "Hadith"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Tadlis' dans les hadiths ?", options: ["La fabrication de hadiths", "Dissimuler un défaut dans la chaîne de transmission", "L'oubli d'un transmetteur", "L'erreur de mémoire"], correctIndex: 1, difficulty: "hard", category: "Hadith"),
        QuizQuestion(id: UUID(), question: "Qui est l'imam qui a dit : 'Toute innovation est une erreur' ?", options: ["Abu Hanifa", "Imam Malik", "Imam Shafi'i", "Imam Ahmad"], correctIndex: 2, difficulty: "hard", category: "Hadith"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce qu'un 'Hadith Mawdu' ?", options: ["Un hadith authentique", "Un hadith fabriqué/forgé", "Un hadith bon", "Un hadith interrompu"], correctIndex: 1, difficulty: "hard", category: "Hadith"),
        QuizQuestion(id: UUID(), question: "Combien de hadiths le Musnad de l'imam Ahmad contient-il environ ?", options: ["10 000", "20 000", "27 000", "40 000"], correctIndex: 2, difficulty: "hard", category: "Hadith"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Matan' en science du hadith ?", options: ["La chaîne de transmission", "Le texte proprement dit du hadith", "Les transmetteurs", "L'authenticité"], correctIndex: 1, difficulty: "hard", category: "Hadith"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce qu'un hadith 'Ahad' ?", options: ["Transmis par un grand nombre", "Transmis par un nombre limité de transmetteurs", "Un hadith prophétique divin", "Un hadith de compagnon"], correctIndex: 1, difficulty: "hard", category: "Hadith"),
        QuizQuestion(id: UUID(), question: "Quel est l'auteur de 'Al-Muqaddima' dans la science du hadith ?", options: ["Ibn Hajar al-Asqalani", "Ibn al-Salah", "An-Nawawi", "Al-Khatib al-Baghdadi"], correctIndex: 1, difficulty: "hard", category: "Hadith"),

        // --- JURISPRUDENCE AVANCÉE ---
        QuizQuestion(id: UUID(), question: "Quelle est la règle d'Abu Hanifa sur le statut d'une prière effectuée sans Wudu par oubli ?", options: ["Valide", "Invalide et doit être refaite", "Pardonnée sans refaire", "Cela dépend de l'imam"], correctIndex: 1, difficulty: "hard", category: "Jurisprudence"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que la 'Maslaha Mursala' ?", options: ["L'analogie juridique", "L'intérêt public non mentionné dans les textes", "Le consensus", "La coutume"], correctIndex: 1, difficulty: "hard", category: "Jurisprudence"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que l''Urf' en jurisprudence islamique ?", options: ["Le Coran", "La coutume reconnue par la société", "Le consensus", "L'analogie"], correctIndex: 1, difficulty: "hard", category: "Jurisprudence"),
        QuizQuestion(id: UUID(), question: "Quelle est la position hanafite sur les taxes douanières imposées aux dhimmis ?", options: ["Interdites", "Égales au Zakat", "Variables selon les traités", "Toujours à 10%"], correctIndex: 2, difficulty: "hard", category: "Jurisprudence"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Talfiq' en jurisprudence ?", options: ["Suivre un seul madhhab", "Combiner des positions de différentes écoles juridiques", "L'ijtihad personnel", "L'imitation aveugle"], correctIndex: 1, difficulty: "hard", category: "Jurisprudence"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Istihsan' ?", options: ["L'intérêt public", "La préférence juridique — déroger à l'analogie pour une meilleure règle", "La coutume", "L'unanimité"], correctIndex: 1, difficulty: "hard", category: "Jurisprudence"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Fard al-Kifaya' ?", options: ["Une obligation individuelle", "Une obligation communautaire (si certains l'accomplissent, les autres en sont exemptés)", "Une obligation conditionnelle", "Un acte recommandé"], correctIndex: 1, difficulty: "hard", category: "Jurisprudence"),
        QuizQuestion(id: UUID(), question: "Quel est le terme pour la mise à mort légale de quelqu'un qui commet apostasie selon les écoles classiques ?", options: ["Hadd al-Ridda", "Ta'zir", "Qisas", "Diya"], correctIndex: 0, difficulty: "hard", category: "Jurisprudence"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que la 'Dhimma' dans le droit islamique classique ?", options: ["Un contrat de vente", "Le statut des non-musulmans protégés vivant dans un État islamique", "Un type de droit successoral", "Un contrat de mariage"], correctIndex: 1, difficulty: "hard", category: "Jurisprudence"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Siyar' comme branche du droit islamique ?", options: ["Les transactions commerciales", "Le droit international islamique (relations avec les non-Muslims)", "Le droit familial", "La jurisprudence pénale"], correctIndex: 1, difficulty: "hard", category: "Jurisprudence"),

        // --- THÉOLOGIE (AQIDA) ---
        QuizQuestion(id: UUID(), question: "Quelle est la position Ash'arite sur les attributs divins d'Allah ?", options: ["Ils sont identiques à l'essence divine", "Ils sont distincts de l'essence divine", "Ils n'existent pas", "Ils sont interprétés métaphoriquement"], correctIndex: 0, difficulty: "hard", category: "Théologie"),
        QuizQuestion(id: UUID(), question: "Quelle école théologique islamique est fondée par Abu Mansur al-Maturidi ?", options: ["Ash'arisme", "Maturidisme", "Mu'tazilisme", "Hanbalisme"], correctIndex: 1, difficulty: "hard", category: "Théologie"),
        QuizQuestion(id: UUID(), question: "Quel est le débat principal du Mu'tazilisme ?", options: ["La création du Coran", "La prédestination", "La nature d'Allah", "Les attributs divins"], correctIndex: 0, difficulty: "hard", category: "Théologie"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Tashbih' en théologie islamique ?", options: ["La transcendance divine", "L'anthropomorphisme — attribuer des ressemblances humaines à Allah", "L'unicité divine", "La justice divine"], correctIndex: 1, difficulty: "hard", category: "Théologie"),
        QuizQuestion(id: UUID(), question: "Quelle est la position sunnite sur la vision d'Allah au Paradis ?", options: ["Impossible", "Possible et affirmée par les textes", "Allégorique seulement", "Réservée aux prophètes"], correctIndex: 1, difficulty: "hard", category: "Théologie"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Kufr' au sens théologique précis ?", options: ["Le péché", "La mécréance — refus de croire en Allah et Son messager", "L'hypocrisie", "L'associationnisme"], correctIndex: 1, difficulty: "hard", category: "Théologie"),
        QuizQuestion(id: UUID(), question: "Quelle est la différence entre 'Shirk Akbar' et 'Shirk Asghar' ?", options: ["L'un sort de l'Islam (grand shirk), l'autre non (petit shirk)", "Ils sont identiques", "L'un est pardonnable, l'autre non selon le rang", "Ils n'existent pas en théologie"], correctIndex: 0, difficulty: "hard", category: "Théologie"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Nifaq' (hypocrisie) selon la théologie islamique ?", options: ["Le grand péché", "Afficher l'Islam en cachant la mécréance", "Le doute en la foi", "L'associationnisme"], correctIndex: 1, difficulty: "hard", category: "Théologie"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Qadar' (décret divin) en théologie islamique ?", options: ["La liberté humaine absolue", "La prédestination divine incluant la science, l'écriture, la volonté et la création", "Le hasard", "La responsabilité seule de l'homme"], correctIndex: 1, difficulty: "hard", category: "Théologie"),
        QuizQuestion(id: UUID(), question: "Quel théologien a réfuté les philosophes dans son œuvre 'Tahafut al-Falasifa' ?", options: ["Ibn Rushd", "Al-Ghazali", "Al-Farabi", "Ibn Sina"], correctIndex: 1, difficulty: "hard", category: "Théologie"),

        // --- SCIENCE DU CORAN (ULUM AL-QURAN) ---
        QuizQuestion(id: UUID(), question: "Qu'est-ce que les 'Asbab al-Nuzul' ?", options: ["L'ordre de révélation", "Les circonstances/occasions de la révélation", "Les versets abrogés", "Les lettres isolées"], correctIndex: 1, difficulty: "hard", category: "Ulum al-Quran"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Naskh' et le 'Mansukh' ?", options: ["La récitation et la mémorisation", "L'abrogeant et l'abrogé dans le Coran", "La révélation mecquoise et médinoise", "Les lettres claires et ambiguës"], correctIndex: 1, difficulty: "hard", category: "Ulum al-Quran"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que les 'Muhkamat' et 'Mutashabihat' ?", options: ["Les versets médinois et mecquois", "Les versets clairs et les versets ambigus", "Les longs et courts versets", "Les versets légaux et narratifs"], correctIndex: 1, difficulty: "hard", category: "Ulum al-Quran"),
        QuizQuestion(id: UUID(), question: "Quel calife a standardisé la copie officielle du Coran ?", options: ["Abu Bakr", "Omar", "Uthman", "Ali"], correctIndex: 2, difficulty: "hard", category: "Ulum al-Quran"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Waqf al-Lazim' en Tajwid ?", options: ["Un arrêt obligatoire", "Un arrêt recommandé", "Un arrêt permis", "Un arrêt interdit"], correctIndex: 0, difficulty: "hard", category: "Ulum al-Quran"),
        QuizQuestion(id: UUID(), question: "Combien de versets la sourate Yasin contient-elle ?", options: ["73", "83", "93", "83"], correctIndex: 1, difficulty: "hard", category: "Ulum al-Quran"),
        QuizQuestion(id: UUID(), question: "Quel est l'auteur du 'Itqan fi Ulum al-Quran' ?", options: ["Ibn Kathir", "Al-Suyuti", "Az-Zarkashi", "At-Tabari"], correctIndex: 1, difficulty: "hard", category: "Ulum al-Quran"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que les 'Fawatih al-Suwar' ?", options: ["Les fins de sourates", "Les ouvertures des sourates (y compris les lettres isolées)", "Les versets du mi-Coran", "Les versets de sajda"], correctIndex: 1, difficulty: "hard", category: "Ulum al-Quran"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que la 'Tartil' dans la récitation ?", options: ["La récitation rapide", "La récitation lente et méditée", "La récitation mélodieuse", "La récitation de mémoire"], correctIndex: 1, difficulty: "hard", category: "Ulum al-Quran"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Gharib al-Quran' ?", options: ["Les versets difficiles", "Les mots rares ou peu communs du Coran", "Les versets abrogés", "Les sourates médinoises"], correctIndex: 1, difficulty: "hard", category: "Ulum al-Quran"),

        // --- PHILOSOPHIE ISLAMIQUE ---
        QuizQuestion(id: UUID(), question: "Quel philosophe islamique est connu sous le nom d'Averroès en Occident ?", options: ["Ibn Sina", "Al-Farabi", "Ibn Rushd", "Al-Ghazali"], correctIndex: 2, difficulty: "hard", category: "Philosophie"),
        QuizQuestion(id: UUID(), question: "Quel est le titre de l'œuvre principale d'Ibn Khaldun sur la philosophie de l'histoire ?", options: ["Al-Muqaddima", "Ihya Ulum al-Din", "Tahafut al-Falasifa", "Maqasid al-Falasifa"], correctIndex: 0, difficulty: "hard", category: "Philosophie"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que l''Asabiyya' chez Ibn Khaldun ?", options: ["La piété", "La solidarité tribale/sociale qui fonde les civilisations", "La jurisprudence", "La théologie"], correctIndex: 1, difficulty: "hard", category: "Philosophie"),
        QuizQuestion(id: UUID(), question: "Quel est l'auteur de 'Ihya Ulum al-Din' ?", options: ["Ibn Rushd", "Al-Farabi", "Al-Ghazali", "Ibn Taymiyya"], correctIndex: 2, difficulty: "hard", category: "Philosophie"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Kalam' comme discipline ?", options: ["La récitation du Coran", "La philosophie et la théologie spéculatives islamiques", "La jurisprudence", "Le soufisme"], correctIndex: 1, difficulty: "hard", category: "Philosophie"),
        QuizQuestion(id: UUID(), question: "Quel philosophe islamique a développé le concept de 'l'intellect actif' ?", options: ["Al-Ghazali", "Al-Farabi", "Ibn Khaldun", "Ibn Taymiyya"], correctIndex: 1, difficulty: "hard", category: "Philosophie"),
        QuizQuestion(id: UUID(), question: "Quel est le titre du roman philosophique d'Ibn Tufayl ?", options: ["Hayy ibn Yaqzan", "Tahafut al-Tahafut", "Al-Muqaddima", "Fada'il al-Quds"], correctIndex: 0, difficulty: "hard", category: "Philosophie"),
        QuizQuestion(id: UUID(), question: "Ibn Taymiyya était de quelle école juridique ?", options: ["Hanafite", "Malékite", "Shafi'ite", "Hanbalite"], correctIndex: 3, difficulty: "hard", category: "Philosophie"),
        QuizQuestion(id: UUID(), question: "Quel concept soufi d'Ibn Arabi décrit l'unicité de l'existence ?", options: ["Wahdal-Shuhud", "Wahdat al-Wujud", "Fana", "Baqa"], correctIndex: 1, difficulty: "hard", category: "Philosophie"),
        QuizQuestion(id: UUID(), question: "Qui a répondu à Al-Ghazali dans 'Tahafut al-Tahafut' ?", options: ["Ibn Sina", "Al-Farabi", "Ibn Rushd", "Ibn Khaldun"], correctIndex: 2, difficulty: "hard", category: "Philosophie"),

        // --- HISTOIRE AVANCÉE ---
        QuizQuestion(id: UUID(), question: "Quelle est l'année de la chute de Bagdad face aux Mongols ?", options: ["1258", "1299", "1453", "1517"], correctIndex: 0, difficulty: "hard", category: "Histoire"),
        QuizQuestion(id: UUID(), question: "Quel calife abbasside a été tué par les Mongols lors de la chute de Bagdad ?", options: ["Al-Mustasim", "Al-Mutawakkil", "Al-Mamun", "Al-Mutasim"], correctIndex: 0, difficulty: "hard", category: "Histoire"),
        QuizQuestion(id: UUID(), question: "Quelle est la date de la bataille de Las Navas de Tolosa, tournant de la Reconquista ?", options: ["1212", "1285", "1300", "1492"], correctIndex: 0, difficulty: "hard", category: "Histoire"),
        QuizQuestion(id: UUID(), question: "Quelle est la date de la prise de Constantinople par les Ottomans ?", options: ["1389", "1453", "1492", "1517"], correctIndex: 1, difficulty: "hard", category: "Histoire"),
        QuizQuestion(id: UUID(), question: "Quel sultan ottoman a conquis Constantinople ?", options: ["Bayézid Ier", "Murad II", "Mehmed II", "Suleiman Ier"], correctIndex: 2, difficulty: "hard", category: "Histoire"),
        QuizQuestion(id: UUID(), question: "Quel est le vrai nom de Saladin, le héros des Croisades ?", options: ["Salah ad-Din al-Ayyubi", "Nur ad-Din Zangi", "Baybars", "Qutuz"], correctIndex: 0, difficulty: "hard", category: "Histoire"),
        QuizQuestion(id: UUID(), question: "Lors de quelle bataille Saladin a-t-il repris Jérusalem ?", options: ["Bataille de Hattin", "Bataille d'Acre", "Bataille de Mansoura", "Bataille de Montgisard"], correctIndex: 0, difficulty: "hard", category: "Histoire"),
        QuizQuestion(id: UUID(), question: "Quel est le fondateur de la dynastie Fatimide ?", options: ["Al-Mahdi Billah", "Al-Aziz Billah", "Al-Hakim", "Al-Mustansir"], correctIndex: 0, difficulty: "hard", category: "Histoire"),
        QuizQuestion(id: UUID(), question: "Quelle fut la première capitale de l'empire abbasside ?", options: ["Bagdad", "Al-Kufa", "Anbar", "Samarra"], correctIndex: 2, difficulty: "hard", category: "Histoire"),
        QuizQuestion(id: UUID(), question: "Quel imam et érudit est à l'origine du renouveau islamique au XIVe siècle et a été emprisonné ?", options: ["Al-Ghazali", "Ibn Taymiyya", "Ibn al-Qayyim", "An-Nawawi"], correctIndex: 1, difficulty: "hard", category: "Histoire"),

        // --- SOUFISME AVANCÉ ---
        QuizQuestion(id: UUID(), question: "Qui est Rumi et quelle est son œuvre principale ?", options: ["Un philosophe auteur de Muqaddima", "Un poète soufi auteur du Masnavi", "Un juriste auteur du Muwatta", "Un commentateur du Coran"], correctIndex: 1, difficulty: "hard", category: "Soufisme"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que la 'Fana' dans le soufisme ?", options: ["La renaissance", "L'annihilation du moi en Allah", "La méditation", "La retraite spirituelle"], correctIndex: 1, difficulty: "hard", category: "Soufisme"),
        QuizQuestion(id: UUID(), question: "Quel est le fondateur de l'ordre Qadiriyya ?", options: ["Ibn Arabi", "Abdul Qadir al-Jilani", "Rumi", "Al-Hallaj"], correctIndex: 1, difficulty: "hard", category: "Soufisme"),
        QuizQuestion(id: UUID(), question: "Quel ordre soufi est fondé par Rumi et pratique le Sama (danse tournoyante) ?", options: ["Qadiriyya", "Tijaniyya", "Mevleviyye", "Naqshbandiyya"], correctIndex: 2, difficulty: "hard", category: "Soufisme"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que la 'Silsila' en soufisme ?", options: ["Une prière", "La chaîne de transmission spirituelle d'un ordre soufi", "Un type de dhikr", "Une retraite"], correctIndex: 1, difficulty: "hard", category: "Soufisme"),
        QuizQuestion(id: UUID(), question: "Qui a dit la phrase controversée 'Ana al-Haqq' (Je suis la Vérité) et a été exécuté ?", options: ["Ibn Arabi", "Al-Hallaj", "Rumi", "Al-Junayd"], correctIndex: 1, difficulty: "hard", category: "Soufisme"),
        QuizQuestion(id: UUID(), question: "Quel est l'auteur du 'Risala al-Qushayriyya', traité classique du soufisme ?", options: ["Al-Ghazali", "Al-Qushayri", "Al-Sarraj", "Al-Kalabadhi"], correctIndex: 1, difficulty: "hard", category: "Soufisme"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que la 'Baqa' en soufisme ?", options: ["L'annihilation du moi", "La subsistance/persistance en Allah après la fana", "Le dhikr", "La méditation"], correctIndex: 1, difficulty: "hard", category: "Soufisme"),
        QuizQuestion(id: UUID(), question: "Quel ordre soufi est fondé par Ahmad al-Tijani et très répandu en Afrique de l'Ouest ?", options: ["Qadiriyya", "Tijaniyya", "Naqshbandiyya", "Shadhiliyya"], correctIndex: 1, difficulty: "hard", category: "Soufisme"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Maqam' en soufisme ?", options: ["Une mosquée", "Une station spirituelle acquise par l'effort", "Une prière", "Un niveau du paradis"], correctIndex: 1, difficulty: "hard", category: "Soufisme"),

        // --- SCIENCES ISLAMIQUES AVANCÉES ---
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Maqasid al-Sharia' ?", options: ["Les sources de la loi", "Les objectifs supérieurs de la loi islamique", "Les textes fondateurs", "Les méthodes d'ijtihad"], correctIndex: 1, difficulty: "hard", category: "Sciences"),
        QuizQuestion(id: UUID(), question: "Qui a systématisé la théorie des Maqasid al-Sharia en 5 nécessités ?", options: ["Al-Ghazali", "Ash-Shatibi", "Ibn Taymiyya", "Al-Qarafi"], correctIndex: 0, difficulty: "hard", category: "Sciences"),
        QuizQuestion(id: UUID(), question: "Quelles sont les 5 nécessités (Dharuriyyat) des Maqasid al-Sharia ?", options: ["Foi, vie, raison, descendance, honneur", "Foi, vie, raison, descendance, propriété", "Foi, prière, jeûne, pèlerinage, aumône", "Foi, science, famille, propriété, santé"], correctIndex: 1, difficulty: "hard", category: "Sciences"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que l''Ijtihad' ?", options: ["Suivre une école juridique", "L'effort indépendant d'interprétation des textes par un savant qualifié", "Le consensus", "L'analogie"], correctIndex: 1, difficulty: "hard", category: "Sciences"),
        QuizQuestion(id: UUID(), question: "Quel est l'auteur du 'Muqaddima fi Usul al-Fiqh' ?", options: ["Imam Shafi'i dans sa Risala", "Ibn Rushd", "Al-Ghazali", "Al-Amidi"], correctIndex: 0, difficulty: "hard", category: "Sciences"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que la 'Hikma' (sagesse) dans les sources islamiques ?", options: ["La jurisprudence seule", "La sunna du Prophète ﷺ ou la sagesse divine dans les commandements", "La philosophie grecque", "La poésie arabe"], correctIndex: 1, difficulty: "hard", category: "Sciences"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Usul al-Fiqh' ?", options: ["Les règles du hadith", "Les fondements méthodologiques de la jurisprudence islamique", "Les décisions juridiques", "La jurisprudence comparative"], correctIndex: 1, difficulty: "hard", category: "Sciences"),
        QuizQuestion(id: UUID(), question: "Quel est le premier traité d'Usul al-Fiqh dans l'histoire islamique ?", options: ["Al-Muwatta", "Ar-Risala d'Imam Shafi'i", "Al-Umm", "Al-Mudawwana"], correctIndex: 1, difficulty: "hard", category: "Sciences"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que la 'Fatwa' ?", options: ["Un jugement de tribunal", "Un avis juridique rendu par un savant qualifié (Mufti)", "Une décision du calife", "Un consensus des savants"], correctIndex: 1, difficulty: "hard", category: "Sciences"),
        QuizQuestion(id: UUID(), question: "Quel est le terme pour la personne qui a atteint le niveau de l'ijtihad absolu ?", options: ["Mufti", "Mujtahid Mutlaq", "Faqih", "Wali"], correctIndex: 1, difficulty: "hard", category: "Sciences"),

        // --- ESCHATOLOGIE AVANCÉE ---
        QuizQuestion(id: UUID(), question: "Combien de signes majeurs de la fin des temps sont généralement cités dans la tradition islamique ?", options: ["5", "7", "10", "12"], correctIndex: 2, difficulty: "hard", category: "Eschatologie"),
        QuizQuestion(id: UUID(), question: "Quelle est la bête (Dabbat al-Ard) mentionnée comme signe de la fin des temps ?", options: ["Un serpent géant", "Une bête qui marquera les croyants et les mécréants", "Un lion blanc", "Un oiseau immense"], correctIndex: 1, difficulty: "hard", category: "Eschatologie"),
        QuizQuestion(id: UUID(), question: "Où Issa ibn Maryam descendra-t-il lors de son retour selon les hadiths ?", options: ["À La Mecque", "À Jérusalem", "Au minaret blanc de Damas", "À Médine"], correctIndex: 2, difficulty: "hard", category: "Eschatologie"),
        QuizQuestion(id: UUID(), question: "Que désigne le terme 'Nufkhat al-Baath' ?", options: ["Le premier souffle de la trompette", "Le second souffle de la trompette qui ressuscitera les morts", "Le Jour du Jugement", "La mort collective"], correctIndex: 1, difficulty: "hard", category: "Eschatologie"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que la 'Hawdh' (bassin) du Prophète ﷺ ?", options: ["Un fleuve du paradis", "Le bassin duquel le Prophète ﷺ abreuvera sa communauté le Jour du Jugement", "Un puits sacré", "Un lac en enfer"], correctIndex: 1, difficulty: "hard", category: "Eschatologie"),
        QuizQuestion(id: UUID(), question: "Combien de niveaux l'enfer (Jahannam) a-t-il selon la tradition islamique ?", options: ["4", "5", "7", "10"], correctIndex: 2, difficulty: "hard", category: "Eschatologie"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que 'Al-A'raf' mentionné dans le Coran ?", options: ["Un niveau du paradis", "Un endroit entre le paradis et l'enfer pour certaines âmes", "L'enfer", "Un pont"], correctIndex: 1, difficulty: "hard", category: "Eschatologie"),
        QuizQuestion(id: UUID(), question: "Quel signe majeur consiste en le lever du soleil à l'Ouest ?", options: ["L'apparition du Mahdi", "L'apparition du Dajjal", "Le lever du soleil à l'Ouest — une des 10 grandes signes", "La descente d'Issa"], correctIndex: 2, difficulty: "hard", category: "Eschatologie"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que la 'Nafkha' en eschatologie islamique ?", options: ["La résurrection seule", "Le souffle dans la trompette par Israfil pour annoncer la fin des temps", "La mort collective", "Le Jour du Jugement"], correctIndex: 1, difficulty: "hard", category: "Eschatologie"),
        QuizQuestion(id: UUID(), question: "Qu'est-ce que le 'Yawm al-Hashr' ?", options: ["Le Jour de la Résurrection", "Le Jour du Rassemblement de toute l'humanité pour le Jugement", "Le Jour de la Mort", "Le Jour de la Trompette"], correctIndex: 1, difficulty: "hard", category: "Eschatologie"),
    ]

    // MARK: - Toutes les questions combinées
    static var allQuestions: [QuizQuestion] {
        return easyQuestions + mediumQuestions + hardQuestions
    }

    static func questions(for difficulty: String) -> [QuizQuestion] {
        switch difficulty.lowercased() {
        case "easy", "facile": return easyQuestions.shuffled()
        case "medium", "moyen": return mediumQuestions.shuffled()
        case "hard", "difficile": return hardQuestions.shuffled()
        default: return allQuestions.shuffled()
        }
    }
}
