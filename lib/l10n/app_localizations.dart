import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// Primary button label that advances to the next step in a multi-step flow.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// Button label that advances to the next onboarding slide.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// Generic Cancel button label.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// Button that skips the onboarding slides and goes to the home screen.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// Headline of the first onboarding slide explaining why birth time matters.
  ///
  /// In en, this message translates to:
  /// **'Your birth chart depends on your exact birth time.'**
  String get onboardingSlide1Title;

  /// Body of the first onboarding slide. {brand} is the product name, held constant across locales.
  ///
  /// In en, this message translates to:
  /// **'Most people only know an approximate time — or nothing at all. {brand} narrows it down using events from your life.'**
  String onboardingSlide1Body(String brand);

  /// Headline of the second onboarding slide. {brand} is the product name, held constant across locales.
  ///
  /// In en, this message translates to:
  /// **'How {brand} works'**
  String onboardingSlide2Title(String brand);

  /// Body of the second onboarding slide: a numbered list describing how the calculation flow works.
  ///
  /// In en, this message translates to:
  /// **'1. Enter your birth date and approximate time.\n2. Add events from your life — marriage, job changes, moves, more.\n3. We calculate the most probable birth time and show you why.\n\nThe more events you add, the more accurate the result.'**
  String get onboardingSlide2Body;

  /// Headline of the third onboarding slide.
  ///
  /// In en, this message translates to:
  /// **'Ready to find your birth time?'**
  String get onboardingSlide3Title;

  /// Body of the third onboarding slide.
  ///
  /// In en, this message translates to:
  /// **'A demo shows you a sample result first, with no account needed.'**
  String get onboardingSlide3Body;

  /// Primary call to action on the last onboarding slide that starts the offline demo.
  ///
  /// In en, this message translates to:
  /// **'Try demo first'**
  String get onboardingTryDemo;

  /// Secondary call to action on the last onboarding slide that starts a real calculation.
  ///
  /// In en, this message translates to:
  /// **'Start real calculation'**
  String get onboardingStartReal;

  /// Screen-reader label announcing the current onboarding slide position.
  ///
  /// In en, this message translates to:
  /// **'Page {page} of {count}'**
  String onboardingPageLabel(int page, int count);

  /// Title of step 1 (birth details) of the calculation flow.
  ///
  /// In en, this message translates to:
  /// **'Birth details'**
  String get birthDataTitle;

  /// Label for the date-of-birth field and the header of the date picker.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get birthDataDateLabel;

  /// Placeholder shown in the date-of-birth field before a date is chosen.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get birthDataDatePlaceholder;

  /// Label for the city-of-birth search field.
  ///
  /// In en, this message translates to:
  /// **'City of birth'**
  String get birthDataCityLabel;

  /// Hint shown inside the city-of-birth field.
  ///
  /// In en, this message translates to:
  /// **'Start typing a city'**
  String get birthDataCityHint;

  /// Label for the optional free-text name a user can give a calculation.
  ///
  /// In en, this message translates to:
  /// **'Label (optional)'**
  String get birthDataLabelLabel;

  /// Helper text under the optional label field.
  ///
  /// In en, this message translates to:
  /// **'Shown in your history list.'**
  String get birthDataLabelHelper;

  /// Example hint for the optional label field.
  ///
  /// In en, this message translates to:
  /// **'e.g. My birth time'**
  String get birthDataLabelHint;

  /// Shown while city suggestions are loading.
  ///
  /// In en, this message translates to:
  /// **'Searching…'**
  String get birthDataSearching;

  /// Shown when no city matches the query; the demo still accepts the free-typed name.
  ///
  /// In en, this message translates to:
  /// **'No matches. Demo accepts the typed name.'**
  String get birthDataNoMatches;

  /// Title of step 2 (time window) of the calculation flow.
  ///
  /// In en, this message translates to:
  /// **'Do you know an approximate birth time?'**
  String get timeWindowTitle;

  /// Radio option: the user knows an approximate birth time.
  ///
  /// In en, this message translates to:
  /// **'I have an approximate time'**
  String get timeWindowModeApprox;

  /// Radio option: the user does not know their birth time at all.
  ///
  /// In en, this message translates to:
  /// **'I have no idea'**
  String get timeWindowModeUnknown;

  /// Label for the approximate-time picker field.
  ///
  /// In en, this message translates to:
  /// **'Approximate time'**
  String get timeWindowApproxTimeLabel;

  /// Placeholder for the approximate-time picker before a time is chosen.
  ///
  /// In en, this message translates to:
  /// **'Choose time'**
  String get timeWindowChooseTime;

  /// Header text of the system time picker for the approximate birth time.
  ///
  /// In en, this message translates to:
  /// **'Approximate birth time'**
  String get timeWindowTimePickerHelp;

  /// Label for the search-window picker and the title of its bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'Search window'**
  String get timeWindowSearchWindow;

  /// Search-window width expressed in minutes, e.g. ± 30 min.
  ///
  /// In en, this message translates to:
  /// **'± {minutes} min'**
  String timeWindowDeltaMinutes(int minutes);

  /// Search-window width expressed in hours, e.g. ± 1 hour or ± 3 hours.
  ///
  /// In en, this message translates to:
  /// **'{hours, plural, =1{± 1 hour} other{± {hours} hours}}'**
  String timeWindowDeltaHours(int hours);

  /// Explains the time span that will be searched. start and end are pre-formatted clock times.
  ///
  /// In en, this message translates to:
  /// **'We\'ll search between {start} and {end}.'**
  String timeWindowRangeCopy(String start, String end);

  /// Hint under the search-window picker in approximate mode.
  ///
  /// In en, this message translates to:
  /// **'A wider window gives more candidates but may reduce precision.'**
  String get timeWindowApproxHint;

  /// Body shown when the user has no idea of their birth time.
  ///
  /// In en, this message translates to:
  /// **'We\'ll search the entire 24-hour range. This may produce more candidates with lower confidence.'**
  String get timeWindowUnknownBody;

  /// Hint encouraging more life events when the birth time is unknown.
  ///
  /// In en, this message translates to:
  /// **'Adding more life events will help narrow it down.'**
  String get timeWindowUnknownHint;

  /// Title of step 3 (life events) when no events have been added yet.
  ///
  /// In en, this message translates to:
  /// **'Life events'**
  String get lifeEventsTitle;

  /// Title of step 3 with a count of how many life events have been added.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Life events  (1 added)} other{Life events  ({count} added)}}'**
  String lifeEventsTitleWithCount(int count);

  /// Button to add another life event when at least one already exists.
  ///
  /// In en, this message translates to:
  /// **'Add event'**
  String get lifeEventsAddEvent;

  /// Button to add the first life event when the list is empty.
  ///
  /// In en, this message translates to:
  /// **'Add first event'**
  String get lifeEventsAddFirstEvent;

  /// Continue button label on the life-events step while in demo mode.
  ///
  /// In en, this message translates to:
  /// **'Continue (demo)'**
  String get lifeEventsContinueDemo;

  /// Body shown on the life-events step when no events have been added.
  ///
  /// In en, this message translates to:
  /// **'Add memorable events from your life. The more you add, the better.'**
  String get lifeEventsEmptyBody;

  /// Guidance banner shown on the empty life-events step explaining the recommended event counts.
  ///
  /// In en, this message translates to:
  /// **'Add at least 5 events for a real calculation. 3 for a demo.'**
  String get lifeEventsGuidanceEmpty;

  /// Placeholder shown in the empty life-events list area.
  ///
  /// In en, this message translates to:
  /// **'No events yet.'**
  String get lifeEventsNoEvents;

  /// Soft warning shown when the user has some events but fewer than the recommended five.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 event. Add 5+ for a stronger real calculation.} other{{count} events. Add 5+ for a stronger real calculation.}}'**
  String lifeEventsGuidanceCount(int count);

  /// Life-event category: marriage or partnership.
  ///
  /// In en, this message translates to:
  /// **'Marriage / Partnership'**
  String get eventCategoryMarriage;

  /// Life-event category: divorce or separation.
  ///
  /// In en, this message translates to:
  /// **'Divorce / Separation'**
  String get eventCategoryDivorce;

  /// Life-event category: a change of career.
  ///
  /// In en, this message translates to:
  /// **'Career change'**
  String get eventCategoryCareerChange;

  /// Life-event category: losing a job.
  ///
  /// In en, this message translates to:
  /// **'Job loss'**
  String get eventCategoryJobLoss;

  /// Life-event category: a major relocation or move.
  ///
  /// In en, this message translates to:
  /// **'Relocation (major)'**
  String get eventCategoryRelocation;

  /// Life-event category: the birth of a child.
  ///
  /// In en, this message translates to:
  /// **'Birth of child'**
  String get eventCategoryChildBirth;

  /// Life-event category: the death of a family member.
  ///
  /// In en, this message translates to:
  /// **'Death of family member'**
  String get eventCategoryFamilyDeath;

  /// Life-event category: a major illness or surgery. Descriptive label, not medical advice.
  ///
  /// In en, this message translates to:
  /// **'Major illness / surgery'**
  String get eventCategoryIllness;

  /// Life-event category: an accident or injury.
  ///
  /// In en, this message translates to:
  /// **'Accident or injury'**
  String get eventCategoryAccident;

  /// Life-event category: an education milestone.
  ///
  /// In en, this message translates to:
  /// **'Education milestone'**
  String get eventCategoryEducation;

  /// Life-event category: a financial turning point. Descriptive label, not financial advice.
  ///
  /// In en, this message translates to:
  /// **'Financial turning point'**
  String get eventCategoryFinancial;

  /// Life-event category: anything that does not fit the other categories.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get eventCategoryOther;

  /// Title of the confirmation step that reviews the draft before submitting.
  ///
  /// In en, this message translates to:
  /// **'Confirm your calculation'**
  String get confirmationTitle;

  /// Secondary button that returns to the life-events step to edit the draft.
  ///
  /// In en, this message translates to:
  /// **'Back to edit'**
  String get confirmationBackToEdit;

  /// Primary button that submits a real calculation.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get confirmationCalculate;

  /// Primary button that submits the offline demo calculation.
  ///
  /// In en, this message translates to:
  /// **'Calculate (demo)'**
  String get confirmationCalculateDemo;

  /// Shown in the review summary when no birth date has been chosen yet.
  ///
  /// In en, this message translates to:
  /// **'Date pending'**
  String get confirmationDatePending;

  /// Label for the birth-date row in the review summary.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get confirmationRowDate;

  /// Label for the city row in the review summary.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get confirmationRowCity;

  /// Label for the optional name row in the review summary.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get confirmationRowLabel;

  /// Heading of the time-window card in the review summary.
  ///
  /// In en, this message translates to:
  /// **'Time window'**
  String get confirmationTimeWindow;

  /// Shown in the review summary when the birth time is unknown and the full day is searched.
  ///
  /// In en, this message translates to:
  /// **'Full 24-hour window'**
  String get confirmationFullDayWindow;

  /// Time-window summary line combining the approximate time and its search width. Both parts are pre-formatted.
  ///
  /// In en, this message translates to:
  /// **'{time} ({window})'**
  String confirmationWindowApprox(String time, String window);

  /// Heading of the life-events card in the review summary, with the number of events.
  ///
  /// In en, this message translates to:
  /// **'Life events ({count})'**
  String confirmationLifeEventsCount(int count);

  /// Note shown on the confirmation step when running in offline demo mode.
  ///
  /// In en, this message translates to:
  /// **'Demo mode — we\'ll show a sample result with no network request.'**
  String get confirmationDemoNote;

  /// Main heading on the calculation loading screen for a real calculation.
  ///
  /// In en, this message translates to:
  /// **'Calculating your probable birth time…'**
  String get loadingTitle;

  /// Main heading on the calculation loading screen while running the offline demo.
  ///
  /// In en, this message translates to:
  /// **'Running demo calculation…'**
  String get loadingDemoTitle;

  /// First rotating status line shown under the loader.
  ///
  /// In en, this message translates to:
  /// **'Analyzing life events…'**
  String get loadingRotating1;

  /// Second rotating status line shown under the loader.
  ///
  /// In en, this message translates to:
  /// **'Mapping planetary transits…'**
  String get loadingRotating2;

  /// Third rotating status line shown under the loader.
  ///
  /// In en, this message translates to:
  /// **'Ranking candidates…'**
  String get loadingRotating3;

  /// Reassurance shown under the loader about the expected wait time.
  ///
  /// In en, this message translates to:
  /// **'This usually takes under 10 seconds.'**
  String get loadingTakesUnder;

  /// Title of the add/edit sheet when adding a new life event.
  ///
  /// In en, this message translates to:
  /// **'Add life event'**
  String get addEventAddTitle;

  /// Title of the add/edit sheet when editing an existing life event.
  ///
  /// In en, this message translates to:
  /// **'Edit life event'**
  String get addEventEditTitle;

  /// Title of the bottom sheet that picks a life-event category.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get addEventSelectCategory;

  /// Label for the category picker row in the add/edit sheet.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get addEventCategoryLabel;

  /// Placeholder for the category row before a category is chosen.
  ///
  /// In en, this message translates to:
  /// **'Choose category'**
  String get addEventChooseCategory;

  /// Label for the month picker row and the title of its bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get addEventMonth;

  /// Option in the month picker for events with no specific month.
  ///
  /// In en, this message translates to:
  /// **'No month'**
  String get addEventNoMonth;

  /// Label for the year picker row and the title of its bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get addEventYear;

  /// Helper text under the month/year row explaining the month can be omitted.
  ///
  /// In en, this message translates to:
  /// **'Month is optional.'**
  String get addEventMonthOptional;

  /// Label for the optional free-text description field in the add/edit sheet.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get addEventDescriptionLabel;

  /// Hint inside the optional description field.
  ///
  /// In en, this message translates to:
  /// **'Anything that helps narrow timing'**
  String get addEventDescriptionHint;

  /// Character counter under the description field, showing the current length over the maximum.
  ///
  /// In en, this message translates to:
  /// **'{current} / {max}'**
  String addEventCharCount(int current, int max);

  /// Primary button label when editing an existing life event.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get addEventSaveChanges;

  /// Button that returns to the home/history screen from the result, evidence, or error screens.
  ///
  /// In en, this message translates to:
  /// **'Back to history'**
  String get commonBackToHistory;

  /// Tooltip for the close (x) button that dismisses an inline card or nudge.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get commonDismiss;

  /// Top-navigation title of the hero result screen.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get resultTitle;

  /// Empty-state title shown when a result id can't be resolved (e.g. a stale link).
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find that result.'**
  String get resultNotFoundTitle;

  /// Empty-state body shown when a result can't be found.
  ///
  /// In en, this message translates to:
  /// **'It may have been deleted from your history. Open a saved calculation, or start a new one.'**
  String get resultNotFoundBody;

  /// Rising-sign caption on the result hero and candidate cards, e.g. Gemini Rising.
  ///
  /// In en, this message translates to:
  /// **'{sign} Rising'**
  String resultRisingSign(String sign);

  /// Caption shown in place of a rising sign when a demo result has no real ascendant.
  ///
  /// In en, this message translates to:
  /// **'(sample data)'**
  String get resultSampleData;

  /// Heading above the secondary candidate cards on the result screen.
  ///
  /// In en, this message translates to:
  /// **'Other candidates'**
  String get resultOtherCandidates;

  /// Button that opens the evidence breakdown screen.
  ///
  /// In en, this message translates to:
  /// **'See how we got this'**
  String get resultSeeEvidence;

  /// Button that shares a privacy-safe summary of the result.
  ///
  /// In en, this message translates to:
  /// **'Share result'**
  String get resultShare;

  /// Snackbar shown when the share text was copied to the clipboard instead of opening the native share sheet.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get resultCopiedToClipboard;

  /// Button that confirms saving the result to history.
  ///
  /// In en, this message translates to:
  /// **'Save to history'**
  String get resultSaveToHistory;

  /// Saved-confirmation label shown briefly after the user taps Save to history.
  ///
  /// In en, this message translates to:
  /// **'Saved ✓'**
  String get resultSaved;

  /// Screen-reader label for the demo upgrade nudge container at the bottom of a demo result.
  ///
  /// In en, this message translates to:
  /// **'Demo upgrade nudge'**
  String get resultDemoNudgeLabel;

  /// Title of the demo upgrade nudge.
  ///
  /// In en, this message translates to:
  /// **'This was a demo.'**
  String get resultDemoNudgeTitle;

  /// Body of the demo upgrade nudge.
  ///
  /// In en, this message translates to:
  /// **'Run a real calculation with your own birth data.'**
  String get resultDemoNudgeBody;

  /// Button in the demo nudge that starts a new calculation flow.
  ///
  /// In en, this message translates to:
  /// **'Start a new calculation'**
  String get resultStartNewCalculation;

  /// Top-navigation title of the evidence breakdown screen.
  ///
  /// In en, this message translates to:
  /// **'Evidence'**
  String get evidenceTitle;

  /// Empty-state title on the evidence screen when the underlying result can't be resolved.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find that evidence.'**
  String get evidenceNotFoundTitle;

  /// Empty-state body on the evidence screen.
  ///
  /// In en, this message translates to:
  /// **'The underlying result may have been deleted. Return to your history to pick another calculation.'**
  String get evidenceNotFoundBody;

  /// Evidence-screen headline asking why the top candidate time was chosen. time is a pre-formatted clock time.
  ///
  /// In en, this message translates to:
  /// **'Why {time}?'**
  String evidenceWhyTitle(String time);

  /// Shown on the evidence screen when there is no per-event evidence to display.
  ///
  /// In en, this message translates to:
  /// **'We don\'t have event-level evidence for this result.'**
  String get evidenceNoEvidence;

  /// Evidence summary counting how many of the total events strongly supported the chosen time.
  ///
  /// In en, this message translates to:
  /// **'{total, plural, =1{{strong} of 1 event strongly supported this time.} other{{strong} of {total} events strongly supported this time.}}'**
  String evidenceStrongSummary(int strong, int total);

  /// Fallback category label for an evidence row whose source life event can't be found.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get evidenceEventFallback;

  /// Eyebrow label above the time on the hero result card.
  ///
  /// In en, this message translates to:
  /// **'YOUR MOST PROBABLE BIRTH TIME'**
  String get heroResultEyebrow;

  /// Screen-reader label for the hero result card combining eyebrow, time, and rising sign. All parts are pre-formatted.
  ///
  /// In en, this message translates to:
  /// **'{eyebrow}: {time}, {risingSign}'**
  String heroResultSemantic(String eyebrow, String time, String risingSign);

  /// Default accessibility label prefix for the confidence bar.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get confidenceBarLabel;

  /// Screen-reader label for the confidence bar, e.g. Confidence — 82 percent.
  ///
  /// In en, this message translates to:
  /// **'{label} — {percent} percent'**
  String confidenceBarSemantic(String label, int percent);

  /// Match-strength label: strong support.
  ///
  /// In en, this message translates to:
  /// **'STRONG'**
  String get matchStrengthStrong;

  /// Match-strength label: moderate support.
  ///
  /// In en, this message translates to:
  /// **'MODERATE'**
  String get matchStrengthModerate;

  /// Match-strength label: weak support.
  ///
  /// In en, this message translates to:
  /// **'WEAK'**
  String get matchStrengthWeak;

  /// Match-strength label: no support.
  ///
  /// In en, this message translates to:
  /// **'NO MATCH'**
  String get matchStrengthNone;

  /// Screen-reader label announcing the match-strength level of an evidence row.
  ///
  /// In en, this message translates to:
  /// **'{strength, select, strong{Match strength strong} moderate{Match strength moderate} weak{Match strength weak} none{Match strength no match} other{Match strength}}'**
  String matchStrengthSemantic(String strength);

  /// Screen-reader label for a secondary candidate card. time and risingSign are pre-formatted.
  ///
  /// In en, this message translates to:
  /// **'Candidate {time}, {risingSign}, confidence {percent} percent'**
  String candidateCardSemantic(String time, String risingSign, int percent);

  /// Screen-reader label for a saved-calculation history card; appends a demo marker for demo results. label, date, time, and risingSign are pre-formatted.
  ///
  /// In en, this message translates to:
  /// **'{isDemo, select, true{{label}, {date}, {time} {risingSign}, confidence {percent} percent, demo} other{{label}, {date}, {time} {risingSign}, confidence {percent} percent}}'**
  String historyCardSemantic(
    String isDemo,
    String label,
    String date,
    String time,
    String risingSign,
    int percent,
  );

  /// Screen-reader label for an evidence row combining category, date, and match strength. category and date are pre-formatted.
  ///
  /// In en, this message translates to:
  /// **'{category}, {date}, {strength, select, strong{match strong} moderate{match moderate} weak{match weak} none{match none} other{match}}'**
  String evidenceCardSemantic(String category, String date, String strength);

  /// Text shown inside the DEMO status pill.
  ///
  /// In en, this message translates to:
  /// **'DEMO'**
  String get demoPillLabel;

  /// Screen-reader label for the DEMO status pill.
  ///
  /// In en, this message translates to:
  /// **'{label} calculation badge'**
  String demoPillSemantic(String label);

  /// Screen-reader label for a life-event row. category and date are pre-formatted.
  ///
  /// In en, this message translates to:
  /// **'Event: {category} on {date}'**
  String eventCardSemantic(String category, String date);

  /// Screen-reader label for the delete button on a life-event row.
  ///
  /// In en, this message translates to:
  /// **'Delete event {category}'**
  String eventCardDeleteSemantic(String category);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
