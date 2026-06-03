// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get commonContinue => 'Weiter';

  @override
  String get commonNext => 'Weiter';

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get onboardingSkip => 'Überspringen';

  @override
  String get onboardingSlide1Title =>
      'Dein Geburtshoroskop hängt von deiner genauen Geburtszeit ab.';

  @override
  String onboardingSlide1Body(String brand) {
    return 'Die meisten kennen nur eine ungefähre Zeit – oder gar keine. $brand grenzt sie anhand von Ereignissen aus deinem Leben ein.';
  }

  @override
  String onboardingSlide2Title(String brand) {
    return 'So funktioniert $brand';
  }

  @override
  String get onboardingSlide2Body =>
      '1. Gib dein Geburtsdatum und die ungefähre Zeit ein.\n2. Füge Ereignisse aus deinem Leben hinzu – Heirat, Jobwechsel, Umzüge und mehr.\n3. Wir berechnen die wahrscheinlichste Geburtszeit und zeigen dir, warum.\n\nJe mehr Ereignisse du hinzufügst, desto genauer wird das Ergebnis.';

  @override
  String get onboardingSlide3Title => 'Bereit, deine Geburtszeit zu finden?';

  @override
  String get onboardingSlide3Body =>
      'Eine Demo zeigt dir zuerst ein Beispielergebnis – ganz ohne Konto.';

  @override
  String get onboardingTryDemo => 'Erst Demo ausprobieren';

  @override
  String get onboardingStartReal => 'Echte Berechnung starten';

  @override
  String onboardingPageLabel(int page, int count) {
    return 'Seite $page von $count';
  }

  @override
  String get birthDataTitle => 'Geburtsdaten';

  @override
  String get birthDataDateLabel => 'Geburtsdatum';

  @override
  String get birthDataDatePlaceholder => 'Datum auswählen';

  @override
  String get birthDataCityLabel => 'Geburtsort';

  @override
  String get birthDataCityHint => 'Beginne, eine Stadt einzutippen';

  @override
  String get birthDataLabelLabel => 'Bezeichnung (optional)';

  @override
  String get birthDataLabelHelper => 'Wird in deinem Verlauf angezeigt.';

  @override
  String get birthDataLabelHint => 'z. B. Meine Geburtszeit';

  @override
  String get birthDataSearching => 'Suche läuft…';

  @override
  String get birthDataNoMatches =>
      'Keine Treffer. Die Demo akzeptiert den eingetippten Namen.';

  @override
  String get timeWindowTitle => 'Kennst du eine ungefähre Geburtszeit?';

  @override
  String get timeWindowModeApprox => 'Ich habe eine ungefähre Zeit';

  @override
  String get timeWindowModeUnknown => 'Ich habe keine Ahnung';

  @override
  String get timeWindowApproxTimeLabel => 'Ungefähre Zeit';

  @override
  String get timeWindowChooseTime => 'Zeit auswählen';

  @override
  String get timeWindowTimePickerHelp => 'Ungefähre Geburtszeit';

  @override
  String get timeWindowSearchWindow => 'Suchfenster';

  @override
  String timeWindowDeltaMinutes(int minutes) {
    return '± $minutes Min.';
  }

  @override
  String timeWindowDeltaHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '± $hours Stunden',
      one: '± 1 Stunde',
    );
    return '$_temp0';
  }

  @override
  String timeWindowRangeCopy(String start, String end) {
    return 'Wir suchen zwischen $start und $end.';
  }

  @override
  String get timeWindowApproxHint =>
      'Ein größeres Fenster liefert mehr Kandidaten, kann aber die Genauigkeit verringern.';

  @override
  String get timeWindowUnknownBody =>
      'Wir durchsuchen den gesamten 24-Stunden-Bereich. Das kann mehr Kandidaten mit geringerer Wahrscheinlichkeit ergeben.';

  @override
  String get timeWindowUnknownHint =>
      'Weitere Lebensereignisse helfen, das Ergebnis einzugrenzen.';

  @override
  String get lifeEventsTitle => 'Lebensereignisse';

  @override
  String lifeEventsTitleWithCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lebensereignisse  ($count hinzugefügt)',
      one: 'Lebensereignisse  (1 hinzugefügt)',
    );
    return '$_temp0';
  }

  @override
  String get lifeEventsAddEvent => 'Ereignis hinzufügen';

  @override
  String get lifeEventsAddFirstEvent => 'Erstes Ereignis hinzufügen';

  @override
  String get lifeEventsContinueDemo => 'Weiter (Demo)';

  @override
  String get lifeEventsEmptyBody =>
      'Füge einprägsame Ereignisse aus deinem Leben hinzu. Je mehr, desto besser.';

  @override
  String get lifeEventsGuidanceEmpty =>
      'Füge für eine echte Berechnung mindestens 5 Ereignisse hinzu. 3 für eine Demo.';

  @override
  String get lifeEventsNoEvents => 'Noch keine Ereignisse.';

  @override
  String lifeEventsGuidanceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count Ereignisse. Füge 5+ hinzu für eine stärkere echte Berechnung.',
      one: '1 Ereignis. Füge 5+ hinzu für eine stärkere echte Berechnung.',
    );
    return '$_temp0';
  }

  @override
  String get eventCategoryMarriage => 'Heirat / Partnerschaft';

  @override
  String get eventCategoryDivorce => 'Scheidung / Trennung';

  @override
  String get eventCategoryCareerChange => 'Berufswechsel';

  @override
  String get eventCategoryJobLoss => 'Jobverlust';

  @override
  String get eventCategoryRelocation => 'Umzug (größerer)';

  @override
  String get eventCategoryChildBirth => 'Geburt eines Kindes';

  @override
  String get eventCategoryFamilyDeath => 'Tod eines Familienmitglieds';

  @override
  String get eventCategoryIllness => 'Schwere Krankheit / Operation';

  @override
  String get eventCategoryAccident => 'Unfall oder Verletzung';

  @override
  String get eventCategoryEducation => 'Bildungsmeilenstein';

  @override
  String get eventCategoryFinancial => 'Finanzieller Wendepunkt';

  @override
  String get eventCategoryOther => 'Sonstiges';

  @override
  String get confirmationTitle => 'Bestätige deine Berechnung';

  @override
  String get confirmationBackToEdit => 'Zurück zum Bearbeiten';

  @override
  String get confirmationCalculate => 'Berechnen';

  @override
  String get confirmationCalculateDemo => 'Berechnen (Demo)';

  @override
  String get confirmationDatePending => 'Datum ausstehend';

  @override
  String get confirmationRowDate => 'Datum';

  @override
  String get confirmationRowCity => 'Stadt';

  @override
  String get confirmationRowLabel => 'Bezeichnung';

  @override
  String get confirmationTimeWindow => 'Zeitfenster';

  @override
  String get confirmationFullDayWindow => 'Volles 24-Stunden-Fenster';

  @override
  String confirmationWindowApprox(String time, String window) {
    return '$time ($window)';
  }

  @override
  String confirmationLifeEventsCount(int count) {
    return 'Lebensereignisse ($count)';
  }

  @override
  String get confirmationDemoNote =>
      'Demo-Modus – wir zeigen ein Beispielergebnis ohne Netzwerkanfrage.';

  @override
  String get loadingTitle =>
      'Deine wahrscheinliche Geburtszeit wird berechnet…';

  @override
  String get loadingDemoTitle => 'Demo-Berechnung läuft…';

  @override
  String get loadingRotating1 => 'Lebensereignisse werden analysiert…';

  @override
  String get loadingRotating2 => 'Planetentransite werden zugeordnet…';

  @override
  String get loadingRotating3 => 'Kandidaten werden eingestuft…';

  @override
  String get loadingTakesUnder => 'Das dauert normalerweise unter 10 Sekunden.';

  @override
  String get addEventAddTitle => 'Lebensereignis hinzufügen';

  @override
  String get addEventEditTitle => 'Lebensereignis bearbeiten';

  @override
  String get addEventSelectCategory => 'Kategorie auswählen';

  @override
  String get addEventCategoryLabel => 'Kategorie';

  @override
  String get addEventChooseCategory => 'Kategorie wählen';

  @override
  String get addEventMonth => 'Monat';

  @override
  String get addEventNoMonth => 'Kein Monat';

  @override
  String get addEventYear => 'Jahr';

  @override
  String get addEventMonthOptional => 'Der Monat ist optional.';

  @override
  String get addEventDescriptionLabel => 'Beschreibung (optional)';

  @override
  String get addEventDescriptionHint =>
      'Alles, was hilft, die Zeit einzugrenzen';

  @override
  String addEventCharCount(int current, int max) {
    return '$current / $max';
  }

  @override
  String get addEventSaveChanges => 'Änderungen speichern';

  @override
  String get commonBackToHistory => 'Zurück zum Verlauf';

  @override
  String get commonDismiss => 'Schließen';

  @override
  String get resultTitle => 'Ergebnis';

  @override
  String get resultNotFoundTitle => 'Wir konnten dieses Ergebnis nicht finden.';

  @override
  String get resultNotFoundBody =>
      'Es wurde möglicherweise aus deinem Verlauf gelöscht. Öffne eine gespeicherte Berechnung oder starte eine neue.';

  @override
  String resultRisingSign(String sign) {
    return 'Aszendent $sign';
  }

  @override
  String get resultSampleData => '(Beispieldaten)';

  @override
  String get resultOtherCandidates => 'Weitere Kandidaten';

  @override
  String get resultSeeEvidence => 'Sieh, wie wir darauf gekommen sind';

  @override
  String get resultShare => 'Ergebnis teilen';

  @override
  String get resultCopiedToClipboard => 'In die Zwischenablage kopiert';

  @override
  String get resultSaveToHistory => 'Im Verlauf speichern';

  @override
  String get resultSaved => 'Gespeichert ✓';

  @override
  String get resultDemoNudgeLabel => 'Hinweis zum Wechsel von der Demo';

  @override
  String get resultDemoNudgeTitle => 'Das war eine Demo.';

  @override
  String get resultDemoNudgeBody =>
      'Führe eine echte Berechnung mit deinen eigenen Geburtsdaten durch.';

  @override
  String get resultStartNewCalculation => 'Neue Berechnung starten';

  @override
  String get evidenceTitle => 'Hinweise';

  @override
  String get evidenceNotFoundTitle =>
      'Wir konnten diese Hinweise nicht finden.';

  @override
  String get evidenceNotFoundBody =>
      'Das zugrunde liegende Ergebnis wurde möglicherweise gelöscht. Kehre zu deinem Verlauf zurück, um eine andere Berechnung auszuwählen.';

  @override
  String evidenceWhyTitle(String time) {
    return 'Warum $time?';
  }

  @override
  String get evidenceNoEvidence =>
      'Für dieses Ergebnis haben wir keine ereignisbezogenen Hinweise.';

  @override
  String evidenceStrongSummary(int strong, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$strong von $total Ereignissen haben diese Zeit stark gestützt.',
      one: '$strong von 1 Ereignis hat diese Zeit stark gestützt.',
    );
    return '$_temp0';
  }

  @override
  String get evidenceEventFallback => 'Ereignis';

  @override
  String get heroResultEyebrow => 'DEINE WAHRSCHEINLICHSTE GEBURTSZEIT';

  @override
  String heroResultSemantic(String eyebrow, String time, String risingSign) {
    return '$eyebrow: $time, $risingSign';
  }

  @override
  String get confidenceBarLabel => 'Wahrscheinlichkeit';

  @override
  String confidenceBarSemantic(String label, int percent) {
    return '$label – $percent Prozent';
  }

  @override
  String get matchStrengthStrong => 'STARK';

  @override
  String get matchStrengthModerate => 'MITTEL';

  @override
  String get matchStrengthWeak => 'SCHWACH';

  @override
  String get matchStrengthNone => 'KEIN TREFFER';

  @override
  String matchStrengthSemantic(String strength) {
    String _temp0 = intl.Intl.selectLogic(
      strength,
      {
        'strong': 'Übereinstimmung stark',
        'moderate': 'Übereinstimmung mittel',
        'weak': 'Übereinstimmung schwach',
        'none': 'Übereinstimmung kein Treffer',
        'other': 'Übereinstimmung',
      },
    );
    return '$_temp0';
  }

  @override
  String candidateCardSemantic(String time, String risingSign, int percent) {
    return 'Kandidat $time, $risingSign, Wahrscheinlichkeit $percent Prozent';
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
            '$label, $date, $time $risingSign, Wahrscheinlichkeit $percent Prozent, Demo',
        'other':
            '$label, $date, $time $risingSign, Wahrscheinlichkeit $percent Prozent',
      },
    );
    return '$_temp0';
  }

  @override
  String evidenceCardSemantic(String category, String date, String strength) {
    String _temp0 = intl.Intl.selectLogic(
      strength,
      {
        'strong': 'Übereinstimmung stark',
        'moderate': 'Übereinstimmung mittel',
        'weak': 'Übereinstimmung schwach',
        'none': 'Übereinstimmung kein Treffer',
        'other': 'Übereinstimmung',
      },
    );
    return '$category, $date, $_temp0';
  }

  @override
  String get demoPillLabel => 'DEMO';

  @override
  String demoPillSemantic(String label) {
    return '$label-Berechnungs-Abzeichen';
  }

  @override
  String eventCardSemantic(String category, String date) {
    return 'Ereignis: $category am $date';
  }

  @override
  String eventCardDeleteSemantic(String category) {
    return 'Ereignis $category löschen';
  }

  @override
  String get commonBack => 'Zurück';

  @override
  String get commonDelete => 'Löschen';

  @override
  String get commonNotSet => 'nicht festgelegt';

  @override
  String fieldValueSemantic(String label, String value) {
    return '$label, $value';
  }

  @override
  String get navNew => 'NEU';

  @override
  String get navHistory => 'VERLAUF';

  @override
  String get navSettings => 'EINSTELLUNGEN';

  @override
  String stepperStep(int current, int total) {
    return 'SCHRITT $current VON $total';
  }

  @override
  String stepperPercent(int percent) {
    return '$percent Prozent';
  }

  @override
  String get calcFlowTitle => 'Neue Berechnung';

  @override
  String get homeSettingsButton => 'Einstellungen';

  @override
  String homeHistoryLoadError(String error) {
    return 'Wir konnten deinen Verlauf nicht laden.\n$error';
  }

  @override
  String get homeEmptyTitle => 'Noch keine Berechnungen.';

  @override
  String get homeEmptyBody =>
      'Führe deine erste durch, um hier Ergebnisse zu sehen.';

  @override
  String get homeNewCalculation => 'Neue Berechnung';

  @override
  String get homePastCalculations => 'Frühere Berechnungen';

  @override
  String get homeDefaultLabel => 'Meine Berechnung';

  @override
  String get historyDeleteTitle => 'Diese Berechnung löschen?';

  @override
  String historyDeleteBody(String label) {
    return 'Dadurch wird \"$label\" aus deinem Verlauf entfernt. Die ursprünglichen Daten werden nirgendwo sonst aufbewahrt.';
  }

  @override
  String historyDeletedSnack(String label) {
    return '\"$label\" gelöscht.';
  }

  @override
  String get historyDeleteFailedSnack =>
      'Dieser Eintrag konnte nicht gelöscht werden.';

  @override
  String get errorTryAgain => 'Erneut versuchen';

  @override
  String get errorOpenSettings => 'Einstellungen öffnen';

  @override
  String get errorReviewDraft => 'Meinen Entwurf prüfen';

  @override
  String get errorTimeoutTitle => 'Zeitüberschreitung bei der Berechnung';

  @override
  String get errorTimeoutBody =>
      'Der Anbieter hat nicht rechtzeitig geantwortet. In öffentlichen WLANs kann das Netzwerk langsam sein – versuche es gleich noch einmal.';

  @override
  String get errorNoInternetTitle => 'Netzwerk nicht erreichbar';

  @override
  String get errorNoInternetBody =>
      'Du bist offline oder dein Netzwerk blockiert die Anfrage. Stelle die Verbindung wieder her und versuche es erneut.';

  @override
  String get errorBadRequestTitle => 'Mit den Daten stimmte etwas nicht';

  @override
  String get errorBadRequestBody =>
      'Der Berechnungsanbieter hat die Anfrage abgelehnt. Überprüfe dein Geburtsdatum, dein Zeitfenster und deine Ereignisse und versuche es erneut.';

  @override
  String get errorUnauthorizedTitle => 'Autorisierung erforderlich';

  @override
  String get errorUnauthorizedBody =>
      'Der Anbieter hat den API-Schlüssel auf diesem Gerät nicht akzeptiert. Öffne die Einstellungen, um einen neuen Schlüssel einzugeben, oder aktiviere den Demo-Modus.';

  @override
  String get errorMissingApiKeyTitle => 'API-Schlüssel erforderlich';

  @override
  String get errorMissingApiKeyBody =>
      'Der Live-Modus benötigt deinen API-Schlüssel von astrology-api.io. Öffne die Einstellungen, um ihn hinzuzufügen, oder aktiviere den Demo-Modus, um die App mit Beispieldaten zu testen.';

  @override
  String get errorRateLimitedTitle =>
      'Tageslimit für Live-Berechnungen erreicht';

  @override
  String get errorRateLimitedBody =>
      'Das Limit für Live-Berechnungen ist für heute erreicht. Versuche es später erneut oder aktiviere den Demo-Modus für ein Offline-Beispielergebnis.';

  @override
  String get errorServerTitle => 'Problem beim Anbieter';

  @override
  String get errorServerBody =>
      'Der Anbieter hat einen Fehler zurückgegeben. Sein Dienst hat vielleicht gerade Probleme – ein erneuter Versuch in Kürze lohnt sich.';

  @override
  String get errorMalformedTitle => 'Antwort konnte nicht gelesen werden';

  @override
  String get errorMalformedBody =>
      'Die Antwort des Anbieters entsprach nicht dem, was diese Version erwartet. Versuche es erneut oder führe eine Demo-Berechnung durch, während wir uns darum kümmern.';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsSectionApiKey => 'API-Schlüssel';

  @override
  String get settingsSectionDefaults => 'Berechnungsvorgaben';

  @override
  String get settingsSectionTimeFormat => 'Zeitformat';

  @override
  String get settingsSectionData => 'Daten';

  @override
  String get settingsSectionAbout => 'Über';

  @override
  String get settingsApiKeyRowLabel => 'API-Schlüssel (Pro / Entwickler)';

  @override
  String get settingsApiKeySet => 'Festgelegt';

  @override
  String get settingsApiKeyNotSet => 'Nicht festgelegt';

  @override
  String get settingsApiKeyHelper =>
      'Optional. Nur für Nutzer mit eigenem Anbieterschlüssel. Leer lassen für den standardmäßigen (Proxy-)Pfad.';

  @override
  String get settingsDemoModeLabel => 'Demo-Modus';

  @override
  String get settingsDemoModeHelper =>
      'Berechnungen mit Beispieldaten durchführen (kostenlos, ohne Netzwerk).';

  @override
  String get settingsTimeFormat12 => '12-Stunden  (7:14 AM)';

  @override
  String get settingsTimeFormat24 => '24-Stunden  (07:14)';

  @override
  String get settingsDeleteAllData => 'Alle Daten löschen';

  @override
  String get settingsDeleteAllHelper =>
      'Entfernt alle Berechnungen und Ereignisse von diesem Gerät. Kann nicht rückgängig gemacht werden.';

  @override
  String get settingsPrivacyPolicy => 'Datenschutzerklärung';

  @override
  String get apiKeySheetBody =>
      'Füge deinen Anbieterschlüssel ein, um den standardmäßigen Proxy-Pfad zu deaktivieren. Der Schlüssel wird nur auf diesem Gerät gespeichert.';

  @override
  String get apiKeyFieldLabel => 'API-Schlüssel';

  @override
  String get apiKeyHintConfigured =>
      'Derzeit festgelegt – gib einen neuen Schlüssel ein, um ihn zu ersetzen';

  @override
  String get apiKeyHintEmpty => 'sk-…';

  @override
  String get apiKeySaveButton => 'Schlüssel speichern';

  @override
  String get apiKeyRemoveButton => 'Schlüssel entfernen';

  @override
  String get apiKeySavedSnack => 'API-Schlüssel gespeichert.';

  @override
  String get apiKeyRemovedSnack => 'API-Schlüssel entfernt.';

  @override
  String get deleteAllTitle => 'Alle Daten löschen?';

  @override
  String get deleteAllBodyGeneric =>
      'Dadurch werden alle Berechnungen, Ereignisse und Einstellungen auf diesem Gerät dauerhaft gelöscht. Kann nicht rückgängig gemacht werden.';

  @override
  String deleteAllBodyCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Dadurch werden $count Berechnungen sowie jedes gespeicherte Ereignis und jede Einstellung auf diesem Gerät dauerhaft gelöscht. Kann nicht rückgängig gemacht werden.',
      one:
          'Dadurch wird 1 Berechnung sowie jedes gespeicherte Ereignis und jede Einstellung auf diesem Gerät dauerhaft gelöscht. Kann nicht rückgängig gemacht werden.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAllFailedSnack =>
      'Daten konnten nicht gelöscht werden. Versuche es erneut.';

  @override
  String get privacyTitle => 'Datenschutz';

  @override
  String privacyStoresTitle(String brand) {
    return 'Was $brand speichert';
  }

  @override
  String privacyStoresBody(String brand) {
    return 'Alles, was du eingibst – Geburtsdatum, Geburtsort, Lebensereignisse, Berechnungsergebnisse – wird nur auf diesem Gerät gespeichert. Nichts wird in ein $brand-Konto hochgeladen, denn wir betreiben keine Nutzerkonten. Das Löschen der App entfernt jedes Byte dieser Daten.';
  }

  @override
  String get privacyApiKeyTitle => 'Optionaler API-Schlüssel';

  @override
  String get privacyApiKeyBody =>
      'Power-User können in den Einstellungen ihren eigenen Anbieter-API-Schlüssel einfügen. Wenn er festgelegt ist, liegt dieser Schlüssel im Schlüsselbund der Plattform (iOS) oder im Keystore (Android) – er gelangt nie in die Datenbank, die Einstellungen, die Protokolle oder Absturzberichte und wird dir nach dem Speichern nie wieder angezeigt.';

  @override
  String get privacyDemoTitle => 'Demo-Modus';

  @override
  String get privacyDemoBody =>
      'Demo-Berechnungen laufen vollständig auf diesem Gerät – es werden keine Netzwerkanfragen gestellt und kein Schlüssel verwendet. Demo-Ergebnisse sind deutlich mit einem DEMO-Abzeichen gekennzeichnet, damit sie nicht mit echten Auswertungen verwechselt werden.';

  @override
  String get privacyLiveTitle => 'Live-Berechnungen';

  @override
  String privacyLiveBody(String brand) {
    return 'Bei einer Live-Berechnung (nicht Demo) werden dein Geburtsdatum und die ungefähre Zeit, die Koordinaten deines Geburtsorts und die Beschreibungen der von dir hinzugefügten Lebensereignisse über HTTPS an einen Drittanbieter zur Berechnung gesendet. Diese Daten werden ausschließlich übertragen, um deine korrigierte Geburtszeit zu berechnen – sie werden nicht für ein Profil verwendet und sind mit keinem $brand-Konto verknüpft, denn es gibt keine.';
  }

  @override
  String get privacyDeleteTitle => 'Deine Daten löschen';

  @override
  String get privacyDeleteBody =>
      'Der Einstellungsbildschirm hat eine Aktion \"Alle Daten löschen\", die die lokale Datenbank, alle Einstellungen und den sicheren Speichereintrag mit deinem API-Schlüssel (falls du einen festgelegt hast) löscht. Die Löschung ist abgeschlossen, bevor die Aktion zurückkehrt; die App bringt dich anschließend zum Onboarding zurück, damit du das Zurücksetzen bestätigen kannst.';

  @override
  String get privacyAnalyticsTitle => 'Analyse und Absturzberichte';

  @override
  String privacyAnalyticsBody(String brand) {
    return 'Diese Version von $brand wird ohne Analyse-SDK und ohne Absturzberichte ausgeliefert. Sollte eine künftige Version eines davon hinzufügen, wird es hier offengelegt und auf anonyme, nicht identifizierende Daten beschränkt.';
  }

  @override
  String get demoEvidenceStrongVenus =>
      'Eine zeitlich passende Venus-Wiederkehr fiel mit dem Kandidatenfenster zusammen, im Einklang mit einem Partnerschaftsereignis.';

  @override
  String get demoEvidenceStrongSaturn =>
      'Saturn überschritt innerhalb des Fensters die Spitze des 10. Hauses – eine klassische Zeitsignatur für einen beruflichen Wendepunkt.';

  @override
  String get demoEvidenceModerateJupiter =>
      'Jupiter zog nahe an der Spitze des 4. Hauses vorbei; mäßiger Anhaltspunkt für ein Heim- / Umzugsereignis in diesem Fenster.';

  @override
  String get demoEvidenceModerateSolarArc =>
      'Ein Solarbogen zu Mars lag innerhalb der Toleranz des Fensters, plausibel für das gemeldete Ereignis, aber nicht ausschließlich darauf bezogen.';

  @override
  String get demoEvidenceWeakMercury =>
      'Merkur lag innerhalb eines weiten Orbis der relevanten Spitze; allein nicht ausreichend, um die Zeit zu bestätigen.';

  @override
  String get demoEvidenceNoMatch =>
      'Kein primärer Aspekt innerhalb der Toleranz des Kandidatenfensters. Dieses Ereignis stützt das Ergebnis weder, noch widerspricht es ihm.';
}
