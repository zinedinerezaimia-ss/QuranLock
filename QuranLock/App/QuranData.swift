import SwiftUI

// MARK: - Verse Model
struct QuranVerse: Identifiable {
    let id: Int
    let arabic: String
    let french: String
    let phonetic: String
}

// MARK: - Inline Data Provider
struct QuranDataProvider {
    static let verses: [Int: [QuranVerse]] = [
        1: [
            QuranVerse(id: 1, arabic: "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ", french: "Au nom d'Allah, le Tout Miséricordieux, le Très Miséricordieux.", phonetic: "Bismillāhi r-raḥmāni r-raḥīm"),
            QuranVerse(id: 2, arabic: "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ", french: "Louange à Allah, Seigneur de l'univers,", phonetic: "Alḥamdu lillāhi rabbi l-ʿālamīn"),
            QuranVerse(id: 3, arabic: "الرَّحْمَٰنِ الرَّحِيمِ", french: "le Tout Miséricordieux, le Très Miséricordieux,", phonetic: "Ar-raḥmāni r-raḥīm"),
            QuranVerse(id: 4, arabic: "مَالِكِ يَوْمِ الدِّينِ", french: "Maître du Jour de la rétribution.", phonetic: "Māliki yawmi d-dīn"),
            QuranVerse(id: 5, arabic: "إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ", french: "C'est Toi [Seul] que nous adorons, et c'est Toi [Seul] dont nous implorons le secours.", phonetic: "Iyyāka naʿbudu wa-iyyāka nastaʿīn"),
            QuranVerse(id: 6, arabic: "اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ", french: "Guide-nous dans le droit chemin,", phonetic: "Ihdinā ṣ-ṣirāṭa l-mustaqīm"),
            QuranVerse(id: 7, arabic: "صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ", french: "le chemin de ceux que Tu as comblés de faveurs, non pas de ceux qui ont encouru Ta colère, ni des égarés.", phonetic: "Ṣirāṭa llaḏīna anʿamta ʿalayhim ġayri l-maġḍūbi ʿalayhim wa-lā ḍ-ḍāllīn"),
        ],
        2: [
            QuranVerse(id: 1, arabic: "الم", french: "Alif, Lâm, Mîm.", phonetic: "Alif-Lām-Mīm"),
            QuranVerse(id: 2, arabic: "ذَٰلِكَ الْكِتَابُ لَا رَيْبَ فِيهِ هُدًى لِّلْمُتَّقِينَ", french: "C'est le Livre au sujet duquel il n'y a aucun doute, c'est un guide pour les pieux.", phonetic: "Ḏālika l-kitābu lā rayba fīhi hudan li-l-muttaqīn"),
            QuranVerse(id: 3, arabic: "الَّذِينَ يُؤْمِنُونَ بِالْغَيْبِ وَيُقِيمُونَ الصَّلَاةَ وَمِمَّا رَزَقْنَاهُمْ يُنفِقُونَ", french: "Ceux qui croient à l'invisible, accomplissent la prière et dépensent de ce que Nous leur avons attribué.", phonetic: "Allaḏīna yuʾminūna bi-l-ġaybi wa-yuqīmūna ṣ-ṣalāta wa-mimmā razaqnāhum yunfiqūn"),
            QuranVerse(id: 4, arabic: "وَالَّذِينَ يُؤْمِنُونَ بِمَا أُنزِلَ إِلَيْكَ وَمَا أُنزِلَ مِن قَبْلِكَ وَبِالْآخِرَةِ هُمْ يُوقِنُونَ", french: "Et ceux qui croient à ce qui t'a été révélé et à ce qui a été révélé avant toi et qui ont la certitude de l'au-delà.", phonetic: "Wa-llaḏīna yuʾminūna bi-mā unzila ilayka wa-mā unzila min qablika wa-bi-l-āḫirati hum yūqinūn"),
            QuranVerse(id: 5, arabic: "أُولَٰئِكَ عَلَىٰ هُدًى مِّن رَّبِّهِمْ وَأُولَٰئِكَ هُمُ الْمُفْلِحُونَ", french: "Ceux-là sont sur le bon chemin de leur Seigneur et ce sont eux qui réussiront.", phonetic: "Ulāʾika ʿalā hudan min rabbihim wa-ulāʾika humu l-mufliḥūn"),
        ],
        3: [
            QuranVerse(id: 1, arabic: "الم", french: "Alif, Lâm, Mîm.", phonetic: "Alif-Lām-Mīm"),
            QuranVerse(id: 2, arabic: "اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ", french: "Allah, point de divinité à part Lui, le Vivant, Celui qui subsiste par Lui-même.", phonetic: "Allāhu lā ilāha illā huwa l-ḥayyu l-qayyūm"),
            QuranVerse(id: 3, arabic: "نَزَّلَ عَلَيْكَ الْكِتَابَ بِالْحَقِّ مُصَدِّقًا لِّمَا بَيْنَ يَدَيْهِ وَأَنزَلَ التَّوْرَاةَ وَالْإِنجِيلَ", french: "Il t'a fait descendre le Livre en toute vérité, confirmant ce qui existait avant lui. Il a fait descendre la Tora et l'Évangile,", phonetic: "Nazzala ʿalayka l-kitāba bi-l-ḥaqqi muṣaddiqan li-mā bayna yadayhi wa-anzala t-tawrāta wa-l-injīl"),
        ],
        4: [
            QuranVerse(id: 1, arabic: "يَا أَيُّهَا النَّاسُ اتَّقُوا رَبَّكُمُ الَّذِي خَلَقَكُم مِّن نَّفْسٍ وَاحِدَةٍ وَخَلَقَ مِنْهَا زَوْجَهَا وَبَثَّ مِنْهُمَا رِجَالًا كَثِيرًا وَنِسَاءً وَاتَّقُوا اللَّهَ الَّذِي تَسَاءَلُونَ بِهِ وَالْأَرْحَامَ إِنَّ اللَّهَ كَانَ عَلَيْكُمْ رَقِيبًا", french: "Ô gens ! Craignez votre Seigneur qui vous a créés d'un seul être et a créé de celui-ci son épouse et qui de ces deux-là a fait répandre beaucoup d'hommes et de femmes. Et craignez Allah sur qui vous vous interpellez, et craignez les liens du sang. Allah est certes Surveillant sur vous.", phonetic: "Yā ayyuhā n-nāsu ttaqū rabbakumu llaḏī ḫalaqakum min nafsin wāḥidatin"),
        ],
        5: [
            QuranVerse(id: 1, arabic: "يَا أَيُّهَا الَّذِينَ آمَنُوا أَوْفُوا بِالْعُقُودِ أُحِلَّتْ لَكُم بَهِيمَةُ الْأَنْعَامِ إِلَّا مَا يُتْلَىٰ عَلَيْكُمْ غَيْرَ مُحِلِّي الصَّيْدِ وَأَنتُمْ حُرُمٌ إِنَّ اللَّهَ يَحْكُمُ مَا يُرِيدُ", french: "Ô vous qui avez cru, remplissez vos engagements. Le bétail vous est licite, sauf ce qui vous est récité, sans pour autant vous permettre la chasse quand vous êtes en état de sacralisation. Allah décide ce qu'Il veut.", phonetic: "Yā ayyuhā llaḏīna āmanū awfū bi-l-ʿuqūd"),
        ],
        6: [
            QuranVerse(id: 1, arabic: "الْحَمْدُ لِلَّهِ الَّذِي خَلَقَ السَّمَاوَاتِ وَالْأَرْضَ وَجَعَلَ الظُّلُمَاتِ وَالنُّورَ ثُمَّ الَّذِينَ كَفَرُوا بِرَبِّهِمْ يَعْدِلُونَ", french: "Louange à Allah qui a créé les cieux et la terre et a institué les ténèbres et la lumière. Pourtant ceux qui ont mécru associent [des partenaires] à leur Seigneur.", phonetic: "Al-ḥamdu lillāhi llaḏī ḫalaqa s-samāwāti wa-l-arḍa wa-jaʿala ẓ-ẓulumāti wa-n-nūr"),
        ],
        7: [
            QuranVerse(id: 1, arabic: "المص", french: "Alif, Lâm, Mîm, Sâd.", phonetic: "Alif-Lām-Mīm-Ṣād"),
        ],
        8: [
            QuranVerse(id: 1, arabic: "يَسْأَلُونَكَ عَنِ الْأَنفَالِ قُلِ الْأَنفَالُ لِلَّهِ وَالرَّسُولِ فَاتَّقُوا اللَّهَ وَأَصْلِحُوا ذَاتَ بَيْنِكُمْ وَأَطِيعُوا اللَّهَ وَرَسُولَهُ إِن كُنتُم مُّؤْمِنِينَ", french: "Ils t'interrogent au sujet du butin. Dis : Le butin appartient à Allah et au Messager. Craignez Allah et réglez vos différends. Obéissez à Allah et à Son messager si vous êtes croyants.", phonetic: "Yasʾalūnaka ʿani l-anfāl quli l-anfālu lillāhi wa-r-rasūl"),
        ],
        9: [
            QuranVerse(id: 1, arabic: "بَرَاءَةٌ مِّنَ اللَّهِ وَرَسُولِهِ إِلَى الَّذِينَ عَاهَدتُّم مِّنَ الْمُشْرِكِينَ", french: "Désaveu d'Allah et de Son messager envers les associateurs avec lesquels vous avez conclu un traité.", phonetic: "Barāʾatun mina llāhi wa-rasūlihi ila llaḏīna ʿāhattum mina l-mušrikīn"),
        ],
        10: [
            QuranVerse(id: 1, arabic: "الر تِلْكَ آيَاتُ الْكِتَابِ الْحَكِيمِ", french: "Alif, Lâm, Râ. Voilà les versets du Livre plein de sagesse.", phonetic: "Alif-Lām-Rā tilka āyātu l-kitābi l-ḥakīm"),
            QuranVerse(id: 2, arabic: "أَكَانَ لِلنَّاسِ عَجَبًا أَنْ أَوْحَيْنَا إِلَىٰ رَجُلٍ مِّنْهُمْ أَنْ أَنذِرِ النَّاسَ وَبَشِّرِ الَّذِينَ آمَنُوا أَنَّ لَهُمْ قَدَمَ صِدْقٍ عِندَ رَبِّهِمْ قَالَ الْكَافِرُونَ إِنَّ هَٰذَا لَسَاحِرٌ مُّبِينٌ", french: "Est-ce une chose étonnante pour les gens que Nous ayons révélé à un homme de parmi eux : Avertis les gens et annonce la bonne nouvelle à ceux qui ont cru qu'ils auront une bonne récompense auprès de leur Seigneur? Les mécréants ont dit : Vraiment, c'est là un magicien évident.", phonetic: "A-kāna li-n-nāsi ʿajaban an awḥaynā ilā rajulin minhum"),
        ],
        11: [
            QuranVerse(id: 1, arabic: "الر كِتَابٌ أُحْكِمَتْ آيَاتُهُ ثُمَّ فُصِّلَتْ مِن لَّدُنْ حَكِيمٍ خَبِيرٍ", french: "Alif, Lâm, Râ. C'est un Livre dont les versets sont bien définis, puis exposés en détail, de la part d'un Sage, Parfaitement Connaisseur.", phonetic: "Alif-Lām-Rā kitābun uḥkimat āyātuhu ṯumma fuṣṣilat min ladun ḥakīmin ḫabīr"),
        ],
        12: [
            QuranVerse(id: 1, arabic: "الر تِلْكَ آيَاتُ الْكِتَابِ الْمُبِينِ", french: "Alif, Lâm, Râ. Ce sont les versets du Livre explicite.", phonetic: "Alif-Lām-Rā tilka āyātu l-kitābi l-mubīn"),
            QuranVerse(id: 2, arabic: "إِنَّا أَنزَلْنَاهُ قُرْآنًا عَرَبِيًّا لَّعَلَّكُمْ تَعْقِلُونَ", french: "Nous l'avons fait descendre en un Coran arabe, afin que vous raisonniez.", phonetic: "Innā anzalnāhu qurʾānan ʿarabiyyan laʿallakum taʿqilūn"),
        ],
        13: [
            QuranVerse(id: 1, arabic: "المر تِلْكَ آيَاتُ الْكِتَابِ وَالَّذِي أُنزِلَ إِلَيْكَ مِن رَّبِّكَ الْحَقُّ وَلَٰكِنَّ أَكْثَرَ النَّاسِ لَا يُؤْمِنُونَ", french: "Alif, Lâm, Mîm, Râ. Ce sont les versets du Livre. Ce qui t'a été révélé de ton Seigneur est la vérité, mais la plupart des gens ne croient pas.", phonetic: "Alif-Lām-Mīm-Rā tilka āyātu l-kitāb"),
        ],
        14: [
            QuranVerse(id: 1, arabic: "الر كِتَابٌ أَنزَلْنَاهُ إِلَيْكَ لِتُخْرِجَ النَّاسَ مِنَ الظُّلُمَاتِ إِلَى النُّورِ بِإِذْنِ رَبِّهِمْ إِلَىٰ صِرَاطِ الْعَزِيزِ الْحَمِيدِ", french: "Alif, Lâm, Râ. Livre que Nous t'avons révélé pour que tu fasses sortir les gens des ténèbres vers la lumière, par la permission de leur Seigneur, vers le chemin du Puissant, du Digne de louange.", phonetic: "Alif-Lām-Rā kitābun anzalnāhu ilayka li-tuḫrija n-nāsa mina ẓ-ẓulumāti ila n-nūr"),
        ],
        15: [
            QuranVerse(id: 1, arabic: "الر تِلْكَ آيَاتُ الْكِتَابِ وَقُرْآنٍ مُّبِينٍ", french: "Alif, Lâm, Râ. Ce sont les versets du Livre et d'un Coran explicite.", phonetic: "Alif-Lām-Rā tilka āyātu l-kitābi wa-qurʾānin mubīn"),
        ],
        16: [
            QuranVerse(id: 1, arabic: "أَتَىٰ أَمْرُ اللَّهِ فَلَا تَسْتَعْجِلُوهُ سُبْحَانَهُ وَتَعَالَىٰ عَمَّا يُشْرِكُونَ", french: "L'ordre d'Allah est venu, ne le hâtez donc pas. Gloire et Hauteur à Lui, au-dessus de ce qu'ils Lui associent !", phonetic: "Atā amru llāhi fa-lā tastaʿjilūhu subḥānahu wa-taʿālā ʿammā yušrikūn"),
        ],
        17: [
            QuranVerse(id: 1, arabic: "سُبْحَانَ الَّذِي أَسْرَىٰ بِعَبْدِهِ لَيْلًا مِّنَ الْمَسْجِدِ الْحَرَامِ إِلَى الْمَسْجِدِ الْأَقْصَى الَّذِي بَارَكْنَا حَوْلَهُ لِنُرِيَهُ مِنْ آيَاتِنَا إِنَّهُ هُوَ السَّمِيعُ الْبَصِيرُ", french: "Gloire à Celui qui a transporté, la nuit, Son serviteur de la Mosquée Sacrée à la Mosquée Al-Aqsâ dont Nous avons béni les alentours, afin de lui montrer Nos signes. Il est certes Celui qui entend et qui voit tout.", phonetic: "Subḥāna llaḏī asrā bi-ʿabdihi laylan mina l-masjidi l-ḥarāmi ilā l-masjidi l-aqṣā"),
        ],
        18: [
            QuranVerse(id: 1, arabic: "الْحَمْدُ لِلَّهِ الَّذِي أَنزَلَ عَلَىٰ عَبْدِهِ الْكِتَابَ وَلَمْ يَجْعَل لَّهُ عِوَجًا", french: "Louange à Allah qui a fait descendre sur Son serviteur le Livre sans y mettre d'déviation,", phonetic: "Al-ḥamdu lillāhi llaḏī anzala ʿalā ʿabdihi l-kitāba wa-lam yajʿal lahu ʿiwajā"),
            QuranVerse(id: 2, arabic: "قَيِّمًا لِّيُنذِرَ بَأْسًا شَدِيدًا مِّن لَّدُنْهُ وَيُبَشِّرَ الْمُؤْمِنِينَ الَّذِينَ يَعْمَلُونَ الصَّالِحَاتِ أَنَّ لَهُمْ أَجْرًا حَسَنًا", french: "[un Livre] droit, pour avertir d'une sévère punition venant de Sa part, et pour annoncer la bonne nouvelle aux croyants qui font de bonnes œuvres qu'ils auront une belle récompense,", phonetic: "Qayyiman li-yunḏira baʾsan šadīdan min ladunhu wa-yubaššira l-muʾminīna llaḏīna yaʿmalūna ṣ-ṣāliḥāt"),
        ],
        19: [
            QuranVerse(id: 1, arabic: "كهيعص", french: "Kâf, Hâ, Yâ, 'Aïn, Sâd.", phonetic: "Kāf-Hā-Yā-ʿAyn-Ṣād"),
            QuranVerse(id: 2, arabic: "ذِكْرُ رَحْمَتِ رَبِّكَ عَبْدَهُ زَكَرِيَّا", french: "[C'est] un rappel de la miséricorde de ton Seigneur envers Son serviteur Zacharie,", phonetic: "Ḏikru raḥmati rabbika ʿabdahu zakariyyā"),
        ],
        20: [
            QuranVerse(id: 1, arabic: "طه", french: "Tâ, Hâ.", phonetic: "Ṭā-Hā"),
            QuranVerse(id: 2, arabic: "مَا أَنزَلْنَا عَلَيْكَ الْقُرْآنَ لِتَشْقَىٰ", french: "Nous ne t'avons pas révélé le Coran pour que tu sois malheureux,", phonetic: "Mā anzalnā ʿalayka l-qurʾāna li-tašqā"),
        ],
        21: [
            QuranVerse(id: 1, arabic: "اقْتَرَبَ لِلنَّاسِ حِسَابُهُمْ وَهُمْ فِي غَفْلَةٍ مُّعْرِضُونَ", french: "Le moment du compte à rendre approche pour les gens, tandis qu'ils se détournent dans l'insouciance.", phonetic: "Iqtaraba li-n-nāsi ḥisābuhum wa-hum fī ġaflatin muʿriḍūn"),
        ],
        22: [
            QuranVerse(id: 1, arabic: "يَا أَيُّهَا النَّاسُ اتَّقُوا رَبَّكُمْ إِنَّ زَلْزَلَةَ السَّاعَةِ شَيْءٌ عَظِيمٌ", french: "Ô gens ! Craignez votre Seigneur, car le séisme de l'Heure est une chose terrible.", phonetic: "Yā ayyuhā n-nāsu ttaqū rabbakum inna zalzalata s-sāʿati šayʾun ʿaẓīm"),
        ],
        23: [
            QuranVerse(id: 1, arabic: "قَدْ أَفْلَحَ الْمُؤْمِنُونَ", french: "Bienheureux les croyants !", phonetic: "Qad aflaḥa l-muʾminūn"),
            QuranVerse(id: 2, arabic: "الَّذِينَ هُمْ فِي صَلَاتِهِمْ خَاشِعُونَ", french: "Ceux qui sont humbles dans leur prière,", phonetic: "Allaḏīna hum fī ṣalātihim ḫāšiʿūn"),
            QuranVerse(id: 3, arabic: "وَالَّذِينَ هُمْ عَنِ اللَّغْوِ مُعْرِضُونَ", french: "qui s'écartent du vain,", phonetic: "Wa-llaḏīna hum ʿani l-laġwi muʿriḍūn"),
            QuranVerse(id: 4, arabic: "وَالَّذِينَ هُمْ لِلزَّكَاةِ فَاعِلُونَ", french: "qui s'acquittent de la Zakat,", phonetic: "Wa-llaḏīna hum li-z-zakāti fāʿilūn"),
            QuranVerse(id: 5, arabic: "وَالَّذِينَ هُمْ لِفُرُوجِهِمْ حَافِظُونَ", french: "et qui préservent leurs parties intimes,", phonetic: "Wa-llaḏīna hum li-furūjihim ḥāfiẓūn"),
        ],
        24: [
            QuranVerse(id: 1, arabic: "سُورَةٌ أَنزَلْنَاهَا وَفَرَضْنَاهَا وَأَنزَلْنَا فِيهَا آيَاتٍ بَيِّنَاتٍ لَّعَلَّكُمْ تَذَكَّرُونَ", french: "C'est une sourate que Nous avons fait descendre et que Nous avons prescrite, et Nous y avons fait descendre des versets évidents afin que vous vous souveniez.", phonetic: "Sūratun anzalnāhā wa-faraḍnāhā wa-anzalnā fīhā āyātin bayyinātin laʿallakum taḏakkarūn"),
        ],
        25: [
            QuranVerse(id: 1, arabic: "تَبَارَكَ الَّذِي نَزَّلَ الْفُرْقَانَ عَلَىٰ عَبْدِهِ لِيَكُونَ لِلْعَالَمِينَ نَذِيرًا", french: "Béni soit Celui qui a fait descendre Le Discernement (Al-Furqan) sur Son serviteur pour qu'il soit un avertisseur pour tout l'univers.", phonetic: "Tabāraka llaḏī nazzala l-furqāna ʿalā ʿabdihi li-yakūna li-l-ʿālamīna naḏīrā"),
        ],
        26: [
            QuranVerse(id: 1, arabic: "طسم", french: "Tâ, Sîn, Mîm.", phonetic: "Ṭā-Sīn-Mīm"),
            QuranVerse(id: 2, arabic: "تِلْكَ آيَاتُ الْكِتَابِ الْمُبِينِ", french: "Ce sont les versets du Livre explicite.", phonetic: "Tilka āyātu l-kitābi l-mubīn"),
        ],
        27: [
            QuranVerse(id: 1, arabic: "طس تِلْكَ آيَاتُ الْقُرْآنِ وَكِتَابٍ مُّبِينٍ", french: "Tâ, Sîn. Ce sont les versets du Coran et d'un Livre explicite,", phonetic: "Ṭā-Sīn tilka āyātu l-qurʾāni wa-kitābin mubīn"),
            QuranVerse(id: 2, arabic: "هُدًى وَبُشْرَىٰ لِلْمُؤْمِنِينَ", french: "un guide et une bonne annonce pour les croyants,", phonetic: "Hudan wa-bušrā li-l-muʾminīn"),
        ],
        28: [
            QuranVerse(id: 1, arabic: "طسم", french: "Tâ, Sîn, Mîm.", phonetic: "Ṭā-Sīn-Mīm"),
            QuranVerse(id: 2, arabic: "تِلْكَ آيَاتُ الْكِتَابِ الْمُبِينِ", french: "Ce sont les versets du Livre explicite.", phonetic: "Tilka āyātu l-kitābi l-mubīn"),
        ],
        29: [
            QuranVerse(id: 1, arabic: "الم", french: "Alif, Lâm, Mîm.", phonetic: "Alif-Lām-Mīm"),
            QuranVerse(id: 2, arabic: "أَحَسِبَ النَّاسُ أَن يُتْرَكُوا أَن يَقُولُوا آمَنَّا وَهُمْ لَا يُفْتَنُونَ", french: "Les gens pensent-ils qu'on les laissera dire : Nous croyons, sans les éprouver ?", phonetic: "A-ḥasiba n-nāsu an yutraku an yaqūlū āmannā wa-hum lā yuftanūn"),
        ],
        30: [
            QuranVerse(id: 1, arabic: "الم", french: "Alif, Lâm, Mîm.", phonetic: "Alif-Lām-Mīm"),
            QuranVerse(id: 2, arabic: "غُلِبَتِ الرُّومُ", french: "Les Romains ont été vaincus", phonetic: "Ġulibati r-rūm"),
            QuranVerse(id: 3, arabic: "فِي أَدْنَى الْأَرْضِ وَهُم مِّن بَعْدِ غَلَبِهِمْ سَيَغْلِبُونَ", french: "dans la région la plus proche. Et après leur défaite ils seront vainqueurs,", phonetic: "Fī adnā l-arḍi wa-hum min baʿdi ġalabihim sayaġlibūn"),
        ],
        31: [
            QuranVerse(id: 1, arabic: "الم", french: "Alif, Lâm, Mîm.", phonetic: "Alif-Lām-Mīm"),
            QuranVerse(id: 2, arabic: "تِلْكَ آيَاتُ الْكِتَابِ الْحَكِيمِ", french: "Ce sont les versets du Livre plein de sagesse,", phonetic: "Tilka āyātu l-kitābi l-ḥakīm"),
        ],
        32: [
            QuranVerse(id: 1, arabic: "الم", french: "Alif, Lâm, Mîm.", phonetic: "Alif-Lām-Mīm"),
            QuranVerse(id: 2, arabic: "تَنزِيلُ الْكِتَابِ لَا رَيْبَ فِيهِ مِن رَّبِّ الْعَالَمِينَ", french: "La révélation du Livre, il n'y a pas de doute là-dessus, [vient] du Seigneur de l'univers.", phonetic: "Tanzīlu l-kitābi lā rayba fīhi min rabbi l-ʿālamīn"),
        ],
        33: [
            QuranVerse(id: 1, arabic: "يَا أَيُّهَا النَّبِيُّ اتَّقِ اللَّهَ وَلَا تُطِعِ الْكَافِرِينَ وَالْمُنَافِقِينَ إِنَّ اللَّهَ كَانَ عَلِيمًا حَكِيمًا", french: "Ô Prophète ! Crains Allah et n'obéis pas aux mécréants et aux hypocrites. Allah est Omniscient et Sage.", phonetic: "Yā ayyuhā n-nabiyyu ttaqi llāha wa-lā tuṭiʿi l-kāfirīna wa-l-munāfiqīn"),
        ],
        34: [
            QuranVerse(id: 1, arabic: "الْحَمْدُ لِلَّهِ الَّذِي لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ وَلَهُ الْحَمْدُ فِي الْآخِرَةِ وَهُوَ الْحَكِيمُ الْخَبِيرُ", french: "Louange à Allah, à qui appartient ce qui est dans les cieux et ce qui est sur la terre. Louange à Lui dans l'au-delà. C'est Lui le Sage, le Parfaitement Connaisseur.", phonetic: "Al-ḥamdu lillāhi llaḏī lahu mā fī s-samāwāti wa-mā fī l-arḍ"),
        ],
        35: [
            QuranVerse(id: 1, arabic: "الْحَمْدُ لِلَّهِ فَاطِرِ السَّمَاوَاتِ وَالْأَرْضِ جَاعِلِ الْمَلَائِكَةِ رُسُلًا أُولِي أَجْنِحَةٍ مَّثْنَىٰ وَثُلَاثَ وَرُبَاعَ يَزِيدُ فِي الْخَلْقِ مَا يَشَاءُ إِنَّ اللَّهَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ", french: "Louange à Allah, Créateur des cieux et de la terre, qui a fait des anges des messagers ailés, par deux ou trois ou quatre. Il ajoute à la création ce qu'Il veut. Allah est vraiment Omnipotent.", phonetic: "Al-ḥamdu lillāhi fāṭiri s-samāwāti wa-l-arḍi jāʿili l-malāʾikati rusulan"),
        ],
        36: [
            QuranVerse(id: 1, arabic: "يس", french: "Yâ, Sîn.", phonetic: "Yā-Sīn"),
            QuranVerse(id: 2, arabic: "وَالْقُرْآنِ الْحَكِيمِ", french: "Par le Coran plein de sagesse !", phonetic: "Wa-l-qurʾāni l-ḥakīm"),
            QuranVerse(id: 3, arabic: "إِنَّكَ لَمِنَ الْمُرْسَلِينَ", french: "Tu es vraiment du nombre des messagers,", phonetic: "Innaka la-mina l-mursalīn"),
            QuranVerse(id: 4, arabic: "عَلَىٰ صِرَاطٍ مُّسْتَقِيمٍ", french: "sur un chemin droit,", phonetic: "ʿAlā ṣirāṭin mustaqīm"),
            QuranVerse(id: 5, arabic: "تَنزِيلَ الْعَزِيزِ الرَّحِيمِ", french: "révélation du Puissant, du Très Miséricordieux,", phonetic: "Tanzīla l-ʿazīzi r-raḥīm"),
            QuranVerse(id: 6, arabic: "لِتُنذِرَ قَوْمًا مَّا أُنذِرَ آبَاؤُهُمْ فَهُمْ غَافِلُونَ", french: "afin que tu avertisses un peuple dont les ancêtres n'ont pas été avertis et qui est donc insouciant.", phonetic: "Li-tunḏira qawman mā unḏira ābāʾuhum fa-hum ġāfilūn"),
        ],
        37: [
            QuranVerse(id: 1, arabic: "وَالصَّافَّاتِ صَفًّا", french: "Par ceux qui se mettent en rangs,", phonetic: "Wa-ṣ-ṣāffāti ṣaffā"),
            QuranVerse(id: 2, arabic: "فَالزَّاجِرَاتِ زَجْرًا", french: "par ceux qui repoussent avec force,", phonetic: "Fa-z-zājirāti zajrā"),
            QuranVerse(id: 3, arabic: "فَالتَّالِيَاتِ ذِكْرًا", french: "par ceux qui récitent le Rappel !", phonetic: "Fa-t-tāliyāti ḏikrā"),
        ],
        38: [
            QuranVerse(id: 1, arabic: "ص وَالْقُرْآنِ ذِي الذِّكْرِ", french: "Sâd. Par le Coran qui contient le Rappel !", phonetic: "Ṣād wa-l-qurʾāni ḏī ḏ-ḏikr"),
        ],
        39: [
            QuranVerse(id: 1, arabic: "تَنزِيلُ الْكِتَابِ مِنَ اللَّهِ الْعَزِيزِ الْحَكِيمِ", french: "La révélation du Livre vient d'Allah le Puissant, le Sage.", phonetic: "Tanzīlu l-kitābi mina llāhi l-ʿazīzi l-ḥakīm"),
        ],
        40: [
            QuranVerse(id: 1, arabic: "حم", french: "Hâ, Mîm.", phonetic: "Ḥā-Mīm"),
            QuranVerse(id: 2, arabic: "تَنزِيلُ الْكِتَابِ مِنَ اللَّهِ الْعَزِيزِ الْعَلِيمِ", french: "La révélation du Livre vient d'Allah le Puissant, l'Omniscient,", phonetic: "Tanzīlu l-kitābi mina llāhi l-ʿazīzi l-ʿalīm"),
        ],
        41: [
            QuranVerse(id: 1, arabic: "حم", french: "Hâ, Mîm.", phonetic: "Ḥā-Mīm"),
            QuranVerse(id: 2, arabic: "تَنزِيلٌ مِّنَ الرَّحْمَٰنِ الرَّحِيمِ", french: "Révélation du Tout Miséricordieux, du Très Miséricordieux,", phonetic: "Tanzīlun mina r-raḥmāni r-raḥīm"),
        ],
        42: [
            QuranVerse(id: 1, arabic: "حم", french: "Hâ, Mîm.", phonetic: "Ḥā-Mīm"),
            QuranVerse(id: 2, arabic: "عسق", french: "'Aïn, Sîn, Qâf.", phonetic: "ʿAyn-Sīn-Qāf"),
        ],
        43: [
            QuranVerse(id: 1, arabic: "حم", french: "Hâ, Mîm.", phonetic: "Ḥā-Mīm"),
            QuranVerse(id: 2, arabic: "وَالْكِتَابِ الْمُبِينِ", french: "Par le Livre explicite !", phonetic: "Wa-l-kitābi l-mubīn"),
        ],
        44: [
            QuranVerse(id: 1, arabic: "حم", french: "Hâ, Mîm.", phonetic: "Ḥā-Mīm"),
            QuranVerse(id: 2, arabic: "وَالْكِتَابِ الْمُبِينِ", french: "Par le Livre explicite !", phonetic: "Wa-l-kitābi l-mubīn"),
            QuranVerse(id: 3, arabic: "إِنَّا أَنزَلْنَاهُ فِي لَيْلَةٍ مُّبَارَكَةٍ إِنَّا كُنَّا مُنذِرِينَ", french: "Nous l'avons certes fait descendre pendant une nuit bénie. Nous sommes en vérité Avertisseur.", phonetic: "Innā anzalnāhu fī laylatin mubārakatin innā kunnā munḏirīn"),
        ],
        45: [
            QuranVerse(id: 1, arabic: "حم", french: "Hâ, Mîm.", phonetic: "Ḥā-Mīm"),
            QuranVerse(id: 2, arabic: "تَنزِيلُ الْكِتَابِ مِنَ اللَّهِ الْعَزِيزِ الْحَكِيمِ", french: "La révélation du Livre vient d'Allah le Puissant, le Sage.", phonetic: "Tanzīlu l-kitābi mina llāhi l-ʿazīzi l-ḥakīm"),
        ],
        46: [
            QuranVerse(id: 1, arabic: "حم", french: "Hâ, Mîm.", phonetic: "Ḥā-Mīm"),
            QuranVerse(id: 2, arabic: "تَنزِيلُ الْكِتَابِ مِنَ اللَّهِ الْعَزِيزِ الْحَكِيمِ", french: "La révélation du Livre vient d'Allah le Puissant, le Sage.", phonetic: "Tanzīlu l-kitābi mina llāhi l-ʿazīzi l-ḥakīm"),
        ],
        47: [
            QuranVerse(id: 1, arabic: "الَّذِينَ كَفَرُوا وَصَدُّوا عَن سَبِيلِ اللَّهِ أَضَلَّ أَعْمَالَهُمْ", french: "Ceux qui mécroient et obstruent le sentier d'Allah, Il rendra vaines leurs œuvres.", phonetic: "Allaḏīna kafarū wa-ṣaddū ʿan sabīli llāhi aḍalla aʿmālahum"),
        ],
        48: [
            QuranVerse(id: 1, arabic: "إِنَّا فَتَحْنَا لَكَ فَتْحًا مُّبِينًا", french: "Nous t'avons accordé une victoire éclatante,", phonetic: "Innā fataḥnā laka fatḥan mubīnā"),
            QuranVerse(id: 2, arabic: "لِّيَغْفِرَ لَكَ اللَّهُ مَا تَقَدَّمَ مِن ذَنبِكَ وَمَا تَأَخَّرَ وَيُتِمَّ نِعْمَتَهُ عَلَيْكَ وَيَهْدِيَكَ صِرَاطًا مُّسْتَقِيمًا", french: "afin qu'Allah te pardonne tes péchés passés et futurs, qu'Il parachève Son bienfait sur toi et te guide sur un droit chemin,", phonetic: "Li-yaġfira laka llāhu mā taqaddama min ḏanbika wa-mā taʾaḫḫara"),
        ],
        49: [
            QuranVerse(id: 1, arabic: "يَا أَيُّهَا الَّذِينَ آمَنُوا لَا تُقَدِّمُوا بَيْنَ يَدَيِ اللَّهِ وَرَسُولِهِ وَاتَّقُوا اللَّهَ إِنَّ اللَّهَ سَمِيعٌ عَلِيمٌ", french: "Ô vous qui avez cru ! Ne devancez pas Allah et Son messager. Et craignez Allah. Vraiment, Allah est Audient et Omniscient.", phonetic: "Yā ayyuhā llaḏīna āmanū lā tuqaddimū bayna yaday llāhi wa-rasūlihi"),
        ],
        50: [
            QuranVerse(id: 1, arabic: "ق وَالْقُرْآنِ الْمَجِيدِ", french: "Qâf. Par le Coran glorieux !", phonetic: "Qāf wa-l-qurʾāni l-majīd"),
        ],
        51: [
            QuranVerse(id: 1, arabic: "وَالذَّارِيَاتِ ذَرْوًا", french: "Par celles qui éparpillent [le vent] !", phonetic: "Wa-ḏ-ḏāriyāti ḏarwā"),
            QuranVerse(id: 2, arabic: "فَالْحَامِلَاتِ وِقْرًا", french: "Par celles qui portent un fardeau !", phonetic: "Fa-l-ḥāmilāti wiqrā"),
        ],
        52: [
            QuranVerse(id: 1, arabic: "وَالطُّورِ", french: "Par le Mont Sinaï !", phonetic: "Wa-ṭ-ṭūr"),
            QuranVerse(id: 2, arabic: "وَكِتَابٍ مَّسْطُورٍ", french: "Par le Livre tracé !", phonetic: "Wa-kitābin masṭūr"),
        ],
        53: [
            QuranVerse(id: 1, arabic: "وَالنَّجْمِ إِذَا هَوَىٰ", french: "Par l'étoile quand elle tombe !", phonetic: "Wa-n-najmi iḏā hawā"),
            QuranVerse(id: 2, arabic: "مَا ضَلَّ صَاحِبُكُمْ وَمَا غَوَىٰ", french: "Votre compagnon ne s'est pas égaré, ni fourvoyé,", phonetic: "Mā ḍalla ṣāḥibukum wa-mā ġawā"),
        ],
        54: [
            QuranVerse(id: 1, arabic: "اقْتَرَبَتِ السَّاعَةُ وَانشَقَّ الْقَمَرُ", french: "L'Heure s'est approchée et la lune s'est fendue.", phonetic: "Iqtarabati s-sāʿatu wa-nšaqqa l-qamar"),
            QuranVerse(id: 2, arabic: "وَإِن يَرَوْا آيَةً يُعْرِضُوا وَيَقُولُوا سِحْرٌ مُّسْتَمِرٌّ", french: "Et s'ils voient un prodige, ils se détournent et disent : Magie continue !", phonetic: "Wa-in yaraw āyatan yuʿriḍū wa-yaqūlū siḥrun mustamirr"),
        ],
        55: [
            QuranVerse(id: 1, arabic: "الرَّحْمَٰنُ", french: "Le Tout Miséricordieux,", phonetic: "Ar-raḥmān"),
            QuranVerse(id: 2, arabic: "عَلَّمَ الْقُرْآنَ", french: "a enseigné le Coran,", phonetic: "ʿAllama l-qurʾān"),
            QuranVerse(id: 3, arabic: "خَلَقَ الْإِنسَانَ", french: "a créé l'homme,", phonetic: "Ḫalaqa l-insān"),
            QuranVerse(id: 4, arabic: "عَلَّمَهُ الْبَيَانَ", french: "lui a enseigné à s'exprimer.", phonetic: "ʿAllamahu l-bayān"),
            QuranVerse(id: 5, arabic: "الشَّمْسُ وَالْقَمَرُ بِحُسْبَانٍ", french: "Le soleil et la lune [suivent] un calcul précis.", phonetic: "Aš-šamsu wa-l-qamaru bi-ḥusbān"),
            QuranVerse(id: 6, arabic: "وَالنَّجْمُ وَالشَّجَرُ يَسْجُدَانِ", french: "L'herbe et les arbres se prosternent.", phonetic: "Wa-n-najmu wa-š-šajaru yasjudān"),
            QuranVerse(id: 7, arabic: "وَالسَّمَاءَ رَفَعَهَا وَوَضَعَ الْمِيزَانَ", french: "Il a élevé le ciel et établi la balance,", phonetic: "Wa-s-samāʾa rafaʿahā wa-waḍaʿa l-mīzān"),
            QuranVerse(id: 13, arabic: "فَبِأَيِّ آلَاءِ رَبِّكُمَا تُكَذِّبَانِ", french: "Alors, laquelle des faveurs de votre Seigneur nierez-vous ?", phonetic: "Fa-bi-ayyi ālāʾi rabbikumā tukaḏḏibān"),
        ],
        56: [
            QuranVerse(id: 1, arabic: "إِذَا وَقَعَتِ الْوَاقِعَةُ", french: "Quand l'Événement arrivera,", phonetic: "Iḏā waqaʿati l-wāqiʿa"),
            QuranVerse(id: 2, arabic: "لَيْسَ لِوَقْعَتِهَا كَاذِبَةٌ", french: "nul ne pourra en nier l'avènement.", phonetic: "Laysa li-waqʿatihā kāḏiba"),
            QuranVerse(id: 3, arabic: "خَافِضَةٌ رَّافِعَةٌ", french: "[Cet Événement] rabaissera les uns et élèvera les autres.", phonetic: "Ḫāfiḍatun rāfiʿa"),
        ],
        57: [
            QuranVerse(id: 1, arabic: "سَبَّحَ لِلَّهِ مَا فِي السَّمَاوَاتِ وَالْأَرْضِ وَهُوَ الْعَزِيزُ الْحَكِيمُ", french: "Ce qui est dans les cieux et sur la terre glorifie Allah. C'est Lui le Puissant, le Sage.", phonetic: "Sabbaḥa lillāhi mā fī s-samāwāti wa-l-arḍi wa-huwa l-ʿazīzu l-ḥakīm"),
        ],
        58: [
            QuranVerse(id: 1, arabic: "قَدْ سَمِعَ اللَّهُ قَوْلَ الَّتِي تُجَادِلُكَ فِي زَوْجِهَا وَتَشْتَكِي إِلَى اللَّهِ وَاللَّهُ يَسْمَعُ تَحَاوُرَكُمَا إِنَّ اللَّهَ سَمِيعٌ بَصِيرٌ", french: "Allah a certes entendu la parole de celle qui te dispute [son cas] à propos de son mari et se plaint à Allah. Et Allah vous entend dialoguer. Allah est vraiment Audient et Clairvoyant.", phonetic: "Qad samiʿa llāhu qawla llatī tujādiluka fī zawjihā wa-taštakī ilā llāh"),
        ],
        59: [
            QuranVerse(id: 1, arabic: "سَبَّحَ لِلَّهِ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ وَهُوَ الْعَزِيزُ الْحَكِيمُ", french: "Ce qui est dans les cieux et ce qui est sur la terre glorifient Allah. Et c'est Lui le Puissant, le Sage.", phonetic: "Sabbaḥa lillāhi mā fī s-samāwāti wa-mā fī l-arḍi wa-huwa l-ʿazīzu l-ḥakīm"),
        ],
        60: [
            QuranVerse(id: 1, arabic: "يَا أَيُّهَا الَّذِينَ آمَنُوا لَا تَتَّخِذُوا عَدُوِّي وَعَدُوَّكُمْ أَوْلِيَاءَ تُلْقُونَ إِلَيْهِم بِالْمَوَدَّةِ", french: "Ô vous qui avez cru ! Ne prenez pas Mes ennemis et vos ennemis pour alliés, en leur témoignant de l'amitié.", phonetic: "Yā ayyuhā llaḏīna āmanū lā tattaḫiḏū ʿaduwwī wa-ʿaduwwakum awliyāʾ"),
        ],
        61: [
            QuranVerse(id: 1, arabic: "سَبَّحَ لِلَّهِ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ وَهُوَ الْعَزِيزُ الْحَكِيمُ", french: "Ce qui est dans les cieux et ce qui est sur la terre glorifient Allah. Et c'est Lui le Puissant, le Sage.", phonetic: "Sabbaḥa lillāhi mā fī s-samāwāti wa-mā fī l-arḍi wa-huwa l-ʿazīzu l-ḥakīm"),
        ],
        62: [
            QuranVerse(id: 1, arabic: "يُسَبِّحُ لِلَّهِ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ الْمَلِكِ الْقُدُّوسِ الْعَزِيزِ الْحَكِيمِ", french: "Ce qui est dans les cieux et ce qui est sur la terre glorifient Allah, le Souverain, le Pur, le Puissant, le Sage.", phonetic: "Yusabbiḥu lillāhi mā fī s-samāwāti wa-mā fī l-arḍi l-maliki l-quddūsi l-ʿazīzi l-ḥakīm"),
        ],
        63: [
            QuranVerse(id: 1, arabic: "إِذَا جَاءَكَ الْمُنَافِقُونَ قَالُوا نَشْهَدُ إِنَّكَ لَرَسُولُ اللَّهِ وَاللَّهُ يَعْلَمُ إِنَّكَ لَرَسُولُهُ وَاللَّهُ يَشْهَدُ إِنَّ الْمُنَافِقِينَ لَكَاذِبُونَ", french: "Quand les hypocrites viennent à toi, ils disent : Nous attestons que tu es certes le messager d'Allah. Allah sait que tu es Son messager, et Allah atteste que les hypocrites sont des menteurs.", phonetic: "Iḏā jāʾaka l-munāfiqūna qālū našhadu innaka la-rasūlu llāh"),
        ],
        64: [
            QuranVerse(id: 1, arabic: "يُسَبِّحُ لِلَّهِ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ", french: "Ce qui est dans les cieux et ce qui est sur la terre glorifient Allah. A Lui la royauté. A Lui la louange. Et Il est Omnipotent.", phonetic: "Yusabbiḥu lillāhi mā fī s-samāwāti wa-mā fī l-arḍ"),
        ],
        65: [
            QuranVerse(id: 1, arabic: "يَا أَيُّهَا النَّبِيُّ إِذَا طَلَّقْتُمُ النِّسَاءَ فَطَلِّقُوهُنَّ لِعِدَّتِهِنَّ وَأَحْصُوا الْعِدَّةَ وَاتَّقُوا اللَّهَ رَبَّكُمْ", french: "Ô Prophète ! Quand vous répudiez des femmes, répudiez-les à leur temps prescrit et calculez la période prescrite. Et craignez Allah votre Seigneur.", phonetic: "Yā ayyuhā n-nabiyyu iḏā ṭallaqtumu n-nisāʾa fa-ṭalliqūhunna li-ʿiddatihinn"),
        ],
        66: [
            QuranVerse(id: 1, arabic: "يَا أَيُّهَا النَّبِيُّ لِمَ تُحَرِّمُ مَا أَحَلَّ اللَّهُ لَكَ تَبْتَغِي مَرْضَاتَ أَزْوَاجِكَ وَاللَّهُ غَفُورٌ رَّحِيمٌ", french: "Ô Prophète ! Pourquoi interdis-tu ce qu'Allah a rendu licite pour toi, cherchant à plaire à tes épouses ? Allah est Pardonneur, Miséricordieux.", phonetic: "Yā ayyuhā n-nabiyyu lima tuḥarrimu mā aḥalla llāhu laka tabtagī marḍāta azwājik"),
        ],
        67: [
            QuranVerse(id: 1, arabic: "تَبَارَكَ الَّذِي بِيَدِهِ الْمُلْكُ وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ", french: "Béni soit Celui en Whose mains est la royauté. Et Il est Omnipotent.", phonetic: "Tabāraka llaḏī bi-yadihi l-mulku wa-huwa ʿalā kulli šayʾin qadīr"),
            QuranVerse(id: 2, arabic: "الَّذِي خَلَقَ الْمَوْتَ وَالْحَيَاةَ لِيَبْلُوَكُمْ أَيُّكُمْ أَحْسَنُ عَمَلًا وَهُوَ الْعَزِيزُ الْغَفُورُ", french: "Celui qui a créé la mort et la vie afin de vous éprouver et de savoir qui de vous est le meilleur en œuvres. Et c'est Lui le Puissant, le Très Pardonneur.", phonetic: "Allaḏī ḫalaqa l-mawta wa-l-ḥayāta li-yabluwakum ayyukum aḥsanu ʿamalā"),
            QuranVerse(id: 3, arabic: "الَّذِي خَلَقَ سَبْعَ سَمَاوَاتٍ طِبَاقًا مَّا تَرَىٰ فِي خَلْقِ الرَّحْمَٰنِ مِن تَفَاوُتٍ فَارْجِعِ الْبَصَرَ هَلْ تَرَىٰ مِن فُطُورٍ", french: "Il a créé sept cieux superposés. Tu ne vois pas de défaut dans la création du Tout Miséricordieux. Alors ramène le regard : y vois-tu une fissure ?", phonetic: "Allaḏī ḫalaqa sabʿa samāwātin ṭibāqan mā tarā fī ḫalqi r-raḥmāni min tafāwut"),
        ],
        68: [
            QuranVerse(id: 1, arabic: "ن وَالْقَلَمِ وَمَا يَسْطُرُونَ", french: "Nûn. Par la plume et ce qu'ils écrivent !", phonetic: "Nūn wa-l-qalami wa-mā yasṭurūn"),
            QuranVerse(id: 2, arabic: "مَا أَنتَ بِنِعْمَةِ رَبِّكَ بِمَجْنُونٍ", french: "Tu n'es pas, grâce au bienfait de ton Seigneur, un possédé.", phonetic: "Mā anta bi-niʿmati rabbika bi-majnūn"),
        ],
        69: [
            QuranVerse(id: 1, arabic: "الْحَاقَّةُ", french: "L'Inévitable !", phonetic: "Al-ḥāqqa"),
            QuranVerse(id: 2, arabic: "مَا الْحَاقَّةُ", french: "Qu'est-ce que l'Inévitable ?", phonetic: "Ma l-ḥāqqa"),
            QuranVerse(id: 3, arabic: "وَمَا أَدْرَاكَ مَا الْحَاقَّةُ", french: "Et comment sauras-tu ce qu'est l'Inévitable ?", phonetic: "Wa-mā adrāka ma l-ḥāqqa"),
        ],
        70: [
            QuranVerse(id: 1, arabic: "سَأَلَ سَائِلٌ بِعَذَابٍ وَاقِعٍ", french: "Un demandeur a demandé un châtiment imminent,", phonetic: "Saʾala sāʾilun bi-ʿaḏābin wāqiʿ"),
            QuranVerse(id: 2, arabic: "لِّلْكَافِرِينَ لَيْسَ لَهُ دَافِعٌ", french: "pour les mécréants, dont personne ne peut écarter.", phonetic: "Li-l-kāfirīna laysa lahu dāfiʿ"),
        ],
        71: [
            QuranVerse(id: 1, arabic: "إِنَّا أَرْسَلْنَا نُوحًا إِلَىٰ قَوْمِهِ أَنْ أَنذِرْ قَوْمَكَ مِن قَبْلِ أَن يَأْتِيَهُمْ عَذَابٌ أَلِيمٌ", french: "Nous avons envoyé Noé à son peuple, en lui disant : Avertis ton peuple avant que ne leur vienne un châtiment douloureux.", phonetic: "Innā arsalnā nūḥan ilā qawmihi an anḏir qawmaka min qabli an yaʾtiyahum ʿaḏābun alīm"),
        ],
        72: [
            QuranVerse(id: 1, arabic: "قُلْ أُوحِيَ إِلَيَّ أَنَّهُ اسْتَمَعَ نَفَرٌ مِّنَ الْجِنِّ فَقَالُوا إِنَّا سَمِعْنَا قُرْآنًا عَجَبًا", french: "Dis : Il m'a été révélé qu'une compagnie de djinns a écouté et dit : Nous avons entendu un Coran prodigieux,", phonetic: "Qul ūḥiya ilayya annahu stamaʿa nafarun mina l-jinni fa-qālū innā samiʿnā qurʾānan ʿajabā"),
            QuranVerse(id: 2, arabic: "يَهْدِي إِلَى الرُّشْدِ فَآمَنَّا بِهِ وَلَن نُّشْرِكَ بِرَبِّنَا أَحَدًا", french: "qui guide vers la droiture. Nous avons donc cru en lui, et nous n'associerons jamais personne à notre Seigneur.", phonetic: "Yahdī ilā r-rušdi fa-āmannā bihi wa-lan nušrika bi-rabbinā aḥadā"),
        ],
        73: [
            QuranVerse(id: 1, arabic: "يَا أَيُّهَا الْمُزَّمِّلُ", french: "Ô toi, l'enveloppé !", phonetic: "Yā ayyuhā l-muzzammil"),
            QuranVerse(id: 2, arabic: "قُمِ اللَّيْلَ إِلَّا قَلِيلًا", french: "Lève-toi [pour prier] la nuit, sauf une petite partie.", phonetic: "Qumi l-layla illā qalīlā"),
            QuranVerse(id: 3, arabic: "نِّصْفَهُ أَوِ انقُصْ مِنْهُ قَلِيلًا", french: "Sa moitié, ou diminue un peu,", phonetic: "Niṣfahu awi nquṣ minhu qalīlā"),
            QuranVerse(id: 4, arabic: "أَوْ زِدْ عَلَيْهِ وَرَتِّلِ الْقُرْآنَ تَرْتِيلًا", french: "ou augmente par rapport à cela, et récite le Coran posément.", phonetic: "Aw zid ʿalayhi wa-rattili l-qurʾāna tartīlā"),
        ],
        74: [
            QuranVerse(id: 1, arabic: "يَا أَيُّهَا الْمُدَّثِّرُ", french: "Ô toi, le revêtu d'un manteau !", phonetic: "Yā ayyuhā l-muddaṯṯir"),
            QuranVerse(id: 2, arabic: "قُمْ فَأَنذِرْ", french: "Lève-toi et avertis !", phonetic: "Qum fa-anḏir"),
            QuranVerse(id: 3, arabic: "وَرَبَّكَ فَكَبِّرْ", french: "Et ton Seigneur, magnifie-Le !", phonetic: "Wa-rabbaka fa-kabbir"),
            QuranVerse(id: 4, arabic: "وَثِيَابَكَ فَطَهِّرْ", french: "Et tes vêtements, purifie-les !", phonetic: "Wa-ṯiyābaka fa-ṭahhir"),
            QuranVerse(id: 5, arabic: "وَالرُّجْزَ فَاهْجُرْ", french: "Et les idoles, fuis-les !", phonetic: "Wa-r-rujza fa-hjur"),
        ],
        75: [
            QuranVerse(id: 1, arabic: "لَا أُقْسِمُ بِيَوْمِ الْقِيَامَةِ", french: "Non ! Je jure par le Jour de la Résurrection !", phonetic: "Lā uqsimu bi-yawmi l-qiyāma"),
            QuranVerse(id: 2, arabic: "وَلَا أُقْسِمُ بِالنَّفْسِ اللَّوَّامَةِ", french: "Et non, je jure par l'âme qui se blâme !", phonetic: "Wa-lā uqsimu bi-n-nafsi l-lawwāma"),
        ],
        76: [
            QuranVerse(id: 1, arabic: "هَلْ أَتَىٰ عَلَى الْإِنسَانِ حِينٌ مِّنَ الدَّهْرِ لَمْ يَكُن شَيْئًا مَّذْكُورًا", french: "N'est-il pas venu sur l'homme un laps de temps où il n'était pas une chose mentionnable ?", phonetic: "Hal atā ʿalā l-insāni ḥīnun mina d-dahri lam yakun šayʾan maḏkūrā"),
            QuranVerse(id: 2, arabic: "إِنَّا خَلَقْنَا الْإِنسَانَ مِن نُّطْفَةٍ أَمْشَاجٍ نَّبْتَلِيهِ فَجَعَلْنَاهُ سَمِيعًا بَصِيرًا", french: "Nous avons créé l'homme d'une goutte de sperme mêlé, pour l'éprouver, et Nous l'avons fait entendant et voyant.", phonetic: "Innā ḫalaqnā l-insāna min nuṭfatin amšājin nabtalīhi fa-jaʿalnāhu samīʿan baṣīrā"),
        ],
        77: [
            QuranVerse(id: 1, arabic: "وَالْمُرْسَلَاتِ عُرْفًا", french: "Par ceux envoyés successivement !", phonetic: "Wa-l-mursalāti ʿurfā"),
            QuranVerse(id: 2, arabic: "فَالْعَاصِفَاتِ عَصْفًا", french: "Par ceux qui soufflent en tempête !", phonetic: "Fa-l-ʿāṣifāti ʿaṣfā"),
        ],
        78: [
            QuranVerse(id: 1, arabic: "عَمَّ يَتَسَاءَلُونَ", french: "De quoi s'interrogent-ils ?", phonetic: "ʿAmma yatasāʾalūn"),
            QuranVerse(id: 2, arabic: "عَنِ النَّبَإِ الْعَظِيمِ", french: "Au sujet de la grande nouvelle,", phonetic: "ʿAni n-nabaʾi l-ʿaẓīm"),
            QuranVerse(id: 3, arabic: "الَّذِي هُمْ فِيهِ مُخْتَلِفُونَ", french: "à propos de laquelle ils divergent.", phonetic: "Allaḏī hum fīhi muḫtalifūn"),
        ],
        79: [
            QuranVerse(id: 1, arabic: "وَالنَّازِعَاتِ غَرْقًا", french: "Par ceux qui arrachent violemment !", phonetic: "Wa-n-nāziʿāti ġarqā"),
            QuranVerse(id: 2, arabic: "وَالنَّاشِطَاتِ نَشْطًا", french: "Par ceux qui retirent doucement !", phonetic: "Wa-n-nāšiṭāti našṭā"),
        ],
        80: [
            QuranVerse(id: 1, arabic: "عَبَسَ وَتَوَلَّىٰ", french: "Il fronça les sourcils et se détourna,", phonetic: "ʿAbasa wa-tawallā"),
            QuranVerse(id: 2, arabic: "أَن جَاءَهُ الْأَعْمَىٰ", french: "parce que l'aveugle était venu à lui.", phonetic: "An jāʾahu l-aʿmā"),
        ],
        81: [
            QuranVerse(id: 1, arabic: "إِذَا الشَّمْسُ كُوِّرَتْ", french: "Quand le soleil sera enroulé,", phonetic: "Iḏā š-šamsu kuwwirat"),
            QuranVerse(id: 2, arabic: "وَإِذَا النُّجُومُ انكَدَرَتْ", french: "quand les étoiles s'obscurciront,", phonetic: "Wa-iḏā n-nujūmu nkadarat"),
            QuranVerse(id: 3, arabic: "وَإِذَا الْجِبَالُ سُيِّرَتْ", french: "quand les montagnes seront mises en marche,", phonetic: "Wa-iḏā l-jibālu suyyirat"),
        ],
        82: [
            QuranVerse(id: 1, arabic: "إِذَا السَّمَاءُ انفَطَرَتْ", french: "Quand le ciel se déchirera,", phonetic: "Iḏā s-samāʾu nfaṭarat"),
            QuranVerse(id: 2, arabic: "وَإِذَا الْكَوَاكِبُ انتَثَرَتْ", french: "quand les planètes se disperseront,", phonetic: "Wa-iḏā l-kawākibu ntaṯarat"),
            QuranVerse(id: 3, arabic: "وَإِذَا الْبِحَارُ فُجِّرَتْ", french: "quand les mers se mélangeront,", phonetic: "Wa-iḏā l-biḥāru fujjirat"),
        ],
        83: [
            QuranVerse(id: 1, arabic: "وَيْلٌ لِّلْمُطَفِّفِينَ", french: "Malheur aux fraudeurs,", phonetic: "Waylun li-l-muṭaffifīn"),
            QuranVerse(id: 2, arabic: "الَّذِينَ إِذَا اكْتَالُوا عَلَى النَّاسِ يَسْتَوْفُونَ", french: "qui lorsqu'ils font mesurer par les autres à leur profit, prennent la pleine mesure,", phonetic: "Allaḏīna iḏā ktālū ʿalā n-nāsi yastaufūn"),
            QuranVerse(id: 3, arabic: "وَإِذَا كَالُوهُمْ أَو وَّزَنُوهُمْ يُخْسِرُونَ", french: "mais qui lorsqu'ils mesurent ou pèsent pour les autres, causent un déficit.", phonetic: "Wa-iḏā kālūhum aw wazanūhum yuḫsirūn"),
        ],
        84: [
            QuranVerse(id: 1, arabic: "إِذَا السَّمَاءُ انشَقَّتْ", french: "Quand le ciel se fissurera,", phonetic: "Iḏā s-samāʾu nšaqqat"),
            QuranVerse(id: 2, arabic: "وَأَذِنَتْ لِرَبِّهَا وَحُقَّتْ", french: "qu'il aura obéi à son Seigneur comme il se doit,", phonetic: "Wa-aḏinat li-rabbihā wa-ḥuqqat"),
        ],
        85: [
            QuranVerse(id: 1, arabic: "وَالسَّمَاءِ ذَاتِ الْبُرُوجِ", french: "Par le ciel aux constellations !", phonetic: "Wa-s-samāʾi ḏāti l-burūj"),
            QuranVerse(id: 2, arabic: "وَالْيَوْمِ الْمَوْعُودِ", french: "Par le Jour promis !", phonetic: "Wa-l-yawmi l-mawʿūd"),
            QuranVerse(id: 3, arabic: "وَشَاهِدٍ وَمَشْهُودٍ", french: "Par le témoin et par ce dont on est témoin !", phonetic: "Wa-šāhidin wa-mašhūd"),
        ],
        86: [
            QuranVerse(id: 1, arabic: "وَالسَّمَاءِ وَالطَّارِقِ", french: "Par le ciel et l'astre nocturne !", phonetic: "Wa-s-samāʾi wa-ṭ-ṭāriq"),
            QuranVerse(id: 2, arabic: "وَمَا أَدْرَاكَ مَا الطَّارِقُ", french: "Et comment sauras-tu ce qu'est l'astre nocturne ?", phonetic: "Wa-mā adrāka ma ṭ-ṭāriq"),
            QuranVerse(id: 3, arabic: "النَّجْمُ الثَّاقِبُ", french: "C'est l'étoile perforante.", phonetic: "An-najmu ṯ-ṯāqib"),
        ],
        87: [
            QuranVerse(id: 1, arabic: "سَبِّحِ اسْمَ رَبِّكَ الْأَعْلَى", french: "Glorifie le nom de ton Seigneur le Très Haut,", phonetic: "Sabbiḥi sma rabbika l-aʿlā"),
            QuranVerse(id: 2, arabic: "الَّذِي خَلَقَ فَسَوَّىٰ", french: "qui a créé et harmonisé,", phonetic: "Allaḏī ḫalaqa fa-sawwā"),
            QuranVerse(id: 3, arabic: "وَالَّذِي قَدَّرَ فَهَدَىٰ", french: "qui a décrété et guidé,", phonetic: "Wa-llaḏī qaddara fa-hadā"),
            QuranVerse(id: 4, arabic: "وَالَّذِي أَخْرَجَ الْمَرْعَىٰ", french: "qui a fait sortir le pâturage,", phonetic: "Wa-llaḏī aḫraja l-marʿā"),
            QuranVerse(id: 5, arabic: "فَجَعَلَهُ غُثَاءً أَحْوَىٰ", french: "et en a fait ensuite un débris noirâtre.", phonetic: "Fa-jaʿalahu ġuṯāʾan aḥwā"),
        ],
        88: [
            QuranVerse(id: 1, arabic: "هَلْ أَتَاكَ حَدِيثُ الْغَاشِيَةِ", french: "T'est-il parvenu le récit de l'Enveloppante ?", phonetic: "Hal atāka ḥadīṯu l-ġāšiya"),
            QuranVerse(id: 2, arabic: "وُجُوهٌ يَوْمَئِذٍ خَاشِعَةٌ", french: "Des visages, ce Jour-là, seront humiliés,", phonetic: "Wujūhun yawmaʾiḏin ḫāšiʿa"),
            QuranVerse(id: 3, arabic: "عَامِلَةٌ نَّاصِبَةٌ", french: "travaillant et épuisés.", phonetic: "ʿĀmilatun nāṣiba"),
        ],
        89: [
            QuranVerse(id: 1, arabic: "وَالْفَجْرِ", french: "Par l'aube !", phonetic: "Wa-l-fajr"),
            QuranVerse(id: 2, arabic: "وَلَيَالٍ عَشْرٍ", french: "Par les dix nuits !", phonetic: "Wa-layālin ʿašr"),
            QuranVerse(id: 3, arabic: "وَالشَّفْعِ وَالْوَتْرِ", french: "Par le pair et l'impair !", phonetic: "Wa-š-šafʿi wa-l-watr"),
            QuranVerse(id: 4, arabic: "وَاللَّيْلِ إِذَا يَسْرِ", french: "Par la nuit quand elle s'écoule !", phonetic: "Wa-l-layli iḏā yasr"),
        ],
        90: [
            QuranVerse(id: 1, arabic: "لَا أُقْسِمُ بِهَٰذَا الْبَلَدِ", french: "Non ! Je jure par cette cité,", phonetic: "Lā uqsimu bi-hāḏā l-balad"),
            QuranVerse(id: 2, arabic: "وَأَنتَ حِلٌّ بِهَٰذَا الْبَلَدِ", french: "et toi, tu es un habitant de cette cité,", phonetic: "Wa-anta ḥillun bi-hāḏā l-balad"),
            QuranVerse(id: 3, arabic: "وَوَالِدٍ وَمَا وَلَدَ", french: "et par le géniteur et ce qu'il a engendré !", phonetic: "Wa-wālidin wa-mā walad"),
        ],
        91: [
            QuranVerse(id: 1, arabic: "وَالشَّمْسِ وَضُحَاهَا", french: "Par le soleil et sa clarté matinale !", phonetic: "Wa-š-šamsi wa-ḍuḥāhā"),
            QuranVerse(id: 2, arabic: "وَالْقَمَرِ إِذَا تَلَاهَا", french: "Par la lune quand elle lui succède !", phonetic: "Wa-l-qamari iḏā talāhā"),
            QuranVerse(id: 3, arabic: "وَالنَّهَارِ إِذَا جَلَّاهَا", french: "Par le jour quand il l'illumine !", phonetic: "Wa-n-nahāri iḏā jallāhā"),
            QuranVerse(id: 4, arabic: "وَاللَّيْلِ إِذَا يَغْشَاهَا", french: "Par la nuit quand elle la couvre !", phonetic: "Wa-l-layli iḏā yaġšāhā"),
            QuranVerse(id: 5, arabic: "وَالسَّمَاءِ وَمَا بَنَاهَا", french: "Par le ciel et Celui qui l'a construit !", phonetic: "Wa-s-samāʾi wa-mā banāhā"),
        ],
        92: [
            QuranVerse(id: 1, arabic: "وَاللَّيْلِ إِذَا يَغْشَىٰ", french: "Par la nuit quand elle couvre !", phonetic: "Wa-l-layli iḏā yaġšā"),
            QuranVerse(id: 2, arabic: "وَالنَّهَارِ إِذَا تَجَلَّىٰ", french: "Par le jour quand il paraît !", phonetic: "Wa-n-nahāri iḏā tajallā"),
            QuranVerse(id: 3, arabic: "وَمَا خَلَقَ الذَّكَرَ وَالْأُنثَىٰ", french: "Par Celui qui a créé le mâle et la femelle !", phonetic: "Wa-mā ḫalaqa ḏ-ḏakara wa-l-unṯā"),
        ],
        93: [
            QuranVerse(id: 1, arabic: "وَالضُّحَىٰ", french: "Par la matinée !", phonetic: "Wa-ḍ-ḍuḥā"),
            QuranVerse(id: 2, arabic: "وَاللَّيْلِ إِذَا سَجَىٰ", french: "Par la nuit quand elle s'apaise !", phonetic: "Wa-l-layli iḏā sajā"),
            QuranVerse(id: 3, arabic: "مَا وَدَّعَكَ رَبُّكَ وَمَا قَلَىٰ", french: "Ton Seigneur ne t'a pas abandonné et ne t'a pas haï.", phonetic: "Mā waddaʿaka rabbuka wa-mā qalā"),
            QuranVerse(id: 4, arabic: "وَلَلْآخِرَةُ خَيْرٌ لَّكَ مِنَ الْأُولَىٰ", french: "Et certes, l'au-delà est meilleur pour toi que la vie d'ici-bas.", phonetic: "Wa-la-l-āḫiratu ḫayrun laka mina l-ūlā"),
            QuranVerse(id: 5, arabic: "وَلَسَوْفَ يُعْطِيكَ رَبُّكَ فَتَرْضَىٰ", french: "Et bientôt ton Seigneur te donnera et tu seras satisfait.", phonetic: "Wa-la-sawfa yuʿṭīka rabbuka fa-tarḍā"),
        ],
        94: [
            QuranVerse(id: 1, arabic: "أَلَمْ نَشْرَحْ لَكَ صَدْرَكَ", french: "N'avons-Nous pas dilaté ta poitrine ?", phonetic: "Alam našraḥ laka ṣadrak"),
            QuranVerse(id: 2, arabic: "وَوَضَعْنَا عَنكَ وِزْرَكَ", french: "Et Nous avons allégé ton fardeau,", phonetic: "Wa-waḍaʿnā ʿanka wizrak"),
            QuranVerse(id: 3, arabic: "الَّذِي أَنقَضَ ظَهْرَكَ", french: "qui t'écrasait le dos,", phonetic: "Allaḏī anqaḍa ẓahrak"),
            QuranVerse(id: 4, arabic: "وَرَفَعْنَا لَكَ ذِكْرَكَ", french: "et Nous avons élevé ta renommée ?", phonetic: "Wa-rafaʿnā laka ḏikrak"),
            QuranVerse(id: 5, arabic: "فَإِنَّ مَعَ الْعُسْرِ يُسْرًا", french: "Certes, avec la difficulté il y a la facilité,", phonetic: "Fa-inna maʿa l-ʿusri yusrā"),
            QuranVerse(id: 6, arabic: "إِنَّ مَعَ الْعُسْرِ يُسْرًا", french: "oui, avec la difficulté il y a la facilité.", phonetic: "Inna maʿa l-ʿusri yusrā"),
            QuranVerse(id: 7, arabic: "فَإِذَا فَرَغْتَ فَانصَبْ", french: "Donc, quand tu te libères, travaille encore,", phonetic: "Fa-iḏā faraġta fa-nṣab"),
            QuranVerse(id: 8, arabic: "وَإِلَىٰ رَبِّكَ فَارْغَب", french: "et vers ton Seigneur, recherche !", phonetic: "Wa-ilā rabbika fa-rġab"),
        ],
        95: [
            QuranVerse(id: 1, arabic: "وَالتِّينِ وَالزَّيْتُونِ", french: "Par le figuier et l'olivier !", phonetic: "Wa-t-tīni wa-z-zaytūn"),
            QuranVerse(id: 2, arabic: "وَطُورِ سِينِينَ", french: "Par le Mont Sinaï !", phonetic: "Wa-ṭūri sīnīn"),
            QuranVerse(id: 3, arabic: "وَهَٰذَا الْبَلَدِ الْأَمِينِ", french: "Par cette cité sûre !", phonetic: "Wa-hāḏā l-baladi l-amīn"),
            QuranVerse(id: 4, arabic: "لَقَدْ خَلَقْنَا الْإِنسَانَ فِي أَحْسَنِ تَقْوِيمٍ", french: "Nous avons certes créé l'homme dans la meilleure des formes.", phonetic: "La-qad ḫalaqnā l-insāna fī aḥsani taqwīm"),
            QuranVerse(id: 5, arabic: "ثُمَّ رَدَدْنَاهُ أَسْفَلَ سَافِلِينَ", french: "Puis Nous l'avons ramené au niveau le plus bas,", phonetic: "Ṯumma radadnāhu asfala sāfilīn"),
            QuranVerse(id: 6, arabic: "إِلَّا الَّذِينَ آمَنُوا وَعَمِلُوا الصَّالِحَاتِ فَلَهُمْ أَجْرٌ غَيْرُ مَمْنُونٍ", french: "sauf ceux qui ont cru et fait de bonnes œuvres : ceux-là auront une récompense sans interruption.", phonetic: "Illā llaḏīna āmanū wa-ʿamilū ṣ-ṣāliḥāti fa-lahum ajrun ġayru mamnūn"),
            QuranVerse(id: 7, arabic: "فَمَا يُكَذِّبُكَ بَعْدُ بِالدِّينِ", french: "Qu'est-ce qui, après cela, te fait traiter de menteur la religion ?", phonetic: "Fa-mā yukaḏḏibuka baʿdu bi-d-dīn"),
            QuranVerse(id: 8, arabic: "أَلَيْسَ اللَّهُ بِأَحْكَمِ الْحَاكِمِينَ", french: "Allah n'est-Il pas le plus Juste des juges ?", phonetic: "A-laysa llāhu bi-aḥkami l-ḥākimīn"),
        ],
        96: [
            QuranVerse(id: 1, arabic: "اقْرَأْ بِاسْمِ رَبِّكَ الَّذِي خَلَقَ", french: "Lis, au nom de ton Seigneur qui a créé,", phonetic: "Iqraʾ bi-smi rabbika llaḏī ḫalaq"),
            QuranVerse(id: 2, arabic: "خَلَقَ الْإِنسَانَ مِنْ عَلَقٍ", french: "qui a créé l'homme d'une adhérence.", phonetic: "Ḫalaqa l-insāna min ʿalaq"),
            QuranVerse(id: 3, arabic: "اقْرَأْ وَرَبُّكَ الْأَكْرَمُ", french: "Lis ! Ton Seigneur est le Plus Généreux,", phonetic: "Iqraʾ wa-rabbuka l-akram"),
            QuranVerse(id: 4, arabic: "الَّذِي عَلَّمَ بِالْقَلَمِ", french: "qui a enseigné par la plume,", phonetic: "Allaḏī ʿallama bi-l-qalam"),
            QuranVerse(id: 5, arabic: "عَلَّمَ الْإِنسَانَ مَا لَمْ يَعْلَمْ", french: "a enseigné à l'homme ce qu'il ne savait pas.", phonetic: "ʿAllama l-insāna mā lam yaʿlam"),
        ],
        97: [
            QuranVerse(id: 1, arabic: "إِنَّا أَنزَلْنَاهُ فِي لَيْلَةِ الْقَدْرِ", french: "Nous l'avons certes révélé durant la Nuit de la Destinée.", phonetic: "Innā anzalnāhu fī laylati l-qadr"),
            QuranVerse(id: 2, arabic: "وَمَا أَدْرَاكَ مَا لَيْلَةُ الْقَدْرِ", french: "Et comment sauras-tu ce qu'est la Nuit de la Destinée ?", phonetic: "Wa-mā adrāka mā laylatu l-qadr"),
            QuranVerse(id: 3, arabic: "لَيْلَةُ الْقَدْرِ خَيْرٌ مِّنْ أَلْفِ شَهْرٍ", french: "La Nuit de la Destinée est meilleure que mille mois.", phonetic: "Laylatu l-qadri ḫayrun min alfi šahr"),
            QuranVerse(id: 4, arabic: "تَنَزَّلُ الْمَلَائِكَةُ وَالرُّوحُ فِيهَا بِإِذْنِ رَبِّهِم مِّن كُلِّ أَمْرٍ", french: "Les anges ainsi que l'Esprit y descendent, par permission de leur Seigneur, pour tout ordre.", phonetic: "Tanazzalu l-malāʾikatu wa-r-rūḥu fīhā bi-iḏni rabbihim min kulli amr"),
            QuranVerse(id: 5, arabic: "سَلَامٌ هِيَ حَتَّىٰ مَطْلَعِ الْفَجْرِ", french: "Elle est une paix, jusqu'à l'apparition de l'aube.", phonetic: "Salāmun hiya ḥattā maṭlaʿi l-fajr"),
        ],
        98: [
            QuranVerse(id: 1, arabic: "لَمْ يَكُنِ الَّذِينَ كَفَرُوا مِنْ أَهْلِ الْكِتَابِ وَالْمُشْرِكِينَ مُنفَكِّينَ حَتَّىٰ تَأْتِيَهُمُ الْبَيِّنَةُ", french: "Les mécréants parmi les Gens du Livre et les associateurs ne devaient pas se séparer [de leurs croyances] avant que ne leur vienne la Preuve,", phonetic: "Lam yakuni llaḏīna kafarū min ahli l-kitābi wa-l-mušrikīna munfakkīna ḥattā taʾtiyahumu l-bayyina"),
            QuranVerse(id: 2, arabic: "رَسُولٌ مِّنَ اللَّهِ يَتْلُو صُحُفًا مُّطَهَّرَةً", french: "un messager d'Allah récitant des feuilles purifiées,", phonetic: "Rasūlun mina llāhi yatlū ṣuḥufan muṭahhara"),
            QuranVerse(id: 3, arabic: "فِيهَا كُتُبٌ قَيِّمَةٌ", french: "contenant des écrits droits.", phonetic: "Fīhā kutubun qayyima"),
        ],
        99: [
            QuranVerse(id: 1, arabic: "إِذَا زُلْزِلَتِ الْأَرْضُ زِلْزَالَهَا", french: "Quand la Terre tremblera d'un puissant tremblement,", phonetic: "Iḏā zulzilati l-arḍu zilzālahā"),
            QuranVerse(id: 2, arabic: "وَأَخْرَجَتِ الْأَرْضُ أَثْقَالَهَا", french: "et que la Terre fera sortir ses fardeaux,", phonetic: "Wa-aḫrajati l-arḍu aṯqālahā"),
            QuranVerse(id: 3, arabic: "وَقَالَ الْإِنسَانُ مَا لَهَا", french: "et que l'homme dira : Qu'a-t-elle ?", phonetic: "Wa-qāla l-insānu mā lahā"),
            QuranVerse(id: 4, arabic: "يَوْمَئِذٍ تُحَدِّثُ أَخْبَارَهَا", french: "Ce jour-là, elle racontera ses nouvelles,", phonetic: "Yawmaʾiḏin tuḥaddiṯu aḫbārahā"),
            QuranVerse(id: 5, arabic: "بِأَنَّ رَبَّكَ أَوْحَىٰ لَهَا", french: "parce que ton Seigneur lui aura inspiré de le faire.", phonetic: "Bi-anna rabbaka awḥā lahā"),
            QuranVerse(id: 6, arabic: "يَوْمَئِذٍ يَصْدُرُ النَّاسُ أَشْتَاتًا لِّيُرَوْا أَعْمَالَهُمْ", french: "Ce jour-là, les gens ressortiront en groupes dispersés pour qu'on leur montre leurs œuvres.", phonetic: "Yawmaʾiḏin yaṣduru n-nāsu aštātan li-yuraw aʿmālahum"),
            QuranVerse(id: 7, arabic: "فَمَن يَعْمَلْ مِثْقَالَ ذَرَّةٍ خَيْرًا يَرَهُ", french: "Quiconque aura fait le poids d'un atome de bien, le verra.", phonetic: "Fa-man yaʿmal miṯqāla ḏarratin ḫayran yarah"),
            QuranVerse(id: 8, arabic: "وَمَن يَعْمَلْ مِثْقَالَ ذَرَّةٍ شَرًّا يَرَهُ", french: "Et quiconque aura fait le poids d'un atome de mal, le verra.", phonetic: "Wa-man yaʿmal miṯqāla ḏarratin šarran yarah"),
        ],
        100: [
            QuranVerse(id: 1, arabic: "وَالْعَادِيَاتِ ضَبْحًا", french: "Par celles qui galopent en soufflant !", phonetic: "Wa-l-ʿādiyāti ḍabḥā"),
            QuranVerse(id: 2, arabic: "فَالْمُورِيَاتِ قَدْحًا", french: "Par celles qui font jaillir des étincelles !", phonetic: "Fa-l-mūriyāti qadḥā"),
            QuranVerse(id: 3, arabic: "فَالْمُغِيرَاتِ صُبْحًا", french: "Par celles qui attaquent au matin !", phonetic: "Fa-l-muġīrāti ṣubḥā"),
        ],
        101: [
            QuranVerse(id: 1, arabic: "الْقَارِعَةُ", french: "L'Assommeuse !", phonetic: "Al-qāriʿa"),
            QuranVerse(id: 2, arabic: "مَا الْقَارِعَةُ", french: "Qu'est-ce que l'Assommeuse ?", phonetic: "Ma l-qāriʿa"),
            QuranVerse(id: 3, arabic: "وَمَا أَدْرَاكَ مَا الْقَارِعَةُ", french: "Et comment sauras-tu ce qu'est l'Assommeuse ?", phonetic: "Wa-mā adrāka ma l-qāriʿa"),
            QuranVerse(id: 4, arabic: "يَوْمَ يَكُونُ النَّاسُ كَالْفَرَاشِ الْمَبْثُوثِ", french: "Le jour où les gens seront comme des papillons éparpillés,", phonetic: "Yawma yakūnu n-nāsu ka-l-farāši l-mabṯūṯ"),
            QuranVerse(id: 5, arabic: "وَتَكُونُ الْجِبَالُ كَالْعِهْنِ الْمَنفُوشِ", french: "et les montagnes comme une laine cardée.", phonetic: "Wa-takūnu l-jibālu ka-l-ʿihni l-manfūš"),
            QuranVerse(id: 6, arabic: "فَأَمَّا مَن ثَقُلَتْ مَوَازِينُهُ", french: "Quant à celui dont la balance est lourde,", phonetic: "Fa-ammā man ṯaqulat mawāzīnuh"),
            QuranVerse(id: 7, arabic: "فَهُوَ فِي عِيشَةٍ رَّاضِيَةٍ", french: "il aura une vie agréable.", phonetic: "Fa-huwa fī ʿīšatin rāḍiya"),
            QuranVerse(id: 8, arabic: "وَأَمَّا مَنْ خَفَّتْ مَوَازِينُهُ", french: "Mais quant à celui dont la balance est légère,", phonetic: "Wa-ammā man ḫaffat mawāzīnuh"),
            QuranVerse(id: 9, arabic: "فَأُمُّهُ هَاوِيَةٌ", french: "le gouffre sera sa Mère.", phonetic: "Fa-ummuhu hāwiya"),
            QuranVerse(id: 10, arabic: "وَمَا أَدْرَاكَ مَا هِيَهْ", french: "Et comment sauras-tu ce qu'il est ?", phonetic: "Wa-mā adrāka mā hiyah"),
            QuranVerse(id: 11, arabic: "نَارٌ حَامِيَةٌ", french: "C'est un feu ardent.", phonetic: "Nārun ḥāmiya"),
        ],
        102: [
            QuranVerse(id: 1, arabic: "أَلْهَاكُمُ التَّكَاثُرُ", french: "La course aux richesses vous distrait,", phonetic: "Alhākumu t-takāṯur"),
            QuranVerse(id: 2, arabic: "حَتَّىٰ زُرْتُمُ الْمَقَابِرَ", french: "jusqu'à ce que vous visitiez les tombeaux.", phonetic: "Ḥattā zurtumu l-maqābir"),
            QuranVerse(id: 3, arabic: "كَلَّا سَوْفَ تَعْلَمُونَ", french: "Non ! Vous saurez bientôt.", phonetic: "Kallā sawfa taʿlamūn"),
            QuranVerse(id: 4, arabic: "ثُمَّ كَلَّا سَوْفَ تَعْلَمُونَ", french: "Puis non ! Vous saurez bientôt.", phonetic: "Ṯumma kallā sawfa taʿlamūn"),
            QuranVerse(id: 5, arabic: "كَلَّا لَوْ تَعْلَمُونَ عِلْمَ الْيَقِينِ", french: "Non ! Si vous saviez d'une science certaine...", phonetic: "Kallā law taʿlamūna ʿilma l-yaqīn"),
            QuranVerse(id: 6, arabic: "لَتَرَوُنَّ الْجَحِيمَ", french: "Vous verrez assurément la Fournaise.", phonetic: "La-tarawunna l-jaḥīm"),
            QuranVerse(id: 7, arabic: "ثُمَّ لَتَرَوُنَّهَا عَيْنَ الْيَقِينِ", french: "Puis vous la verrez avec une vision certaine.", phonetic: "Ṯumma la-tarawunnahā ʿayna l-yaqīn"),
            QuranVerse(id: 8, arabic: "ثُمَّ لَتُسْأَلُنَّ يَوْمَئِذٍ عَنِ النَّعِيمِ", french: "Puis, ce jour-là, vous serez certainement interrogés sur les délices.", phonetic: "Ṯumma la-tusʾalunna yawmaʾiḏin ʿani n-naʿīm"),
        ],
        103: [
            QuranVerse(id: 1, arabic: "وَالْعَصْرِ", french: "Par le Temps !", phonetic: "Wa-l-ʿaṣr"),
            QuranVerse(id: 2, arabic: "إِنَّ الْإِنسَانَ لَفِي خُسْرٍ", french: "L'homme est certes en perdition,", phonetic: "Inna l-insāna la-fī ḫusr"),
            QuranVerse(id: 3, arabic: "إِلَّا الَّذِينَ آمَنُوا وَعَمِلُوا الصَّالِحَاتِ وَتَوَاصَوْا بِالْحَقِّ وَتَوَاصَوْا بِالصَّبْرِ", french: "sauf ceux qui ont cru, accompli de bonnes œuvres, et mutuellement recommandé la vérité et mutuellement recommandé l'endurance.", phonetic: "Illā llaḏīna āmanū wa-ʿamilū ṣ-ṣāliḥāti wa-tawāṣaw bi-l-ḥaqqi wa-tawāṣaw bi-ṣ-ṣabr"),
        ],
        104: [
            QuranVerse(id: 1, arabic: "وَيْلٌ لِّكُلِّ هُمَزَةٍ لُّمَزَةٍ", french: "Malheur à tout calomniateur, diffamateur !", phonetic: "Waylun li-kulli humazatin lumazatin"),
            QuranVerse(id: 2, arabic: "الَّذِي جَمَعَ مَالًا وَعَدَّدَهُ", french: "qui amasse des richesses et les compte,", phonetic: "Allaḏī jamaʿa mālan wa-ʿaddadah"),
            QuranVerse(id: 3, arabic: "يَحْسَبُ أَنَّ مَالَهُ أَخْلَدَهُ", french: "croyant que ses richesses le feront durer.", phonetic: "Yaḥsabu anna mālahu aḫladah"),
        ],
        105: [
            QuranVerse(id: 1, arabic: "أَلَمْ تَرَ كَيْفَ فَعَلَ رَبُّكَ بِأَصْحَابِ الْفِيلِ", french: "N'as-tu pas vu comment ton Seigneur a agi envers les gens de l'Éléphant ?", phonetic: "Alam tara kayfa faʿala rabbuka bi-aṣḥābi l-fīl"),
            QuranVerse(id: 2, arabic: "أَلَمْ يَجْعَلْ كَيْدَهُمْ فِي تَضْلِيلٍ", french: "N'a-t-Il pas réduit leur stratagème à néant ?", phonetic: "Alam yajʿal kaydahum fī taḍlīl"),
            QuranVerse(id: 3, arabic: "وَأَرْسَلَ عَلَيْهِمْ طَيْرًا أَبَابِيلَ", french: "Il lança contre eux des oiseaux en bandes,", phonetic: "Wa-arsala ʿalayhim ṭayran abābīl"),
            QuranVerse(id: 4, arabic: "تَرْمِيهِم بِحِجَارَةٍ مِّن سِجِّيلٍ", french: "qui leur lançaient des pierres d'argile cuite,", phonetic: "Tarmīhim bi-ḥijāratin min sijjīl"),
            QuranVerse(id: 5, arabic: "فَجَعَلَهُمْ كَعَصْفٍ مَّأْكُولٍ", french: "et Il les rendit pareils à une paille mâchée.", phonetic: "Fa-jaʿalahum ka-ʿaṣfin maʾkūl"),
        ],
        106: [
            QuranVerse(id: 1, arabic: "لِإِيلَافِ قُرَيْشٍ", french: "Pour la sécurité des Quraych,", phonetic: "Li-ʾīlāfi qurayš"),
            QuranVerse(id: 2, arabic: "إِيلَافِهِمْ رِحْلَةَ الشِّتَاءِ وَالصَّيْفِ", french: "leur sécurité lors du voyage d'hiver et d'été,", phonetic: "Īlāfihim riḥlata š-šitāʾi wa-ṣ-ṣayf"),
            QuranVerse(id: 3, arabic: "فَلْيَعْبُدُوا رَبَّ هَٰذَا الْبَيْتِ", french: "qu'ils adorent donc le Seigneur de cette Maison,", phonetic: "Fa-l-yaʿbudū rabba hāḏā l-bayt"),
            QuranVerse(id: 4, arabic: "الَّذِي أَطْعَمَهُم مِّن جُوعٍ وَآمَنَهُم مِّنْ خَوْفٍ", french: "qui les a nourris contre la faim et rassurés contre la crainte.", phonetic: "Allaḏī aṭʿamahum min jūʿin wa-āmanahum min ḫawf"),
        ],
        107: [
            QuranVerse(id: 1, arabic: "أَرَأَيْتَ الَّذِي يُكَذِّبُ بِالدِّينِ", french: "As-tu vu celui qui traite de mensonge la Religion ?", phonetic: "A-raʾayta llaḏī yukaḏḏibu bi-d-dīn"),
            QuranVerse(id: 2, arabic: "فَذَٰلِكَ الَّذِي يَدُعُّ الْيَتِيمَ", french: "C'est lui qui repousse l'orphelin,", phonetic: "Fa-ḏālika llaḏī yaduʿʿu l-yatīm"),
            QuranVerse(id: 3, arabic: "وَلَا يَحُضُّ عَلَىٰ طَعَامِ الْمِسْكِينِ", french: "et qui n'encourage pas à nourrir le pauvre.", phonetic: "Wa-lā yaḥuḍḍu ʿalā ṭaʿāmi l-miskīn"),
            QuranVerse(id: 4, arabic: "فَوَيْلٌ لِّلْمُصَلِّينَ", french: "Malheur donc à ceux qui prient,", phonetic: "Fa-waylun li-l-muṣallīn"),
            QuranVerse(id: 5, arabic: "الَّذِينَ هُمْ عَن صَلَاتِهِمْ سَاهُونَ", french: "mais sont distraits dans leur prière,", phonetic: "Allaḏīna hum ʿan ṣalātihim sāhūn"),
            QuranVerse(id: 6, arabic: "الَّذِينَ هُمْ يُرَاءُونَ", french: "qui font leurs actes par ostentation,", phonetic: "Allaḏīna hum yurāʾūn"),
            QuranVerse(id: 7, arabic: "وَيَمْنَعُونَ الْمَاعُونَ", french: "et refusent l'aide nécessaire.", phonetic: "Wa-yamnaʿūna l-māʿūn"),
        ],
        108: [
            QuranVerse(id: 1, arabic: "إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ", french: "Nous t'avons accordé l'Abondance.", phonetic: "Innā aʿṭaynāka l-kawṯar"),
            QuranVerse(id: 2, arabic: "فَصَلِّ لِرَبِّكَ وَانْحَرْ", french: "Accomplis donc la prière pour ton Seigneur et sacrifie.", phonetic: "Fa-ṣalli li-rabbika wa-nḥar"),
            QuranVerse(id: 3, arabic: "إِنَّ شَانِئَكَ هُوَ الْأَبْتَرُ", french: "C'est bien ton ennemi qui est sans postérité.", phonetic: "Inna šāniʾaka huwa l-abtar"),
        ],
        109: [
            QuranVerse(id: 1, arabic: "قُلْ يَا أَيُّهَا الْكَافِرُونَ", french: "Dis : Ô vous les infidèles !", phonetic: "Qul yā ayyuhā l-kāfirūn"),
            QuranVerse(id: 2, arabic: "لَا أَعْبُدُ مَا تَعْبُدُونَ", french: "Je n'adore pas ce que vous adorez.", phonetic: "Lā aʿbudu mā taʿbudūn"),
            QuranVerse(id: 3, arabic: "وَلَا أَنتُمْ عَابِدُونَ مَا أَعْبُدُ", french: "Et vous n'adorez pas ce que j'adore.", phonetic: "Wa-lā antum ʿābidūna mā aʿbud"),
            QuranVerse(id: 4, arabic: "وَلَا أَنَا عَابِدٌ مَّا عَبَدتُّمْ", french: "Je n'adore pas ce que vous adorez.", phonetic: "Wa-lā anā ʿābidun mā ʿabadtum"),
            QuranVerse(id: 5, arabic: "وَلَا أَنتُمْ عَابِدُونَ مَا أَعْبُدُ", french: "Et vous n'adorez pas ce que j'adore.", phonetic: "Wa-lā antum ʿābidūna mā aʿbud"),
            QuranVerse(id: 6, arabic: "لَكُمْ دِينُكُمْ وَلِيَ دِينِ", french: "À vous votre religion, et à moi la mienne.", phonetic: "Lakum dīnukum wa-liya dīn"),
        ],
        110: [
            QuranVerse(id: 1, arabic: "إِذَا جَاءَ نَصْرُ اللَّهِ وَالْفَتْحُ", french: "Quand vient le secours d'Allah et la victoire,", phonetic: "Iḏā jāʾa naṣru llāhi wa-l-fatḥ"),
            QuranVerse(id: 2, arabic: "وَرَأَيْتَ النَّاسَ يَدْخُلُونَ فِي دِينِ اللَّهِ أَفْوَاجًا", french: "que tu vois les gens entrer en foule dans la religion d'Allah,", phonetic: "Wa-raʾayta n-nāsa yadḫulūna fī dīni llāhi afwājā"),
            QuranVerse(id: 3, arabic: "فَسَبِّحْ بِحَمْدِ رَبِّكَ وَاسْتَغْفِرْهُ إِنَّهُ كَانَ تَوَّابًا", french: "alors célèbre les louanges de ton Seigneur et implore Son pardon. Certes, Il est Grand Accueillant au repentir.", phonetic: "Fa-sabbiḥ bi-ḥamdi rabbika wa-staġfirhu innahu kāna tawwābā"),
        ],
        111: [
            QuranVerse(id: 1, arabic: "تَبَّتْ يَدَا أَبِي لَهَبٍ وَتَبَّ", french: "Que périssent les deux mains d'Abû Lahab ! Et il périt, lui aussi.", phonetic: "Tabbat yadā abī lahabin wa-tabb"),
            QuranVerse(id: 2, arabic: "مَا أَغْنَىٰ عَنْهُ مَالُهُ وَمَا كَسَبَ", french: "Sa richesse et ce qu'il a acquis ne lui ont servi à rien.", phonetic: "Mā aġnā ʿanhu māluhu wa-mā kasab"),
            QuranVerse(id: 3, arabic: "سَيَصْلَىٰ نَارًا ذَاتَ لَهَبٍ", french: "Il sera brûlé dans un feu plein de flammes,", phonetic: "Sa-yaṣlā nāran ḏāta lahab"),
            QuranVerse(id: 4, arabic: "وَامْرَأَتُهُ حَمَّالَةَ الْحَطَبِ", french: "ainsi que sa femme, la porteuse de bois,", phonetic: "Wa-mraʾatuhu ḥammālata l-ḥaṭab"),
            QuranVerse(id: 5, arabic: "فِي جِيدِهَا حَبْلٌ مِّن مَّسَدٍ", french: "à son cou, une corde de fibres.", phonetic: "Fī jīdihā ḥablun min masad"),
        ],
        112: [
            QuranVerse(id: 1, arabic: "قُلْ هُوَ اللَّهُ أَحَدٌ", french: "Dis : Il est Allah, l'Unique.", phonetic: "Qul huwa llāhu aḥad"),
            QuranVerse(id: 2, arabic: "اللَّهُ الصَّمَدُ", french: "Allah, le Seul à être imploré pour ce que nous désirons.", phonetic: "Allāhu ṣ-ṣamad"),
            QuranVerse(id: 3, arabic: "لَمْ يَلِدْ وَلَمْ يُولَدْ", french: "Il n'a pas engendré, n'a pas été engendré,", phonetic: "Lam yalid wa-lam yūlad"),
            QuranVerse(id: 4, arabic: "وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ", french: "et nul n'est égal à Lui.", phonetic: "Wa-lam yakun lahu kufuwan aḥad"),
        ],
        113: [
            QuranVerse(id: 1, arabic: "قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ", french: "Dis : Je cherche protection auprès du Seigneur de l'Aube naissante,", phonetic: "Qul aʿūḏu bi-rabbi l-falaq"),
            QuranVerse(id: 2, arabic: "مِن شَرِّ مَا خَلَقَ", french: "contre le mal de ce qu'Il a créé,", phonetic: "Min šarri mā ḫalaq"),
            QuranVerse(id: 3, arabic: "وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ", french: "contre le mal de l'obscurité quand elle s'étend,", phonetic: "Wa-min šarri ġāsiqin iḏā waqab"),
            QuranVerse(id: 4, arabic: "وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ", french: "contre le mal de celles qui soufflent sur les nœuds,", phonetic: "Wa-min šarri n-naffāṯāti fī l-ʿuqad"),
            QuranVerse(id: 5, arabic: "وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ", french: "et contre le mal de l'envieux quand il envie.", phonetic: "Wa-min šarri ḥāsidin iḏā ḥasad"),
        ],
        114: [
            QuranVerse(id: 1, arabic: "قُلْ أَعُوذُ بِرَبِّ النَّاسِ", french: "Dis : Je cherche protection auprès du Seigneur des hommes,", phonetic: "Qul aʿūḏu bi-rabbi n-nās"),
            QuranVerse(id: 2, arabic: "مَلِكِ النَّاسِ", french: "du Roi des hommes,", phonetic: "Maliki n-nās"),
            QuranVerse(id: 3, arabic: "إِلَٰهِ النَّاسِ", french: "du Dieu des hommes,", phonetic: "Ilāhi n-nās"),
            QuranVerse(id: 4, arabic: "مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ", french: "contre le mal du mauvais chuchoteur qui se dérobe,", phonetic: "Min šarri l-waswāsi l-ḫannās"),
            QuranVerse(id: 5, arabic: "الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ", french: "qui souffle le mal dans les poitrines des hommes,", phonetic: "Allaḏī yuwaswisu fī ṣudūri n-nās"),
            QuranVerse(id: 6, arabic: "مِنَ الْجِنَّةِ وَالنَّاسِ", french: "qu'il soit djinn ou être humain.", phonetic: "Mina l-jinnati wa-n-nās"),
        ],
    ]
}