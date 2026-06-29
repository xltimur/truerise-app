import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_uk.dart';

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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
    Locale('uk'),
  ];

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
  /// **'Most people only know an approximate time, or nothing at all. {brand} narrows it down using events from your life.'**
  String onboardingSlide1Body(String brand);

  /// Headline of the second onboarding slide. {brand} is the product name, held constant across locales.
  ///
  /// In en, this message translates to:
  /// **'How {brand} works'**
  String onboardingSlide2Title(String brand);

  /// Body of the second onboarding slide: a numbered list describing how the calculation flow works.
  ///
  /// In en, this message translates to:
  /// **'1. Enter your birth date and approximate time.\n2. Add life events you remember: moves, relationships, job changes, and more.\n3. We calculate the most probable birth time and show you why.\n\nThe more events you add, the clearer the result can become.'**
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

  /// Shown when the geocoder returns no results for the typed query.
  ///
  /// In en, this message translates to:
  /// **'No city found. Try a different spelling.'**
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
  /// **'Demo mode: we\'ll show a sample result with no network request.'**
  String get confirmationDemoNote;

  /// Short disclosure shown on the confirmation step before a real live calculation. It must name the data sent, the third-party calculation provider, HTTPS, and that demo mode stays offline.
  ///
  /// In en, this message translates to:
  /// **'Live calculation sends your birth date, approximate time, birthplace coordinates, and life events to a third-party calculation provider over HTTPS. Demo mode stays offline.'**
  String get confirmationLiveDisclosure;

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

  /// Title of the inline guidance note under the confidence bar when the top candidate's confidence is in the low band (<40%). Honest, not alarming - the calculation succeeded but would benefit from better input.
  ///
  /// In en, this message translates to:
  /// **'Low confidence result'**
  String get resultLowConfidenceTitle;

  /// First next-step line in the low-confidence guidance note: add more dated life events in the next calculation.
  ///
  /// In en, this message translates to:
  /// **'Add more dated life events.'**
  String get resultLowConfidenceTipEvents;

  /// Second next-step line in the low-confidence guidance note: double-check the birth data entered.
  ///
  /// In en, this message translates to:
  /// **'Review your birth date, city, and approximate time.'**
  String get resultLowConfidenceTipReviewInput;

  /// Third next-step line in the low-confidence guidance note: widen the birth-time window in the next calculation.
  ///
  /// In en, this message translates to:
  /// **'Try a wider birth-time window.'**
  String get resultLowConfidenceTipWiderWindow;

  /// Title of the compact explanation block under the confidence bar that explains what the confidence percent means.
  ///
  /// In en, this message translates to:
  /// **'What does this percent mean?'**
  String get resultConfidenceExplainerTitle;

  /// Body of the confidence explanation block. Must stay probabilistic (estimate/probable) and avoid absolute outcome claims. Explains that confidence is relative support across candidate times in the selected birth-time window.
  ///
  /// In en, this message translates to:
  /// **'Confidence is an estimate. It shows how strongly your dated life events support this candidate time compared with the other candidate times in your selected birth-time window.'**
  String get resultConfidenceExplainerBody;

  /// Method line of the confidence explanation block. High-level description of the scoring method (transits + progressions), framed as method/tooling rather than fortune-telling, and kept probabilistic.
  ///
  /// In en, this message translates to:
  /// **'Method: each candidate time is scored against your events using transits and progressions; higher scores mean a more probable match.'**
  String get resultConfidenceExplainerMethod;

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

  /// Button that shares a privacy-safe image story card of the result.
  ///
  /// In en, this message translates to:
  /// **'Share image'**
  String get resultShareImage;

  /// Snackbar shown when the native share sheet could not be presented for an image share.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the share sheet for the image.'**
  String get resultShareImageUnavailable;

  /// Screen-reader label for the one-time post-demo share affordance container.
  ///
  /// In en, this message translates to:
  /// **'Share this sample'**
  String get resultDemoShareLabel;

  /// Title of the one-time post-demo share affordance. The shared text never includes personal birth details.
  ///
  /// In en, this message translates to:
  /// **'Like this sample? Share it.'**
  String get resultDemoShareTitle;

  /// Button in the post-demo affordance that shares the privacy-safe sample result.
  ///
  /// In en, this message translates to:
  /// **'Share sample'**
  String get resultDemoShareButton;

  /// Screen-reader label for the one-time post-result friend-share affordance container. Optional and dismissible; no reward, referral code, contacts access, tracking, or forced sharing.
  ///
  /// In en, this message translates to:
  /// **'Share with a friend'**
  String get resultFriendShareLabel;

  /// Title of the one-time post-result friend-share affordance. Store-safe: invitation only, no reward/referral/ratings pressure, and no forced action.
  ///
  /// In en, this message translates to:
  /// **'Know someone who doesn\'t know their birth time?'**
  String get resultFriendShareTitle;

  /// Body of the one-time post-result friend-share affordance. Must reassure that shared result copy is privacy-safe and does not include birth date, birthplace, or life events. No reward/referral/tracking language.
  ///
  /// In en, this message translates to:
  /// **'Share TrueRise with them. Your result share never includes birth date, birthplace, or life events.'**
  String get resultFriendShareBody;

  /// Button in the one-time post-result affordance. Opens the native share sheet with the existing privacy-safe result payload. No referral code, reward, contacts access, tracking, or unlock-by-share.
  ///
  /// In en, this message translates to:
  /// **'Share with a friend'**
  String get resultFriendShareButton;

  /// Small label above the exact text preview in the post-result share affordance. The preview shows the privacy-safe text before the native share sheet opens.
  ///
  /// In en, this message translates to:
  /// **'What will be shared'**
  String get resultSharePreviewTitle;

  /// Screen-reader label for the post-result plausibility feedback prompt container.
  ///
  /// In en, this message translates to:
  /// **'Result feedback'**
  String get resultFeedbackLabel;

  /// Title of the post-result plausibility feedback prompt asking whether the rectified birth time feels plausible to the user.
  ///
  /// In en, this message translates to:
  /// **'Does this time feel plausible?'**
  String get resultFeedbackTitle;

  /// Affirmative answer button in the post-result plausibility feedback prompt.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get resultFeedbackYes;

  /// Undecided answer button in the post-result plausibility feedback prompt.
  ///
  /// In en, this message translates to:
  /// **'Not sure'**
  String get resultFeedbackNotSure;

  /// Negative answer button in the post-result plausibility feedback prompt.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get resultFeedbackNo;

  /// Confirmation shown after the user's plausibility feedback answer has been recorded.
  ///
  /// In en, this message translates to:
  /// **'Thanks, saved.'**
  String get resultFeedbackSaved;

  /// Short tagline printed at the bottom of the shareable result image card.
  ///
  /// In en, this message translates to:
  /// **'Birth-time rectification'**
  String get shareCardTagline;

  /// Confidence line printed on the shareable result image card, e.g. 78% confidence.
  ///
  /// In en, this message translates to:
  /// **'{percent}% confidence'**
  String shareCardConfidence(int percent);

  /// First line of the privacy-safe text shared from a result. {brand} is the product name, held constant across locales. The shared text never includes personal birth details, life events, city, coordinates, labels, or API ids.
  ///
  /// In en, this message translates to:
  /// **'My {brand} rectification result:'**
  String shareCopyHeadline(String brand);

  /// Attribution line in the privacy-safe shared text, naming the app and what it does. {brand} is the product name, held constant across locales. Honest-confidence tone: the app estimates a probable time, never a certainty; keep any hedging in translation.
  ///
  /// In en, this message translates to:
  /// **'Calculated with {brand}: birth-time rectification'**
  String shareCopyTagline(String brand);

  /// Call-to-action line appended to the privacy-safe shared text, inviting the recipient to try the app via a public landing/store link. {url} is a non-secret public URL with no tracking parameters or personal data; keep it verbatim.
  ///
  /// In en, this message translates to:
  /// **'Find your birth time: {url}'**
  String shareCopyGetApp(String url);

  /// First line of the privacy-safe 'Invite a friend' message shared from Settings. A soft, opt-in invitation, never a referral or reward. {brand} is the product name, held constant across locales. The message reads no saved calculation and contains no birth date, city, coordinates, life events, labels, or API ids.
  ///
  /// In en, this message translates to:
  /// **'Try {brand}: estimate your birth time'**
  String inviteCopyHeadline(String brand);

  /// Second line of the 'Invite a friend' message, explaining honestly what the app does (a probable estimate, not a certainty). Carries no personal data and no referral/reward language.
  ///
  /// In en, this message translates to:
  /// **'It estimates a probable birth time from a few life events you remember.'**
  String get inviteCopyBody;

  /// Link line of the 'Invite a friend' message. {url} is a non-secret public landing/store link with no tracking parameters or personal data; keep it verbatim.
  ///
  /// In en, this message translates to:
  /// **'Get the app: {url}'**
  String inviteCopyGetApp(String url);

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

  /// Title of the optional, neutral in-app review invitation shown after the user successfully shares a result. {brand} is the product name, held constant across locales. Compliance: must stay neutral; no star count, no reward, no pressure, and no 'are you happy?' sentiment question that would gate who reaches the store.
  ///
  /// In en, this message translates to:
  /// **'Review {brand}?'**
  String reviewPromptTitle(String brand);

  /// Body of the in-app review invitation. Compliance: asks only for an honest review; never requests a specific rating or star count, never offers an incentive, and never implies any feature is gated behind reviewing.
  ///
  /// In en, this message translates to:
  /// **'If {brand} has been useful, an honest review helps other people decide whether to try it. It only takes a moment, and it\'s completely optional.'**
  String reviewPromptBody(String brand);

  /// Neutral confirm action on the review invitation; hands off to the OS-owned review flow. Compliance: no star or rating-value wording.
  ///
  /// In en, this message translates to:
  /// **'Leave a review'**
  String get reviewPromptConfirm;

  /// Neutral dismiss action on the review invitation. Declining simply closes the dialog; nothing is gated and no consolation feedback form is shown (no sentiment routing).
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get reviewPromptDismiss;

  /// Title of the dismissible banner shown when a newer app version is advertised by the owner-hosted version check.
  ///
  /// In en, this message translates to:
  /// **'Update available'**
  String get updateAvailableTitle;

  /// Body of the soft-update banner. {brand} is the product name, held constant across locales. Used when the hosted version JSON carries no custom message.
  ///
  /// In en, this message translates to:
  /// **'A new version of {brand} is ready to install.'**
  String updateAvailableBody(String brand);

  /// Title of the full-screen forced-update gate shown when the installed version is below the owner-declared minimum.
  ///
  /// In en, this message translates to:
  /// **'Update required'**
  String get updateRequiredTitle;

  /// Body of the forced-update gate. {brand} is the product name, held constant across locales. Used when the hosted version JSON carries no custom message.
  ///
  /// In en, this message translates to:
  /// **'This version of {brand} is out of date. Update it to keep going.'**
  String updateRequiredBody(String brand);

  /// Action on the update banner/gate that opens the public store page for the app.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateAction;

  /// Dismiss action on the soft-update banner. Dismissal is remembered per advertised version so the same version is not re-prompted.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get updateNotNow;

  /// Snackbar shown when the device could not open the public store URL from the update prompt.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the store page.'**
  String get updateOpenStoreFailed;

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

  /// Screen-reader label for the confidence bar, e.g. Confidence: 82 percent.
  ///
  /// In en, this message translates to:
  /// **'{label}: {percent} percent'**
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

  /// Tooltip and screen-reader label for the back-navigation chevron in the top navigation bar.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// Generic Delete label, used in the delete-confirmation dialog action and the swipe-to-delete background.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// Spoken value for a date or time picker field that has no value selected yet.
  ///
  /// In en, this message translates to:
  /// **'not set'**
  String get commonNotSet;

  /// Screen-reader label for a read-only picker field, combining its label and current value (or the 'not set' placeholder).
  ///
  /// In en, this message translates to:
  /// **'{label}, {value}'**
  String fieldValueSemantic(String label, String value);

  /// Bottom tab label for the New Calculation tab.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get navNew;

  /// Bottom tab label for the History tab.
  ///
  /// In en, this message translates to:
  /// **'HISTORY'**
  String get navHistory;

  /// Bottom tab label for the Settings tab.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get navSettings;

  /// Eyebrow on the calculation-flow stepper showing the current step out of the total, e.g. STEP 2 OF 4.
  ///
  /// In en, this message translates to:
  /// **'STEP {current} OF {total}'**
  String stepperStep(int current, int total);

  /// Screen-reader progress value for the stepper bar, e.g. 50 percent.
  ///
  /// In en, this message translates to:
  /// **'{percent} percent'**
  String stepperPercent(int percent);

  /// Top-navigation title shown across the stepped calculation flow (birth details, time window, life events, confirm).
  ///
  /// In en, this message translates to:
  /// **'New Calculation'**
  String get calcFlowTitle;

  /// Screen-reader label for the settings (gear) button in the home screen top bar.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get homeSettingsButton;

  /// Shown on the home screen when the saved-history stream fails to load. {error} is the raw error detail.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load your history.\n{error}'**
  String homeHistoryLoadError(String error);

  /// Empty-state title on the home screen when no calculations have been saved.
  ///
  /// In en, this message translates to:
  /// **'No calculations yet.'**
  String get homeEmptyTitle;

  /// Empty-state body on the home screen encouraging the first calculation.
  ///
  /// In en, this message translates to:
  /// **'Run your first one to see results here.'**
  String get homeEmptyBody;

  /// Call-to-action on the empty home screen that starts a new calculation.
  ///
  /// In en, this message translates to:
  /// **'New Calculation'**
  String get homeNewCalculation;

  /// Section heading above the list of saved calculations on the home screen.
  ///
  /// In en, this message translates to:
  /// **'Past calculations'**
  String get homePastCalculations;

  /// Fallback name for a saved calculation that has no user-provided label.
  ///
  /// In en, this message translates to:
  /// **'My calculation'**
  String get homeDefaultLabel;

  /// Title of the confirmation dialog shown before deleting a saved calculation.
  ///
  /// In en, this message translates to:
  /// **'Delete this calculation?'**
  String get historyDeleteTitle;

  /// Body of the delete-confirmation dialog. {label} is the calculation's name.
  ///
  /// In en, this message translates to:
  /// **'This removes \"{label}\" from your history. The original data isn\'t kept anywhere else.'**
  String historyDeleteBody(String label);

  /// Snackbar confirming a saved calculation was deleted. {label} is the calculation's name.
  ///
  /// In en, this message translates to:
  /// **'\"{label}\" deleted.'**
  String historyDeletedSnack(String label);

  /// Snackbar shown when deleting a saved calculation failed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete this entry.'**
  String get historyDeleteFailedSnack;

  /// Primary button on recoverable error screens (timeout, no internet, server, rate limit, malformed response) that retries the calculation.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get errorTryAgain;

  /// Primary button on the bad-request error screen that returns to the confirmation step to fix the draft.
  ///
  /// In en, this message translates to:
  /// **'Review my draft'**
  String get errorReviewDraft;

  /// Title of the timeout error screen.
  ///
  /// In en, this message translates to:
  /// **'Calculation timed out'**
  String get errorTimeoutTitle;

  /// Body of the timeout error screen.
  ///
  /// In en, this message translates to:
  /// **'The calculation didn\'t finish in time. Public Wi-Fi can be slow. Try again in a moment.'**
  String get errorTimeoutBody;

  /// Title of the no-internet error screen.
  ///
  /// In en, this message translates to:
  /// **'Can\'t reach the network'**
  String get errorNoInternetTitle;

  /// Body of the no-internet error screen.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline, or your network is blocking the request. Reconnect and try again.'**
  String get errorNoInternetBody;

  /// Title of the bad-request error screen.
  ///
  /// In en, this message translates to:
  /// **'Something looked off in the data'**
  String get errorBadRequestTitle;

  /// Body of the bad-request error screen.
  ///
  /// In en, this message translates to:
  /// **'Something in your birth date, time window, or events couldn\'t be processed. Double-check them, then try again.'**
  String get errorBadRequestBody;

  /// Title of the unauthorized (401) error screen.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t complete the calculation'**
  String get errorUnauthorizedTitle;

  /// Body of the unauthorized (401) error screen.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t complete this calculation right now. Try again in a moment, or switch on Demo mode to keep exploring with sample data.'**
  String get errorUnauthorizedBody;

  /// Title of the error screen shown when a live calculation can't start.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t start the calculation'**
  String get errorMissingApiKeyTitle;

  /// Body of the error screen shown when a live calculation can't start.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t start a live calculation right now. Try again in a moment, or switch on Demo mode to try the app with sample data.'**
  String get errorMissingApiKeyBody;

  /// Title of the server (5xx) error screen.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorServerTitle;

  /// Body of the server (5xx) error screen.
  ///
  /// In en, this message translates to:
  /// **'The calculation couldn\'t be completed just now. It may be temporary. Try again in a little while.'**
  String get errorServerBody;

  /// Title of the rate-limit (HTTP 429) error screen.
  ///
  /// In en, this message translates to:
  /// **'Calculation limit reached'**
  String get errorRateLimitedTitle;

  /// Body of the rate-limit (HTTP 429) error screen. Offers waiting and retrying, or switching to demo mode. 'Demo mode' matches its label elsewhere in the app.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached the calculation limit for now. Wait a little and try again, or switch on Demo mode to keep exploring offline.'**
  String get errorRateLimitedBody;

  /// Primary button on the rate-limit error screen. Switches the draft and the persisted default to Demo mode and re-enters the flow offline.
  ///
  /// In en, this message translates to:
  /// **'Use Demo Mode'**
  String get errorRateLimitedUseDemo;

  /// Secondary button on the rate-limit error screen. Opens Settings so the user can add their own Astrology API key. Must not read as a purchase or signup prompt.
  ///
  /// In en, this message translates to:
  /// **'Enter My API Key'**
  String get errorRateLimitedEnterKey;

  /// Body of the rate-limit error screen when the device-local free quota is exhausted. {resetDetail} is either an empty string or a leading space followed by the localized errorRateLimitedResetAt sentence. No purchase or signup wording.
  ///
  /// In en, this message translates to:
  /// **'Your free live quota is used up.{resetDetail} Switch to Demo Mode to keep exploring, or add your own API key in Settings.'**
  String errorRateLimitedLocalQuotaBody(String resetDetail);

  /// Sentence naming when a rate limit resets. {resetTime} is a locale-independent UTC stamp formatted as yyyy-MM-dd HH:mm; the trailing 'UTC' label stays with the sentence.
  ///
  /// In en, this message translates to:
  /// **'Resets at {resetTime} UTC.'**
  String errorRateLimitedResetAt(String resetTime);

  /// Sentence appended to the rate-limit body when the server reported a retry-after delay. {duration} is the localized coarse wait from errorRateLimitedRetryMinutes or errorRateLimitedRetryHours.
  ///
  /// In en, this message translates to:
  /// **'You can try again in about {duration}.'**
  String errorRateLimitedRetryAfter(String duration);

  /// Coarse wait estimate in minutes used inside errorRateLimitedRetryAfter. Sub-minute waits are rounded up to 1 before formatting.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute} other{{count} minutes}}'**
  String errorRateLimitedRetryMinutes(int count);

  /// Coarse wait estimate in hours used inside errorRateLimitedRetryAfter. Minutes are rounded up to whole hours before formatting.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour} other{{count} hours}}'**
  String errorRateLimitedRetryHours(int count);

  /// Title of the malformed-response error screen.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t read the response'**
  String get errorMalformedTitle;

  /// Body of the malformed-response error screen.
  ///
  /// In en, this message translates to:
  /// **'The response didn\'t match what this build expects. Try again, or run a demo calculation while we look into it.'**
  String get errorMalformedBody;

  /// Top-navigation title of the Settings screen.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Settings section heading for calculation defaults. Rendered in uppercase.
  ///
  /// In en, this message translates to:
  /// **'Calculation defaults'**
  String get settingsSectionDefaults;

  /// Settings section heading for the time-format choice. Rendered in uppercase.
  ///
  /// In en, this message translates to:
  /// **'Time format'**
  String get settingsSectionTimeFormat;

  /// Settings section heading for the user-entered Astrology API key. Rendered in uppercase.
  ///
  /// In en, this message translates to:
  /// **'API key'**
  String get settingsSectionApiKey;

  /// Settings section heading for the destructive data actions. Rendered in uppercase.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get settingsSectionData;

  /// Settings section heading for the about/legal links. Rendered in uppercase.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsSectionAbout;

  /// Label for the demo-mode default toggle in Settings.
  ///
  /// In en, this message translates to:
  /// **'Demo mode'**
  String get settingsDemoModeLabel;

  /// Helper text under the demo-mode toggle in Settings.
  ///
  /// In en, this message translates to:
  /// **'Run calculations with sample data (free, no network).'**
  String get settingsDemoModeHelper;

  /// Radio option for 12-hour time format. The sample time 7:14 AM is illustrative and kept stable.
  ///
  /// In en, this message translates to:
  /// **'12-hour  (7:14 AM)'**
  String get settingsTimeFormat12;

  /// Radio option for 24-hour time format. The sample time 07:14 is illustrative and kept stable.
  ///
  /// In en, this message translates to:
  /// **'24-hour  (07:14)'**
  String get settingsTimeFormat24;

  /// Settings section heading for the interface-language choice. Rendered in uppercase.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsSectionLanguage;

  /// Radio option that defers the interface language to the device's language, with a deterministic English fallback when the device language is unsupported.
  ///
  /// In en, this message translates to:
  /// **'Automatic (device language)'**
  String get settingsLanguageAuto;

  /// Radio option label for English. An endonym (a language shown in its own name) held constant across all locales, like the brand name.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// Radio option label for German. An endonym held constant across all locales.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get settingsLanguageGerman;

  /// Radio option label for Spanish. An endonym held constant across all locales.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get settingsLanguageSpanish;

  /// Radio option label for French. An endonym held constant across all locales.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get settingsLanguageFrench;

  /// Radio option label for Portuguese. An endonym held constant across all locales.
  ///
  /// In en, this message translates to:
  /// **'Português'**
  String get settingsLanguagePortuguese;

  /// Radio option label for Ukrainian. An endonym held constant across all locales.
  ///
  /// In en, this message translates to:
  /// **'Українська'**
  String get settingsLanguageUkrainian;

  /// Helper text in the Settings API-key card for users who already hold an Astrology API key. Must not read as a purchase or signup prompt.
  ///
  /// In en, this message translates to:
  /// **'Already have an Astrology API key? Add it here.'**
  String get settingsApiKeyHelper;

  /// Short label before the public astrology-api.io URL in Settings and the API-key dialog.
  ///
  /// In en, this message translates to:
  /// **'Get a key at'**
  String get settingsApiKeyGetLink;

  /// Status line in the Settings API-key card when a key is stored. The key itself is never echoed back into the UI.
  ///
  /// In en, this message translates to:
  /// **'API key added'**
  String get settingsApiKeyConfigured;

  /// Button in the Settings API-key card that opens the add-key dialog.
  ///
  /// In en, this message translates to:
  /// **'Add key'**
  String get settingsApiKeyAdd;

  /// Button in the Settings API-key card that deletes the stored key.
  ///
  /// In en, this message translates to:
  /// **'Remove key'**
  String get settingsApiKeyRemove;

  /// Label of the obscured text field in the add-key dialog. 'Astrology API' is the external provider name, held constant across locales.
  ///
  /// In en, this message translates to:
  /// **'Astrology API key'**
  String get settingsApiKeyFieldLabel;

  /// Confirm button in the add-key dialog that stores the entered key.
  ///
  /// In en, this message translates to:
  /// **'Save key'**
  String get settingsApiKeySave;

  /// Destructive button in Settings that opens the delete-all-data confirmation sheet.
  ///
  /// In en, this message translates to:
  /// **'Delete all data'**
  String get settingsDeleteAllData;

  /// Helper text under the Delete all data button in Settings.
  ///
  /// In en, this message translates to:
  /// **'Removes all calculations and events from this device. Cannot be undone.'**
  String get settingsDeleteAllHelper;

  /// Label for the Privacy Policy row in the Settings about section.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacyPolicy;

  /// Label for the opt-in 'Invite a friend' row in the Settings about section. Opens the native share sheet with a privacy-safe, branded invite and no referral code, reward, contacts access, or tracking.
  ///
  /// In en, this message translates to:
  /// **'Invite a friend'**
  String get settingsInviteFriend;

  /// Title of the delete-all-data confirmation sheet.
  ///
  /// In en, this message translates to:
  /// **'Delete all data?'**
  String get deleteAllTitle;

  /// Body of the delete-all-data sheet shown before the saved-calculation count is known.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete every calculation, event, and setting on this device. Cannot be undone.'**
  String get deleteAllBodyGeneric;

  /// Body of the delete-all-data sheet, naming how many saved calculations will be deleted.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{This will permanently delete 1 calculation and every saved event and setting on this device. Cannot be undone.} other{This will permanently delete {count} calculations and every saved event and setting on this device. Cannot be undone.}}'**
  String deleteAllBodyCount(int count);

  /// Snackbar shown when deleting all data failed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete data. Try again.'**
  String get deleteAllFailedSnack;

  /// Top-navigation title of the in-app privacy policy screen.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacyTitle;

  /// Privacy section heading about local storage. {brand} is the product name, held constant across locales.
  ///
  /// In en, this message translates to:
  /// **'What {brand} stores'**
  String privacyStoresTitle(String brand);

  /// Privacy section body about local storage. {brand} is the product name, held constant across locales.
  ///
  /// In en, this message translates to:
  /// **'Your birth date, birth city, life events, and results stay on this device. Nothing is uploaded to a {brand} account, because we do not run user accounts. Deleting the app removes this data.'**
  String privacyStoresBody(String brand);

  /// Privacy section heading about demo mode.
  ///
  /// In en, this message translates to:
  /// **'Demo mode'**
  String get privacyDemoTitle;

  /// Privacy section body about offline demo calculations.
  ///
  /// In en, this message translates to:
  /// **'Demo calculations run entirely on this device. They make no network calls. Demo results are marked with a DEMO pill so they do not get mixed up with live results.'**
  String get privacyDemoBody;

  /// Privacy section heading about live (networked) calculations.
  ///
  /// In en, this message translates to:
  /// **'Live calculations'**
  String get privacyLiveTitle;

  /// Privacy section body about what a live calculation transmits. {brand} is the product name, held constant across locales.
  ///
  /// In en, this message translates to:
  /// **'A live (non-demo) calculation sends your birth date and approximate time, birthplace coordinates, and life-event descriptions to a third-party calculation provider over HTTPS. City search may also use a geocoding service to find birthplace coordinates. The data is used only to calculate your rectified birth time. It is not used to build a profile and is not tied to any {brand} account, because there are no accounts.'**
  String privacyLiveBody(String brand);

  /// Privacy section heading about deleting local data.
  ///
  /// In en, this message translates to:
  /// **'Deleting your data'**
  String get privacyDeleteTitle;

  /// Privacy section body about the Delete all data action.
  ///
  /// In en, this message translates to:
  /// **'The Settings screen has a \"Delete all data\" action that wipes the local database and every preference stored on this device. The wipe completes before the action returns; the app then sends you back to onboarding so you can confirm the reset.'**
  String get privacyDeleteBody;

  /// Privacy section heading about analytics and crash reporting.
  ///
  /// In en, this message translates to:
  /// **'Analytics and crash reporting'**
  String get privacyAnalyticsTitle;

  /// Privacy section body about analytics and crash reporting. {brand} is the product name, held constant across locales.
  ///
  /// In en, this message translates to:
  /// **'This release of {brand} ships without an analytics SDK and without crash reporting. If a future release adds either, it will be disclosed here and limited to anonymous, non-identifying data.'**
  String privacyAnalyticsBody(String brand);

  /// Demo evidence explanation, strong match (rank 1). Astrology prose shown on the evidence screen for an offline sample result. Sensitive register: use indication wording, not proof wording.
  ///
  /// In en, this message translates to:
  /// **'A timed Venus return aligned with the candidate window, consistent with a partnership event.'**
  String get demoEvidenceStrongVenus;

  /// Demo evidence explanation, strong match (rank 2). Astrology prose shown on the evidence screen for an offline sample result. Sensitive register: use indication wording, not proof wording.
  ///
  /// In en, this message translates to:
  /// **'Saturn crossed the 10th-house cusp inside the window, a classic timing signature for a career pivot.'**
  String get demoEvidenceStrongSaturn;

  /// Demo evidence explanation, moderate match (rank 1). Astrology prose shown on the evidence screen for an offline sample result. Sensitive register: use indication wording, not proof wording.
  ///
  /// In en, this message translates to:
  /// **'Jupiter passed near the 4th-house cusp; moderate support for a home / relocation event in this window.'**
  String get demoEvidenceModerateJupiter;

  /// Demo evidence explanation, moderate match (rank 2). Astrology prose shown on the evidence screen for an offline sample result. Sensitive register: use indication wording, not proof wording.
  ///
  /// In en, this message translates to:
  /// **'A solar arc to Mars sat within tolerance of the window, plausible for the reported event but not exclusive to it.'**
  String get demoEvidenceModerateSolarArc;

  /// Demo evidence explanation, weak match. Astrology prose shown on the evidence screen for an offline sample result. Sensitive register: use indication wording, not proof wording.
  ///
  /// In en, this message translates to:
  /// **'Mercury was within wide orb of the relevant cusp; insufficient to confirm timing on its own.'**
  String get demoEvidenceWeakMercury;

  /// Demo evidence explanation, no match. Astrology prose shown on the evidence screen for an offline sample result. Sensitive register: use indication wording, not proof wording.
  ///
  /// In en, this message translates to:
  /// **'No primary aspect within tolerance of the candidate window. This event neither supports nor contradicts the result.'**
  String get demoEvidenceNoMatch;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'pt',
    'uk',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
