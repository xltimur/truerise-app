// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get commonContinue => 'Continuer';

  @override
  String get commonNext => 'Suivant';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get onboardingSkip => 'Passer';

  @override
  String get onboardingSlide1Title =>
      'Votre thème natal dépend de votre heure de naissance exacte.';

  @override
  String onboardingSlide1Body(String brand) {
    return 'La plupart des gens ne connaissent qu\'une heure approximative, ou rien du tout. $brand la précise à partir des événements de votre vie.';
  }

  @override
  String onboardingSlide2Title(String brand) {
    return 'Comment fonctionne $brand';
  }

  @override
  String get onboardingSlide2Body =>
      '1. Saisissez votre date et votre heure de naissance approximative.\n2. Ajoutez les événements dont vous vous souvenez : déménagements, relations, changements professionnels, etc.\n3. Nous calculons l\'heure de naissance la plus probable et vous expliquons pourquoi.\n\nPlus vous ajoutez d\'événements, plus le résultat peut devenir clair.';

  @override
  String get onboardingSlide3Title =>
      'Prêt à trouver votre heure de naissance ?';

  @override
  String get onboardingSlide3Body =>
      'Une démo vous montre d\'abord un exemple de résultat, sans aucun compte.';

  @override
  String get onboardingTryDemo => 'Essayer la démo d\'abord';

  @override
  String get onboardingStartReal => 'Lancer un calcul réel';

  @override
  String onboardingPageLabel(int page, int count) {
    return 'Page $page sur $count';
  }

  @override
  String get birthDataTitle => 'Détails de naissance';

  @override
  String get birthDataDateLabel => 'Date de naissance';

  @override
  String get birthDataDatePlaceholder => 'Sélectionner une date';

  @override
  String get birthDataCityLabel => 'Ville de naissance';

  @override
  String get birthDataCityHint => 'Commencez à saisir une ville';

  @override
  String get birthDataLabelLabel => 'Libellé (facultatif)';

  @override
  String get birthDataLabelHelper => 'Affiché dans votre historique.';

  @override
  String get birthDataLabelHint => 'ex. Mon heure de naissance';

  @override
  String get birthDataSearching => 'Recherche…';

  @override
  String get birthDataNoMatches =>
      'Ville introuvable. Essayez une autre orthographe.';

  @override
  String get timeWindowTitle =>
      'Connaissez-vous une heure de naissance approximative ?';

  @override
  String get timeWindowModeApprox => 'J\'ai une heure approximative';

  @override
  String get timeWindowModeUnknown => 'Je n\'en ai aucune idée';

  @override
  String get timeWindowApproxTimeLabel => 'Heure approximative';

  @override
  String get timeWindowChooseTime => 'Choisir l\'heure';

  @override
  String get timeWindowTimePickerHelp => 'Heure de naissance approximative';

  @override
  String get timeWindowSearchWindow => 'Fenêtre de recherche';

  @override
  String timeWindowDeltaMinutes(int minutes) {
    return '± $minutes min';
  }

  @override
  String timeWindowDeltaHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '± $hours heures',
      one: '± 1 heure',
    );
    return '$_temp0';
  }

  @override
  String timeWindowRangeCopy(String start, String end) {
    return 'Nous chercherons entre $start et $end.';
  }

  @override
  String get timeWindowApproxHint =>
      'Une fenêtre plus large donne plus de candidats mais peut réduire la précision.';

  @override
  String get timeWindowUnknownBody =>
      'Nous chercherons sur toute la plage de 24 heures. Cela peut produire plus de candidats avec un niveau de confiance plus faible.';

  @override
  String get timeWindowUnknownHint =>
      'Ajouter plus d\'événements de vie aidera à affiner le résultat.';

  @override
  String get lifeEventsTitle => 'Événements de vie';

  @override
  String lifeEventsTitleWithCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Événements de vie  ($count ajoutés)',
      one: 'Événements de vie  (1 ajouté)',
    );
    return '$_temp0';
  }

  @override
  String get lifeEventsAddEvent => 'Ajouter un événement';

  @override
  String get lifeEventsAddFirstEvent => 'Ajouter le premier événement';

  @override
  String get lifeEventsContinueDemo => 'Continuer (démo)';

  @override
  String get lifeEventsEmptyBody =>
      'Ajoutez des événements marquants de votre vie. Plus vous en ajoutez, mieux c\'est.';

  @override
  String get lifeEventsGuidanceEmpty =>
      'Ajoutez au moins 5 événements pour un calcul réel. 3 pour une démo.';

  @override
  String get lifeEventsNoEvents => 'Aucun événement pour l\'instant.';

  @override
  String lifeEventsGuidanceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count événements. Ajoutez-en 5 ou plus pour un calcul réel plus solide.',
      one: '1 événement. Ajoutez-en 5 ou plus pour un calcul réel plus solide.',
    );
    return '$_temp0';
  }

  @override
  String get eventCategoryMarriage => 'Mariage / Partenariat';

  @override
  String get eventCategoryDivorce => 'Divorce / Séparation';

  @override
  String get eventCategoryCareerChange => 'Changement de carrière';

  @override
  String get eventCategoryJobLoss => 'Perte d\'emploi';

  @override
  String get eventCategoryRelocation => 'Déménagement (majeur)';

  @override
  String get eventCategoryChildBirth => 'Naissance d\'un enfant';

  @override
  String get eventCategoryFamilyDeath => 'Décès d\'un proche';

  @override
  String get eventCategoryIllness => 'Maladie / opération majeure';

  @override
  String get eventCategoryAccident => 'Accident ou blessure';

  @override
  String get eventCategoryEducation => 'Étape scolaire';

  @override
  String get eventCategoryFinancial => 'Tournant financier';

  @override
  String get eventCategoryOther => 'Autre';

  @override
  String get confirmationTitle => 'Confirmez votre calcul';

  @override
  String get confirmationBackToEdit => 'Revenir à la modification';

  @override
  String get confirmationCalculate => 'Calculer';

  @override
  String get confirmationCalculateDemo => 'Calculer (démo)';

  @override
  String get confirmationDatePending => 'Date en attente';

  @override
  String get confirmationRowDate => 'Date';

  @override
  String get confirmationRowCity => 'Ville';

  @override
  String get confirmationRowLabel => 'Libellé';

  @override
  String get confirmationTimeWindow => 'Fenêtre temporelle';

  @override
  String get confirmationFullDayWindow => 'Fenêtre de 24 heures complète';

  @override
  String confirmationWindowApprox(String time, String window) {
    return '$time ($window)';
  }

  @override
  String confirmationLifeEventsCount(int count) {
    return 'Événements de vie ($count)';
  }

  @override
  String get confirmationDemoNote =>
      'Mode démo : nous afficherons un exemple de résultat sans requête réseau.';

  @override
  String get loadingTitle => 'Calcul de votre heure de naissance probable…';

  @override
  String get loadingDemoTitle => 'Exécution du calcul de démonstration…';

  @override
  String get loadingRotating1 => 'Analyse des événements de vie…';

  @override
  String get loadingRotating2 => 'Cartographie des transits planétaires…';

  @override
  String get loadingRotating3 => 'Classement des candidats…';

  @override
  String get loadingTakesUnder =>
      'Cela prend généralement moins de 10 secondes.';

  @override
  String get addEventAddTitle => 'Ajouter un événement de vie';

  @override
  String get addEventEditTitle => 'Modifier l\'événement de vie';

  @override
  String get addEventSelectCategory => 'Sélectionner une catégorie';

  @override
  String get addEventCategoryLabel => 'Catégorie';

  @override
  String get addEventChooseCategory => 'Choisir une catégorie';

  @override
  String get addEventMonth => 'Mois';

  @override
  String get addEventNoMonth => 'Aucun mois';

  @override
  String get addEventYear => 'Année';

  @override
  String get addEventMonthOptional => 'Le mois est facultatif.';

  @override
  String get addEventDescriptionLabel => 'Description (facultative)';

  @override
  String get addEventDescriptionHint =>
      'Tout ce qui aide à préciser la datation';

  @override
  String addEventCharCount(int current, int max) {
    return '$current / $max';
  }

  @override
  String get addEventSaveChanges => 'Enregistrer les modifications';

  @override
  String get commonBackToHistory => 'Retour à l\'historique';

  @override
  String get commonDismiss => 'Fermer';

  @override
  String get resultTitle => 'Résultat';

  @override
  String get resultNotFoundTitle => 'Nous n\'avons pas trouvé ce résultat.';

  @override
  String get resultNotFoundBody =>
      'Il a peut-être été supprimé de votre historique. Ouvrez un calcul enregistré ou démarrez-en un nouveau.';

  @override
  String resultRisingSign(String sign) {
    return 'Ascendant $sign';
  }

  @override
  String get resultSampleData => '(données d\'exemple)';

  @override
  String get resultLowConfidenceTitle => 'Résultat à faible confiance';

  @override
  String get resultLowConfidenceTipEvents =>
      'Ajoutez plus d\'événements de vie datés.';

  @override
  String get resultLowConfidenceTipReviewInput =>
      'Vérifiez votre date de naissance, votre ville et l\'heure approximative.';

  @override
  String get resultLowConfidenceTipWiderWindow =>
      'Essayez une fenêtre d\'heure de naissance plus large.';

  @override
  String get resultConfidenceExplainerTitle => 'Que signifie ce pourcentage ?';

  @override
  String get resultConfidenceExplainerBody =>
      'La confiance est une estimation. Elle indique à quel point vos événements de vie datés soutiennent cette heure candidate par rapport aux autres heures candidates de la fenêtre de naissance sélectionnée.';

  @override
  String get resultConfidenceExplainerMethod =>
      'Méthode : chaque heure candidate est évaluée à partir de vos événements au moyen des transits et des progressions ; un score plus élevé indique une correspondance plus probable.';

  @override
  String get resultOtherCandidates => 'Autres candidats';

  @override
  String get resultSeeEvidence => 'Voir comment nous y sommes parvenus';

  @override
  String get resultShare => 'Partager le résultat';

  @override
  String get resultCopiedToClipboard => 'Copié dans le presse-papiers';

  @override
  String get resultShareImage => 'Partager l\'image';

  @override
  String get resultShareImageUnavailable =>
      'Impossible d\'ouvrir le menu de partage pour l\'image.';

  @override
  String get resultDemoShareLabel => 'Partager cet exemple';

  @override
  String get resultDemoShareTitle => 'Cet exemple vous plaît ? Partagez-le.';

  @override
  String get resultDemoShareButton => 'Partager l\'exemple';

  @override
  String get resultFeedbackLabel => 'Retour sur le résultat';

  @override
  String get resultFeedbackTitle =>
      'Cette heure vous semble-t-elle plausible ?';

  @override
  String get resultFeedbackYes => 'Oui';

  @override
  String get resultFeedbackNotSure => 'Pas sûr';

  @override
  String get resultFeedbackNo => 'Non';

  @override
  String get resultFeedbackSaved => 'Merci, enregistré.';

  @override
  String get shareCardTagline => 'Rectification de l\'heure de naissance';

  @override
  String shareCardConfidence(int percent) {
    return '$percent% de confiance';
  }

  @override
  String shareCopyHeadline(String brand) {
    return 'Mon résultat d\'heure de naissance avec $brand :';
  }

  @override
  String shareCopyTagline(String brand) {
    return 'Calculé avec $brand : rectification de l\'heure de naissance';
  }

  @override
  String shareCopyGetApp(String url) {
    return 'Trouvez votre heure de naissance : $url';
  }

  @override
  String inviteCopyHeadline(String brand) {
    return 'Essayez $brand : estimez votre heure de naissance';
  }

  @override
  String get inviteCopyBody =>
      'Elle estime une heure de naissance probable à partir de quelques événements de votre vie dont vous vous souvenez.';

  @override
  String inviteCopyGetApp(String url) {
    return 'Téléchargez l\'appli : $url';
  }

  @override
  String get resultSaveToHistory => 'Enregistrer dans l\'historique';

  @override
  String get resultSaved => 'Enregistré ✓';

  @override
  String get resultDemoNudgeLabel => 'Invitation à passer de la démo';

  @override
  String get resultDemoNudgeTitle => 'C\'était une démo.';

  @override
  String get resultDemoNudgeBody =>
      'Lancez un calcul réel avec vos propres données de naissance.';

  @override
  String get resultStartNewCalculation => 'Démarrer un nouveau calcul';

  @override
  String reviewPromptTitle(String brand) {
    return 'Évaluer $brand ?';
  }

  @override
  String reviewPromptBody(String brand) {
    return 'Si $brand vous a été utile, un avis honnête aide d\'autres personnes à décider de l\'essayer. Cela ne prend qu\'un instant et c\'est entièrement facultatif.';
  }

  @override
  String get reviewPromptConfirm => 'Laisser un avis';

  @override
  String get reviewPromptDismiss => 'Pas maintenant';

  @override
  String get updateAvailableTitle => 'Mise à jour disponible';

  @override
  String updateAvailableBody(String brand) {
    return 'Une nouvelle version de $brand est prête à être installée.';
  }

  @override
  String get updateRequiredTitle => 'Mise à jour requise';

  @override
  String updateRequiredBody(String brand) {
    return 'Cette version de $brand n\'est plus à jour. Mettez-la à jour pour continuer.';
  }

  @override
  String get updateAction => 'Mettre à jour';

  @override
  String get updateNotNow => 'Pas maintenant';

  @override
  String get updateOpenStoreFailed =>
      'Impossible d\'ouvrir la page de la boutique.';

  @override
  String get evidenceTitle => 'Indices';

  @override
  String get evidenceNotFoundTitle => 'Nous n\'avons pas trouvé ces indices.';

  @override
  String get evidenceNotFoundBody =>
      'Le résultat associé a peut-être été supprimé. Revenez à votre historique pour choisir un autre calcul.';

  @override
  String evidenceWhyTitle(String time) {
    return 'Pourquoi $time ?';
  }

  @override
  String get evidenceNoEvidence =>
      'Nous n\'avons pas d\'indices au niveau des événements pour ce résultat.';

  @override
  String evidenceStrongSummary(int strong, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$strong événements sur $total ont fortement appuyé cette heure.',
      one: '$strong événement sur 1 a fortement appuyé cette heure.',
    );
    return '$_temp0';
  }

  @override
  String get evidenceEventFallback => 'Événement';

  @override
  String get heroResultEyebrow => 'VOTRE HEURE DE NAISSANCE LA PLUS PROBABLE';

  @override
  String heroResultSemantic(String eyebrow, String time, String risingSign) {
    return '$eyebrow : $time, $risingSign';
  }

  @override
  String get confidenceBarLabel => 'Niveau de confiance';

  @override
  String confidenceBarSemantic(String label, int percent) {
    return '$label : $percent pour cent';
  }

  @override
  String get matchStrengthStrong => 'FORT';

  @override
  String get matchStrengthModerate => 'MODÉRÉ';

  @override
  String get matchStrengthWeak => 'FAIBLE';

  @override
  String get matchStrengthNone => 'AUCUNE CORRESPONDANCE';

  @override
  String matchStrengthSemantic(String strength) {
    String _temp0 = intl.Intl.selectLogic(
      strength,
      {
        'strong': 'Correspondance forte',
        'moderate': 'Correspondance modérée',
        'weak': 'Correspondance faible',
        'none': 'Aucune correspondance',
        'other': 'Correspondance',
      },
    );
    return '$_temp0';
  }

  @override
  String candidateCardSemantic(String time, String risingSign, int percent) {
    return 'Candidat $time, $risingSign, niveau de confiance $percent pour cent';
  }

  @override
  String historyCardSemantic(
    String isDemo,
    String label,
    String date,
    String time,
    String risingSign,
    int percent,
  ) {
    String _temp0 = intl.Intl.selectLogic(
      isDemo,
      {
        'true':
            '$label, $date, $time $risingSign, niveau de confiance $percent pour cent, démo',
        'other':
            '$label, $date, $time $risingSign, niveau de confiance $percent pour cent',
      },
    );
    return '$_temp0';
  }

  @override
  String evidenceCardSemantic(String category, String date, String strength) {
    String _temp0 = intl.Intl.selectLogic(
      strength,
      {
        'strong': 'correspondance forte',
        'moderate': 'correspondance modérée',
        'weak': 'correspondance faible',
        'none': 'aucune correspondance',
        'other': 'correspondance',
      },
    );
    return '$category, $date, $_temp0';
  }

  @override
  String get demoPillLabel => 'DEMO';

  @override
  String demoPillSemantic(String label) {
    return 'Badge de calcul $label';
  }

  @override
  String eventCardSemantic(String category, String date) {
    return 'Événement : $category le $date';
  }

  @override
  String eventCardDeleteSemantic(String category) {
    return 'Supprimer l\'événement $category';
  }

  @override
  String get commonBack => 'Retour';

  @override
  String get commonDelete => 'Supprimer';

  @override
  String get commonNotSet => 'non défini';

  @override
  String fieldValueSemantic(String label, String value) {
    return '$label, $value';
  }

  @override
  String get navNew => 'NOUVEAU';

  @override
  String get navHistory => 'HISTORIQUE';

  @override
  String get navSettings => 'RÉGLAGES';

  @override
  String stepperStep(int current, int total) {
    return 'ÉTAPE $current SUR $total';
  }

  @override
  String stepperPercent(int percent) {
    return '$percent pour cent';
  }

  @override
  String get calcFlowTitle => 'Nouveau calcul';

  @override
  String get homeSettingsButton => 'Réglages';

  @override
  String homeHistoryLoadError(String error) {
    return 'Nous n\'avons pas pu charger votre historique.\n$error';
  }

  @override
  String get homeEmptyTitle => 'Aucun calcul pour l\'instant.';

  @override
  String get homeEmptyBody =>
      'Lancez votre premier calcul pour voir les résultats ici.';

  @override
  String get homeNewCalculation => 'Nouveau calcul';

  @override
  String get homePastCalculations => 'Calculs précédents';

  @override
  String get homeDefaultLabel => 'Mon calcul';

  @override
  String get historyDeleteTitle => 'Supprimer ce calcul ?';

  @override
  String historyDeleteBody(String label) {
    return 'Cela retire « $label » de votre historique. Les données d\'origine ne sont conservées nulle part ailleurs.';
  }

  @override
  String historyDeletedSnack(String label) {
    return '« $label » supprimé.';
  }

  @override
  String get historyDeleteFailedSnack =>
      'Impossible de supprimer cette entrée.';

  @override
  String get errorTryAgain => 'Réessayer';

  @override
  String get errorReviewDraft => 'Vérifier mon brouillon';

  @override
  String get errorTimeoutTitle => 'Délai de calcul dépassé';

  @override
  String get errorTimeoutBody =>
      'Le calcul ne s\'est pas terminé à temps. Le Wi-Fi public peut être lent. Réessayez dans un instant.';

  @override
  String get errorNoInternetTitle => 'Impossible d\'atteindre le réseau';

  @override
  String get errorNoInternetBody =>
      'Vous êtes hors ligne, ou votre réseau bloque la requête. Reconnectez-vous et réessayez.';

  @override
  String get errorBadRequestTitle =>
      'Quelque chose semblait incorrect dans les données';

  @override
  String get errorBadRequestBody =>
      'Un élément de votre date de naissance, de votre fenêtre temporelle ou de vos événements n\'a pas pu être traité. Vérifiez-les, puis réessayez.';

  @override
  String get errorUnauthorizedTitle => 'Impossible de terminer le calcul';

  @override
  String get errorUnauthorizedBody =>
      'Nous n\'avons pas pu terminer ce calcul pour le moment. Réessayez dans un instant, ou activez le mode démo pour continuer à explorer avec des données d\'exemple.';

  @override
  String get errorMissingApiKeyTitle => 'Impossible de démarrer le calcul';

  @override
  String get errorMissingApiKeyBody =>
      'Nous n\'avons pas pu démarrer un calcul en direct pour le moment. Réessayez dans un instant, ou activez le mode démo pour essayer l\'application avec des données d\'exemple.';

  @override
  String get errorServerTitle => 'Une erreur s\'est produite';

  @override
  String get errorServerBody =>
      'Le calcul n\'a pas pu être terminé à l\'instant. Il s\'agit peut-être d\'un problème temporaire. Réessayez sous peu.';

  @override
  String get errorRateLimitedTitle => 'Limite de calculs atteinte';

  @override
  String get errorRateLimitedBody =>
      'Vous avez atteint la limite de calculs pour le moment. Patientez un instant et réessayez, ou activez le mode démo pour continuer à explorer hors ligne.';

  @override
  String get errorRateLimitedUseDemo => 'Utiliser le mode démo';

  @override
  String get errorRateLimitedEnterKey => 'Saisir ma clé API';

  @override
  String errorRateLimitedLocalQuotaBody(String resetDetail) {
    return 'Votre quota gratuit de calculs en direct est épuisé.$resetDetail Passez en mode démo pour continuer à explorer, ou ajoutez votre propre clé API dans les Réglages.';
  }

  @override
  String errorRateLimitedResetAt(String resetTime) {
    return 'Réinitialisation le $resetTime UTC.';
  }

  @override
  String errorRateLimitedRetryAfter(String duration) {
    return 'Vous pourrez réessayer dans environ $duration.';
  }

  @override
  String errorRateLimitedRetryMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes',
      one: '1 minute',
    );
    return '$_temp0';
  }

  @override
  String errorRateLimitedRetryHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count heures',
      one: '1 heure',
    );
    return '$_temp0';
  }

  @override
  String get errorMalformedTitle => 'Impossible de lire la réponse';

  @override
  String get errorMalformedBody =>
      'La réponse ne correspond pas à ce que cette version attend. Réessayez, ou lancez un calcul de démonstration pendant que nous examinons le problème.';

  @override
  String get settingsTitle => 'Réglages';

  @override
  String get settingsSectionDefaults => 'Paramètres de calcul par défaut';

  @override
  String get settingsSectionTimeFormat => 'Format de l\'heure';

  @override
  String get settingsSectionApiKey => 'Clé API';

  @override
  String get settingsSectionData => 'Données';

  @override
  String get settingsSectionAbout => 'À propos';

  @override
  String get settingsDemoModeLabel => 'Mode démo';

  @override
  String get settingsDemoModeHelper =>
      'Lancez des calculs avec des données d\'exemple (gratuit, sans réseau).';

  @override
  String get settingsTimeFormat12 => '12 heures  (7:14 AM)';

  @override
  String get settingsTimeFormat24 => '24 heures  (07:14)';

  @override
  String get settingsSectionLanguage => 'Langue';

  @override
  String get settingsLanguageAuto => 'Automatique (langue de l\'appareil)';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageGerman => 'Deutsch';

  @override
  String get settingsLanguageSpanish => 'Español';

  @override
  String get settingsLanguageFrench => 'Français';

  @override
  String get settingsLanguagePortuguese => 'Português';

  @override
  String get settingsLanguageUkrainian => 'Українська';

  @override
  String get settingsApiKeyHelper =>
      'Vous avez déjà une clé Astrology API ? Ajoutez-la ici.';

  @override
  String get settingsApiKeyGetLink => 'Obtenez une clé sur';

  @override
  String get settingsApiKeyConfigured => 'Clé API ajoutée';

  @override
  String get settingsApiKeyAdd => 'Ajouter une clé';

  @override
  String get settingsApiKeyRemove => 'Supprimer la clé';

  @override
  String get settingsApiKeyFieldLabel => 'Clé Astrology API';

  @override
  String get settingsApiKeySave => 'Enregistrer la clé';

  @override
  String get settingsDeleteAllData => 'Supprimer toutes les données';

  @override
  String get settingsDeleteAllHelper =>
      'Retire tous les calculs et événements de cet appareil. Action irréversible.';

  @override
  String get settingsPrivacyPolicy => 'Politique de confidentialité';

  @override
  String get settingsInviteFriend => 'Inviter un ami';

  @override
  String get deleteAllTitle => 'Supprimer toutes les données ?';

  @override
  String get deleteAllBodyGeneric =>
      'Cela supprimera définitivement chaque calcul, événement et réglage de cet appareil. Action irréversible.';

  @override
  String deleteAllBodyCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Cela supprimera définitivement $count calculs ainsi que chaque événement et réglage enregistré sur cet appareil. Action irréversible.',
      one:
          'Cela supprimera définitivement 1 calcul ainsi que chaque événement et réglage enregistré sur cet appareil. Action irréversible.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAllFailedSnack =>
      'Impossible de supprimer les données. Réessayez.';

  @override
  String get privacyTitle => 'Confidentialité';

  @override
  String privacyStoresTitle(String brand) {
    return 'Ce que $brand stocke';
  }

  @override
  String privacyStoresBody(String brand) {
    return 'Votre date de naissance, votre ville de naissance, vos événements de vie et vos résultats restent sur cet appareil. Rien n\'est téléversé vers un compte $brand, car nous ne gérons pas de comptes utilisateur. Supprimer l\'application efface ces données.';
  }

  @override
  String get privacyDemoTitle => 'Mode démo';

  @override
  String get privacyDemoBody =>
      'Les calculs de démonstration s\'exécutent entièrement sur cet appareil. Aucun appel réseau n\'est effectué. Les résultats de démo sont signalés par une pastille DEMO afin de ne pas être confondus avec des résultats en direct.';

  @override
  String get privacyLiveTitle => 'Calculs en direct';

  @override
  String privacyLiveBody(String brand) {
    return 'Un calcul en direct (hors démo) envoie votre date de naissance et votre heure approximative, les coordonnées de votre lieu de naissance et les descriptions de vos événements de vie à un fournisseur de calcul tiers via HTTPS. Ces données servent uniquement à calculer votre heure de naissance rectifiée. Elles ne servent pas à constituer un profil et ne sont liées à aucun compte $brand, car il n\'existe pas de comptes.';
  }

  @override
  String get privacyDeleteTitle => 'Suppression de vos données';

  @override
  String get privacyDeleteBody =>
      'L\'écran des Réglages comporte une action « Supprimer toutes les données » qui efface la base de données locale et chaque préférence stockée sur cet appareil. L\'effacement est terminé avant que l\'action ne se conclue ; l\'application vous renvoie ensuite à l\'introduction afin que vous puissiez confirmer la réinitialisation.';

  @override
  String get privacyAnalyticsTitle => 'Analytique et rapports de plantage';

  @override
  String privacyAnalyticsBody(String brand) {
    return 'Cette version de $brand est livrée sans SDK d\'analytique et sans rapport de plantage. Si une future version en ajoute l\'un ou l\'autre, cela sera divulgué ici et limité à des données anonymes et non identifiantes.';
  }

  @override
  String get demoEvidenceStrongVenus =>
      'Un retour de Vénus daté coïncidait avec la fenêtre candidate, cohérent avec un événement de partenariat.';

  @override
  String get demoEvidenceStrongSaturn =>
      'Saturne a franchi la cuspide de la maison 10 dans la fenêtre, une signature de datation classique pour un virage de carrière.';

  @override
  String get demoEvidenceModerateJupiter =>
      'Jupiter est passée près de la cuspide de la maison 4 ; appui modéré pour un événement de foyer / déménagement dans cette fenêtre.';

  @override
  String get demoEvidenceModerateSolarArc =>
      'Un arc solaire vers Mars se situait dans la tolérance de la fenêtre, plausible pour l\'événement signalé mais pas exclusif à celui-ci.';

  @override
  String get demoEvidenceWeakMercury =>
      'Mercure se trouvait dans une large orbe de la cuspide concernée ; insuffisant pour confirmer la datation à lui seul.';

  @override
  String get demoEvidenceNoMatch =>
      'Aucun aspect principal dans la tolérance de la fenêtre candidate. Cet événement n\'appuie ni ne contredit le résultat.';
}
