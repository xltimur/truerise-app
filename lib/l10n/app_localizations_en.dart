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
    return 'Most people only know an approximate time — or nothing at all. $brand narrows it down using events from your life.';
  }

  @override
  String onboardingSlide2Title(String brand) {
    return 'How $brand works';
  }

  @override
  String get onboardingSlide2Body =>
      '1. Enter your birth date and approximate time.\n2. Add events from your life — marriage, job changes, moves, more.\n3. We calculate the most probable birth time and show you why.\n\nThe more events you add, the more accurate the result.';

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
  String get birthDataNoMatches => 'No matches. Demo accepts the typed name.';

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
      'Demo mode — we\'ll show a sample result with no network request.';

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
  String get resultOtherCandidates => 'Other candidates';

  @override
  String get resultSeeEvidence => 'See how we got this';

  @override
  String get resultShare => 'Share result';

  @override
  String get resultCopiedToClipboard => 'Copied to clipboard';

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
    return '$label — $percent percent';
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
}
