// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonNext => 'Next';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingSlide1Title =>
      'Your birth chart depends on your exact birth time.';

  @override
  String onboardingSlide1Body(String brand) {
    return 'Most people only know an approximate time, or nothing at all. $brand narrows it down using events from your life.';
  }

  @override
  String onboardingSlide2Title(String brand) {
    return 'How $brand works';
  }

  @override
  String get onboardingSlide2Body =>
      '1. Enter your birth date and approximate time.\n2. Add life events you remember: moves, relationships, job changes, and more.\n3. We calculate the most probable birth time and show you why.\n\nThe more events you add, the clearer the result can become.';

  @override
  String get onboardingSlide3Title => 'Ready to find your birth time?';

  @override
  String get onboardingSlide3Body =>
      'A demo shows you a sample result first, with no account needed.';

  @override
  String get onboardingTryDemo => 'Try demo first';

  @override
  String get onboardingStartReal => 'Start real calculation';

  @override
  String onboardingPageLabel(int page, int count) {
    return 'Page $page of $count';
  }

  @override
  String get birthDataTitle => 'Birth details';

  @override
  String get birthDataDateLabel => 'Date of birth';

  @override
  String get birthDataDatePlaceholder => 'Select date';

  @override
  String get birthDataCityLabel => 'City of birth';

  @override
  String get birthDataCityHint => 'Start typing a city';

  @override
  String get birthDataLabelLabel => 'Label (optional)';

  @override
  String get birthDataLabelHelper => 'Shown in your history list.';

  @override
  String get birthDataLabelHint => 'e.g. My birth time';

  @override
  String get birthDataSearching => 'Searching…';

  @override
  String get birthDataNoMatches => 'No city found. Try a different spelling.';

  @override
  String get timeWindowTitle => 'Do you know an approximate birth time?';

  @override
  String get timeWindowModeApprox => 'I have an approximate time';

  @override
  String get timeWindowModeUnknown => 'I have no idea';

  @override
  String get timeWindowApproxTimeLabel => 'Approximate time';

  @override
  String get timeWindowChooseTime => 'Choose time';

  @override
  String get timeWindowTimePickerHelp => 'Approximate birth time';

  @override
  String get timeWindowSearchWindow => 'Search window';

  @override
  String timeWindowDeltaMinutes(int minutes) {
    return '± $minutes min';
  }

  @override
  String timeWindowDeltaHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '± $hours hours',
      one: '± 1 hour',
    );
    return '$_temp0';
  }

  @override
  String timeWindowRangeCopy(String start, String end) {
    return 'We\'ll search between $start and $end.';
  }

  @override
  String get timeWindowApproxHint =>
      'A wider window gives more candidates but may reduce precision.';

  @override
  String get timeWindowUnknownBody =>
      'We\'ll search the entire 24-hour range. This may produce more candidates with lower confidence.';

  @override
  String get timeWindowUnknownHint =>
      'Adding more life events will help narrow it down.';

  @override
  String get lifeEventsTitle => 'Life events';

  @override
  String lifeEventsTitleWithCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Life events  ($count added)',
      one: 'Life events  (1 added)',
    );
    return '$_temp0';
  }

  @override
  String get lifeEventsAddEvent => 'Add event';

  @override
  String get lifeEventsAddFirstEvent => 'Add first event';

  @override
  String get lifeEventsContinueDemo => 'Continue (demo)';

  @override
  String get lifeEventsEmptyBody =>
      'Add memorable events from your life. The more you add, the better.';

  @override
  String get lifeEventsGuidanceEmpty =>
      'Add at least 5 events for a real calculation. 3 for a demo.';

  @override
  String get lifeEventsNoEvents => 'No events yet.';

  @override
  String lifeEventsGuidanceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count events. Add 5+ for a stronger real calculation.',
      one: '1 event. Add 5+ for a stronger real calculation.',
    );
    return '$_temp0';
  }

  @override
  String get eventCategoryMarriage => 'Marriage / Partnership';

  @override
  String get eventCategoryDivorce => 'Divorce / Separation';

  @override
  String get eventCategoryCareerChange => 'Career change';

  @override
  String get eventCategoryJobLoss => 'Job loss';

  @override
  String get eventCategoryRelocation => 'Relocation (major)';

  @override
  String get eventCategoryChildBirth => 'Birth of child';

  @override
  String get eventCategoryFamilyDeath => 'Death of family member';

  @override
  String get eventCategoryIllness => 'Major illness / surgery';

  @override
  String get eventCategoryAccident => 'Accident or injury';

  @override
  String get eventCategoryEducation => 'Education milestone';

  @override
  String get eventCategoryFinancial => 'Financial turning point';

  @override
  String get eventCategoryOther => 'Other';

  @override
  String get confirmationTitle => 'Confirm your calculation';

  @override
  String get confirmationBackToEdit => 'Back to edit';

  @override
  String get confirmationCalculate => 'Calculate';

  @override
  String get confirmationCalculateDemo => 'Calculate (demo)';

  @override
  String get confirmationDatePending => 'Date pending';

  @override
  String get confirmationRowDate => 'Date';

  @override
  String get confirmationRowCity => 'City';

  @override
  String get confirmationRowLabel => 'Label';

  @override
  String get confirmationTimeWindow => 'Time window';

  @override
  String get confirmationFullDayWindow => 'Full 24-hour window';

  @override
  String confirmationWindowApprox(String time, String window) {
    return '$time ($window)';
  }

  @override
  String confirmationLifeEventsCount(int count) {
    return 'Life events ($count)';
  }

  @override
  String get confirmationDemoNote =>
      'Demo mode: we\'ll show a sample result with no network request.';

  @override
  String get confirmationLiveDisclosure =>
      'Live calculation sends your birth date, approximate time, birthplace coordinates, and life events to a third-party calculation provider over HTTPS. Demo mode stays offline.';

  @override
  String get loadingTitle => 'Calculating your probable birth time…';

  @override
  String get loadingDemoTitle => 'Running demo calculation…';

  @override
  String get loadingRotating1 => 'Analyzing life events…';

  @override
  String get loadingRotating2 => 'Mapping planetary transits…';

  @override
  String get loadingRotating3 => 'Ranking candidates…';

  @override
  String get loadingTakesUnder => 'This usually takes under 10 seconds.';

  @override
  String get addEventAddTitle => 'Add life event';

  @override
  String get addEventEditTitle => 'Edit life event';

  @override
  String get addEventSelectCategory => 'Select category';

  @override
  String get addEventCategoryLabel => 'Category';

  @override
  String get addEventChooseCategory => 'Choose category';

  @override
  String get addEventMonth => 'Month';

  @override
  String get addEventNoMonth => 'No month';

  @override
  String get addEventYear => 'Year';

  @override
  String get addEventMonthOptional => 'Month is optional.';

  @override
  String get addEventDescriptionLabel => 'Description (optional)';

  @override
  String get addEventDescriptionHint => 'Anything that helps narrow timing';

  @override
  String addEventCharCount(int current, int max) {
    return '$current / $max';
  }

  @override
  String get addEventSaveChanges => 'Save changes';

  @override
  String get commonBackToHistory => 'Back to history';

  @override
  String get commonDismiss => 'Dismiss';

  @override
  String get resultTitle => 'Result';

  @override
  String get resultNotFoundTitle => 'We couldn\'t find that result.';

  @override
  String get resultNotFoundBody =>
      'It may have been deleted from your history. Open a saved calculation, or start a new one.';

  @override
  String resultRisingSign(String sign) {
    return '$sign Rising';
  }

  @override
  String get resultSampleData => '(sample data)';

  @override
  String get resultLowConfidenceTitle => 'Low confidence result';

  @override
  String get resultLowConfidenceTipEvents => 'Add more dated life events.';

  @override
  String get resultLowConfidenceTipReviewInput =>
      'Review your birth date, city, and approximate time.';

  @override
  String get resultLowConfidenceTipWiderWindow =>
      'Try a wider birth-time window.';

  @override
  String get resultConfidenceExplainerTitle => 'What does this percent mean?';

  @override
  String get resultConfidenceExplainerBody =>
      'Confidence is an estimate. It shows how strongly your dated life events support this candidate time compared with the other candidate times in your selected birth-time window.';

  @override
  String get resultConfidenceExplainerMethod =>
      'Method: each candidate time is scored against your events using transits and progressions; higher scores mean a more probable match.';

  @override
  String get resultOtherCandidates => 'Other candidates';

  @override
  String get resultSeeEvidence => 'See how we got this';

  @override
  String get resultShare => 'Share result';

  @override
  String get resultCopiedToClipboard => 'Copied to clipboard';

  @override
  String get resultShareImage => 'Share image';

  @override
  String get resultShareImageUnavailable =>
      'Couldn\'t open the share sheet for the image.';

  @override
  String get resultDemoShareLabel => 'Share this sample';

  @override
  String get resultDemoShareTitle => 'Like this sample? Share it.';

  @override
  String get resultDemoShareButton => 'Share sample';

  @override
  String get resultFriendShareLabel => 'Share with a friend';

  @override
  String get resultFriendShareTitle =>
      'Know someone who doesn\'t know their birth time?';

  @override
  String get resultFriendShareBody =>
      'Share TrueRise with them. Your result share never includes birth date, birthplace, or life events.';

  @override
  String get resultFriendShareButton => 'Share with a friend';

  @override
  String get resultSharePreviewTitle => 'What will be shared';

  @override
  String get resultFeedbackLabel => 'Result feedback';

  @override
  String get resultFeedbackTitle => 'Does this time feel plausible?';

  @override
  String get resultFeedbackYes => 'Yes';

  @override
  String get resultFeedbackNotSure => 'Not sure';

  @override
  String get resultFeedbackNo => 'No';

  @override
  String get resultFeedbackSaved => 'Thanks, saved.';

  @override
  String get shareCardTagline => 'Birth-time rectification';

  @override
  String shareCardConfidence(int percent) {
    return '$percent% confidence';
  }

  @override
  String shareCopyHeadline(String brand) {
    return 'My $brand rectification result:';
  }

  @override
  String shareCopyTagline(String brand) {
    return 'Calculated with $brand: birth-time rectification';
  }

  @override
  String shareCopyGetApp(String url) {
    return 'Find your birth time: $url';
  }

  @override
  String inviteCopyHeadline(String brand) {
    return 'Try $brand: estimate your birth time';
  }

  @override
  String get inviteCopyBody =>
      'It estimates a probable birth time from a few life events you remember.';

  @override
  String inviteCopyGetApp(String url) {
    return 'Get the app: $url';
  }

  @override
  String get resultSaveToHistory => 'Save to history';

  @override
  String get resultSaved => 'Saved ✓';

  @override
  String get resultDemoNudgeLabel => 'Demo upgrade nudge';

  @override
  String get resultDemoNudgeTitle => 'This was a demo.';

  @override
  String get resultDemoNudgeBody =>
      'Run a real calculation with your own birth data.';

  @override
  String get resultStartNewCalculation => 'Start a new calculation';

  @override
  String reviewPromptTitle(String brand) {
    return 'Review $brand?';
  }

  @override
  String reviewPromptBody(String brand) {
    return 'If $brand has been useful, an honest review helps other people decide whether to try it. It only takes a moment, and it\'s completely optional.';
  }

  @override
  String get reviewPromptConfirm => 'Leave a review';

  @override
  String get reviewPromptDismiss => 'Not now';

  @override
  String get updateAvailableTitle => 'Update available';

  @override
  String updateAvailableBody(String brand) {
    return 'A new version of $brand is ready to install.';
  }

  @override
  String get updateRequiredTitle => 'Update required';

  @override
  String updateRequiredBody(String brand) {
    return 'This version of $brand is out of date. Update it to keep going.';
  }

  @override
  String get updateAction => 'Update';

  @override
  String get updateNotNow => 'Not now';

  @override
  String get updateOpenStoreFailed => 'Couldn\'t open the store page.';

  @override
  String get evidenceTitle => 'Evidence';

  @override
  String get evidenceNotFoundTitle => 'We couldn\'t find that evidence.';

  @override
  String get evidenceNotFoundBody =>
      'The underlying result may have been deleted. Return to your history to pick another calculation.';

  @override
  String evidenceWhyTitle(String time) {
    return 'Why $time?';
  }

  @override
  String get evidenceNoEvidence =>
      'We don\'t have event-level evidence for this result.';

  @override
  String evidenceStrongSummary(int strong, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$strong of $total events strongly supported this time.',
      one: '$strong of 1 event strongly supported this time.',
    );
    return '$_temp0';
  }

  @override
  String get evidenceEventFallback => 'Event';

  @override
  String get heroResultEyebrow => 'YOUR MOST PROBABLE BIRTH TIME';

  @override
  String heroResultSemantic(String eyebrow, String time, String risingSign) {
    return '$eyebrow: $time, $risingSign';
  }

  @override
  String get confidenceBarLabel => 'Confidence';

  @override
  String confidenceBarSemantic(String label, int percent) {
    return '$label: $percent percent';
  }

  @override
  String get matchStrengthStrong => 'STRONG';

  @override
  String get matchStrengthModerate => 'MODERATE';

  @override
  String get matchStrengthWeak => 'WEAK';

  @override
  String get matchStrengthNone => 'NO MATCH';

  @override
  String matchStrengthSemantic(String strength) {
    String _temp0 = intl.Intl.selectLogic(
      strength,
      {
        'strong': 'Match strength strong',
        'moderate': 'Match strength moderate',
        'weak': 'Match strength weak',
        'none': 'Match strength no match',
        'other': 'Match strength',
      },
    );
    return '$_temp0';
  }

  @override
  String candidateCardSemantic(String time, String risingSign, int percent) {
    return 'Candidate $time, $risingSign, confidence $percent percent';
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
            '$label, $date, $time $risingSign, confidence $percent percent, demo',
        'other':
            '$label, $date, $time $risingSign, confidence $percent percent',
      },
    );
    return '$_temp0';
  }

  @override
  String evidenceCardSemantic(String category, String date, String strength) {
    String _temp0 = intl.Intl.selectLogic(
      strength,
      {
        'strong': 'match strong',
        'moderate': 'match moderate',
        'weak': 'match weak',
        'none': 'match none',
        'other': 'match',
      },
    );
    return '$category, $date, $_temp0';
  }

  @override
  String get demoPillLabel => 'DEMO';

  @override
  String demoPillSemantic(String label) {
    return '$label calculation badge';
  }

  @override
  String eventCardSemantic(String category, String date) {
    return 'Event: $category on $date';
  }

  @override
  String eventCardDeleteSemantic(String category) {
    return 'Delete event $category';
  }

  @override
  String get commonBack => 'Back';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonNotSet => 'not set';

  @override
  String fieldValueSemantic(String label, String value) {
    return '$label, $value';
  }

  @override
  String get navNew => 'NEW';

  @override
  String get navHistory => 'HISTORY';

  @override
  String get navSettings => 'SETTINGS';

  @override
  String stepperStep(int current, int total) {
    return 'STEP $current OF $total';
  }

  @override
  String stepperPercent(int percent) {
    return '$percent percent';
  }

  @override
  String get calcFlowTitle => 'New Calculation';

  @override
  String get homeSettingsButton => 'Settings';

  @override
  String homeHistoryLoadError(String error) {
    return 'We couldn\'t load your history.\n$error';
  }

  @override
  String get homeEmptyTitle => 'No calculations yet.';

  @override
  String get homeEmptyBody => 'Run your first one to see results here.';

  @override
  String get homeNewCalculation => 'New Calculation';

  @override
  String get homePastCalculations => 'Past calculations';

  @override
  String get homeDefaultLabel => 'My calculation';

  @override
  String get historyDeleteTitle => 'Delete this calculation?';

  @override
  String historyDeleteBody(String label) {
    return 'This removes \"$label\" from your history. The original data isn\'t kept anywhere else.';
  }

  @override
  String historyDeletedSnack(String label) {
    return '\"$label\" deleted.';
  }

  @override
  String get historyDeleteFailedSnack => 'Couldn\'t delete this entry.';

  @override
  String get errorTryAgain => 'Try again';

  @override
  String get errorReviewDraft => 'Review my draft';

  @override
  String get errorTimeoutTitle => 'Calculation timed out';

  @override
  String get errorTimeoutBody =>
      'The calculation didn\'t finish in time. Public Wi-Fi can be slow. Try again in a moment.';

  @override
  String get errorNoInternetTitle => 'Can\'t reach the network';

  @override
  String get errorNoInternetBody =>
      'You\'re offline, or your network is blocking the request. Reconnect and try again.';

  @override
  String get errorBadRequestTitle => 'Something looked off in the data';

  @override
  String get errorBadRequestBody =>
      'Something in your birth date, time window, or events couldn\'t be processed. Double-check them, then try again.';

  @override
  String get errorUnauthorizedTitle => 'Couldn\'t complete the calculation';

  @override
  String get errorUnauthorizedBody =>
      'We couldn\'t complete this calculation right now. Try again in a moment, or switch on Demo mode to keep exploring with sample data.';

  @override
  String get errorMissingApiKeyTitle => 'Couldn\'t start the calculation';

  @override
  String get errorMissingApiKeyBody =>
      'We couldn\'t start a live calculation right now. Try again in a moment, or switch on Demo mode to try the app with sample data.';

  @override
  String get errorServerTitle => 'Something went wrong';

  @override
  String get errorServerBody =>
      'The calculation couldn\'t be completed just now. It may be temporary. Try again in a little while.';

  @override
  String get errorRateLimitedTitle => 'Calculation limit reached';

  @override
  String get errorRateLimitedBody =>
      'You\'ve reached the calculation limit for now. Wait a little and try again, or switch on Demo mode to keep exploring offline.';

  @override
  String get errorRateLimitedUseDemo => 'Use Demo Mode';

  @override
  String get errorRateLimitedEnterKey => 'Enter My API Key';

  @override
  String errorRateLimitedLocalQuotaBody(String resetDetail) {
    return 'Your free live quota is used up.$resetDetail Switch to Demo Mode to keep exploring, or add your own API key in Settings.';
  }

  @override
  String errorRateLimitedResetAt(String resetTime) {
    return 'Resets at $resetTime UTC.';
  }

  @override
  String errorRateLimitedRetryAfter(String duration) {
    return 'You can try again in about $duration.';
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
      other: '$count hours',
      one: '1 hour',
    );
    return '$_temp0';
  }

  @override
  String get errorMalformedTitle => 'Couldn\'t read the response';

  @override
  String get errorMalformedBody =>
      'The response didn\'t match what this build expects. Try again, or run a demo calculation while we look into it.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSectionDefaults => 'Calculation defaults';

  @override
  String get settingsSectionTimeFormat => 'Time format';

  @override
  String get settingsSectionApiKey => 'API key';

  @override
  String get settingsSectionData => 'Data';

  @override
  String get settingsSectionAbout => 'About';

  @override
  String get settingsDemoModeLabel => 'Demo mode';

  @override
  String get settingsDemoModeHelper =>
      'Run calculations with sample data (free, no network).';

  @override
  String get settingsTimeFormat12 => '12-hour  (7:14 AM)';

  @override
  String get settingsTimeFormat24 => '24-hour  (07:14)';

  @override
  String get settingsSectionLanguage => 'Language';

  @override
  String get settingsLanguageAuto => 'Automatic (device language)';

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
      'Already have an Astrology API key? Add it here.';

  @override
  String get settingsApiKeyGetLink => 'Get a key at';

  @override
  String get settingsApiKeyConfigured => 'API key added';

  @override
  String get settingsApiKeyAdd => 'Add key';

  @override
  String get settingsApiKeyRemove => 'Remove key';

  @override
  String get settingsApiKeyFieldLabel => 'Astrology API key';

  @override
  String get settingsApiKeySave => 'Save key';

  @override
  String get settingsDeleteAllData => 'Delete all data';

  @override
  String get settingsDeleteAllHelper =>
      'Removes all calculations and events from this device. Cannot be undone.';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsInviteFriend => 'Invite a friend';

  @override
  String get deleteAllTitle => 'Delete all data?';

  @override
  String get deleteAllBodyGeneric =>
      'This will permanently delete every calculation, event, and setting on this device. Cannot be undone.';

  @override
  String deleteAllBodyCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'This will permanently delete $count calculations and every saved event and setting on this device. Cannot be undone.',
      one:
          'This will permanently delete 1 calculation and every saved event and setting on this device. Cannot be undone.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAllFailedSnack => 'Couldn\'t delete data. Try again.';

  @override
  String get privacyTitle => 'Privacy';

  @override
  String privacyStoresTitle(String brand) {
    return 'What $brand stores';
  }

  @override
  String privacyStoresBody(String brand) {
    return 'Your birth date, birth city, life events, and results stay on this device. Nothing is uploaded to a $brand account, because we do not run user accounts. Deleting the app removes this data.';
  }

  @override
  String get privacyDemoTitle => 'Demo mode';

  @override
  String get privacyDemoBody =>
      'Demo calculations run entirely on this device. They make no network calls. Demo results are marked with a DEMO pill so they do not get mixed up with live results.';

  @override
  String get privacyLiveTitle => 'Live calculations';

  @override
  String privacyLiveBody(String brand) {
    return 'A live (non-demo) calculation sends your birth date and approximate time, birthplace coordinates, and life-event descriptions to a third-party calculation provider over HTTPS. City search may also use a geocoding service to find birthplace coordinates. The data is used only to calculate your rectified birth time. It is not used to build a profile and is not tied to any $brand account, because there are no accounts.';
  }

  @override
  String get privacyDeleteTitle => 'Deleting your data';

  @override
  String get privacyDeleteBody =>
      'The Settings screen has a \"Delete all data\" action that wipes the local database and every preference stored on this device. The wipe completes before the action returns; the app then sends you back to onboarding so you can confirm the reset.';

  @override
  String get privacyAnalyticsTitle => 'Analytics and crash reporting';

  @override
  String privacyAnalyticsBody(String brand) {
    return 'This release of $brand ships without an analytics SDK and without crash reporting. If a future release adds either, it will be disclosed here and limited to anonymous, non-identifying data.';
  }

  @override
  String get demoEvidenceStrongVenus =>
      'A timed Venus return aligned with the candidate window, consistent with a partnership event.';

  @override
  String get demoEvidenceStrongSaturn =>
      'Saturn crossed the 10th-house cusp inside the window, a classic timing signature for a career pivot.';

  @override
  String get demoEvidenceModerateJupiter =>
      'Jupiter passed near the 4th-house cusp; moderate support for a home / relocation event in this window.';

  @override
  String get demoEvidenceModerateSolarArc =>
      'A solar arc to Mars sat within tolerance of the window, plausible for the reported event but not exclusive to it.';

  @override
  String get demoEvidenceWeakMercury =>
      'Mercury was within wide orb of the relevant cusp; insufficient to confirm timing on its own.';

  @override
  String get demoEvidenceNoMatch =>
      'No primary aspect within tolerance of the candidate window. This event neither supports nor contradicts the result.';
}
