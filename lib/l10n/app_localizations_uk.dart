// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get commonContinue => 'Далі';

  @override
  String get commonNext => 'Далі';

  @override
  String get commonCancel => 'Скасувати';

  @override
  String get onboardingSkip => 'Пропустити';

  @override
  String get onboardingSlide1Title =>
      'Ваша натальна карта залежить від точного часу народження.';

  @override
  String onboardingSlide1Body(String brand) {
    return 'Більшість знають лише приблизний час або зовсім нічого. $brand звужує його за допомогою подій з вашого життя.';
  }

  @override
  String onboardingSlide2Title(String brand) {
    return 'Як працює $brand';
  }

  @override
  String get onboardingSlide2Body =>
      '1. Введіть дату народження та приблизний час.\n2. Додайте події, які пам\'ятаєте: переїзди, стосунки, зміни роботи тощо.\n3. Ми обчислюємо найімовірніший час народження та пояснюємо чому.\n\nЧим більше подій ви додасте, тим яснішим може бути результат.';

  @override
  String get onboardingSlide3Title => 'Готові дізнатися свій час народження?';

  @override
  String get onboardingSlide3Body =>
      'Демонстрація покаже вам зразок результату без потреби в акаунті.';

  @override
  String get onboardingTryDemo => 'Спробувати демо';

  @override
  String get onboardingStartReal => 'Розпочати реальний розрахунок';

  @override
  String onboardingPageLabel(int page, int count) {
    return 'Сторінка $page з $count';
  }

  @override
  String get birthDataTitle => 'Дані про народження';

  @override
  String get birthDataDateLabel => 'Дата народження';

  @override
  String get birthDataDatePlaceholder => 'Оберіть дату';

  @override
  String get birthDataCityLabel => 'Місто народження';

  @override
  String get birthDataCityHint => 'Почніть вводити місто';

  @override
  String get birthDataLabelLabel => 'Назва (необов\'язково)';

  @override
  String get birthDataLabelHelper =>
      'Відображається у вашому списку розрахунків.';

  @override
  String get birthDataLabelHint => 'напр. Мій час народження';

  @override
  String get birthDataSearching => 'Пошук…';

  @override
  String get birthDataNoMatches =>
      'Місто не знайдено. Спробуйте іншу транслітерацію.';

  @override
  String get timeWindowTitle => 'Ви знаєте приблизний час народження?';

  @override
  String get timeWindowModeApprox => 'Маю приблизний час';

  @override
  String get timeWindowModeUnknown => 'Не маю уявлення';

  @override
  String get timeWindowApproxTimeLabel => 'Приблизний час';

  @override
  String get timeWindowChooseTime => 'Оберіть час';

  @override
  String get timeWindowTimePickerHelp => 'Приблизний час народження';

  @override
  String get timeWindowSearchWindow => 'Вікно пошуку';

  @override
  String timeWindowDeltaMinutes(int minutes) {
    return '± $minutes хв';
  }

  @override
  String timeWindowDeltaHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '± $hours год',
      one: '± 1 година',
    );
    return '$_temp0';
  }

  @override
  String timeWindowRangeCopy(String start, String end) {
    return 'Пошук виконуватиметься між $start та $end.';
  }

  @override
  String get timeWindowApproxHint =>
      'Ширше вікно дає більше кандидатів, але може знизити точність.';

  @override
  String get timeWindowUnknownBody =>
      'Пошук виконуватиметься в усьому 24-годинному діапазоні. Це може дати більше кандидатів із нижчою впевненістю.';

  @override
  String get timeWindowUnknownHint =>
      'Додавання більшої кількості подій допоможе звузити результат.';

  @override
  String get lifeEventsTitle => 'Життєві події';

  @override
  String lifeEventsTitleWithCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Життєві події  ($count додано)',
      one: 'Життєві події  (1 додана)',
    );
    return '$_temp0';
  }

  @override
  String get lifeEventsAddEvent => 'Додати подію';

  @override
  String get lifeEventsAddFirstEvent => 'Додати першу подію';

  @override
  String get lifeEventsContinueDemo => 'Далі (демо)';

  @override
  String get lifeEventsEmptyBody =>
      'Додайте пам\'ятні події з вашого життя. Чим більше, тим краще.';

  @override
  String get lifeEventsGuidanceEmpty =>
      'Додайте не менше 5 подій для реального розрахунку. Для демо достатньо 3.';

  @override
  String get lifeEventsNoEvents => 'Подій ще немає.';

  @override
  String lifeEventsGuidanceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count подій. Додайте 5+ для точнішого реального розрахунку.',
      one: '1 подія. Додайте 5+ для точнішого реального розрахунку.',
    );
    return '$_temp0';
  }

  @override
  String get eventCategoryMarriage => 'Шлюб / Партнерство';

  @override
  String get eventCategoryDivorce => 'Розлучення / Розставання';

  @override
  String get eventCategoryCareerChange => 'Зміна кар\'єри';

  @override
  String get eventCategoryJobLoss => 'Втрата роботи';

  @override
  String get eventCategoryRelocation => 'Переїзд (значний)';

  @override
  String get eventCategoryChildBirth => 'Народження дитини';

  @override
  String get eventCategoryFamilyDeath => 'Смерть члена родини';

  @override
  String get eventCategoryIllness => 'Серйозна хвороба / операція';

  @override
  String get eventCategoryAccident => 'Нещасний випадок або травма';

  @override
  String get eventCategoryEducation => 'Освітня подія';

  @override
  String get eventCategoryFinancial => 'Фінансовий перелом';

  @override
  String get eventCategoryOther => 'Інше';

  @override
  String get confirmationTitle => 'Підтвердіть розрахунок';

  @override
  String get confirmationBackToEdit => 'Повернутися до редагування';

  @override
  String get confirmationCalculate => 'Розрахувати';

  @override
  String get confirmationCalculateDemo => 'Розрахувати (демо)';

  @override
  String get confirmationDatePending => 'Дата не обрана';

  @override
  String get confirmationRowDate => 'Дата';

  @override
  String get confirmationRowCity => 'Місто';

  @override
  String get confirmationRowLabel => 'Назва';

  @override
  String get confirmationTimeWindow => 'Часове вікно';

  @override
  String get confirmationFullDayWindow => 'Повний 24-годинний діапазон';

  @override
  String confirmationWindowApprox(String time, String window) {
    return '$time ($window)';
  }

  @override
  String confirmationLifeEventsCount(int count) {
    return 'Життєві події ($count)';
  }

  @override
  String get confirmationDemoNote =>
      'Демо-режим: буде показано зразок результату без мережевого запиту.';

  @override
  String get confirmationLiveDisclosure =>
      'Живий розрахунок надсилає дату народження, приблизний час, координати місця народження та життєві події сторонньому постачальнику розрахунків через HTTPS. Демо-режим залишається офлайн.';

  @override
  String get loadingTitle => 'Обчислення найімовірнішого часу народження…';

  @override
  String get loadingDemoTitle => 'Виконується демо-розрахунок…';

  @override
  String get loadingRotating1 => 'Аналіз життєвих подій…';

  @override
  String get loadingRotating2 => 'Зіставлення планетарних транзитів…';

  @override
  String get loadingRotating3 => 'Ранжування кандидатів…';

  @override
  String get loadingTakesUnder => 'Зазвичай це займає менше 10 секунд.';

  @override
  String get addEventAddTitle => 'Додати життєву подію';

  @override
  String get addEventEditTitle => 'Редагувати життєву подію';

  @override
  String get addEventSelectCategory => 'Оберіть категорію';

  @override
  String get addEventCategoryLabel => 'Категорія';

  @override
  String get addEventChooseCategory => 'Оберіть категорію';

  @override
  String get addEventMonth => 'Місяць';

  @override
  String get addEventNoMonth => 'Без місяця';

  @override
  String get addEventYear => 'Рік';

  @override
  String get addEventMonthOptional => 'Місяць необов\'язковий.';

  @override
  String get addEventDescriptionLabel => 'Опис (необов\'язково)';

  @override
  String get addEventDescriptionHint => 'Будь-що, що допоможе уточнити час';

  @override
  String addEventCharCount(int current, int max) {
    return '$current / $max';
  }

  @override
  String get addEventSaveChanges => 'Зберегти зміни';

  @override
  String get commonBackToHistory => 'Назад до історії';

  @override
  String get commonDismiss => 'Закрити';

  @override
  String get resultTitle => 'Результат';

  @override
  String get resultNotFoundTitle => 'Результат не знайдено.';

  @override
  String get resultNotFoundBody =>
      'Можливо, його видалено з вашої історії. Відкрийте збережений розрахунок або розпочніть новий.';

  @override
  String resultRisingSign(String sign) {
    return 'Асцендент: $sign';
  }

  @override
  String get resultSampleData => '(зразок даних)';

  @override
  String get resultLowConfidenceTitle => 'Результат із низькою впевненістю';

  @override
  String get resultLowConfidenceTipEvents =>
      'Додайте більше датованих життєвих подій.';

  @override
  String get resultLowConfidenceTipReviewInput =>
      'Перевірте дату народження, місто та приблизний час.';

  @override
  String get resultLowConfidenceTipWiderWindow =>
      'Спробуйте ширше вікно часу народження.';

  @override
  String get resultConfidenceExplainerTitle => 'Що означає цей відсоток?';

  @override
  String get resultConfidenceExplainerBody =>
      'Впевненість є оцінкою. Вона показує, наскільки ваші датовані життєві події підтверджують цей кандидатний час порівняно з іншими кандидатами у вибраному вікні часу народження.';

  @override
  String get resultConfidenceExplainerMethod =>
      'Метод: кожен кандидатний час оцінюється за вашими подіями за допомогою транзитів і прогресій; вищі бали означають більш імовірний збіг.';

  @override
  String get resultOtherCandidates => 'Інші кандидати';

  @override
  String get resultSeeEvidence => 'Як ми це визначили';

  @override
  String get resultShare => 'Поділитися результатом';

  @override
  String get resultCopiedToClipboard => 'Скопійовано в буфер обміну';

  @override
  String get resultShareImage => 'Поділитися зображенням';

  @override
  String get resultShareImageUnavailable =>
      'Не вдалося відкрити вікно обміну для зображення.';

  @override
  String get resultDemoShareLabel => 'Поділитися цим зразком';

  @override
  String get resultDemoShareTitle => 'Сподобався зразок? Поділіться ним.';

  @override
  String get resultDemoShareButton => 'Поділитися зразком';

  @override
  String get resultFriendShareLabel => 'Поділитися з другом';

  @override
  String get resultFriendShareTitle =>
      'Знаєте когось, хто не знає свого часу народження?';

  @override
  String get resultFriendShareBody =>
      'Поділіться з цією людиною TrueRise. Поширений результат ніколи не містить дати народження, місця народження або життєвих подій.';

  @override
  String get resultFriendShareButton => 'Поділитися з другом';

  @override
  String get resultSharePreviewTitle => 'Що буде поширено';

  @override
  String get resultFeedbackLabel => 'Відгук про результат';

  @override
  String get resultFeedbackTitle => 'Цей час здається вам правдоподібним?';

  @override
  String get resultFeedbackYes => 'Так';

  @override
  String get resultFeedbackNotSure => 'Не впевнений';

  @override
  String get resultFeedbackNo => 'Ні';

  @override
  String get resultFeedbackSaved => 'Дякуємо, збережено.';

  @override
  String get shareCardTagline => 'Ректифікація часу народження';

  @override
  String shareCardConfidence(int percent) {
    return '$percent% впевненості';
  }

  @override
  String shareCopyHeadline(String brand) {
    return 'Мій результат ректифікації $brand:';
  }

  @override
  String shareCopyTagline(String brand) {
    return 'Розраховано з $brand: ректифікація часу народження';
  }

  @override
  String shareCopyGetApp(String url) {
    return 'Дізнайтеся свій час народження: $url';
  }

  @override
  String inviteCopyHeadline(String brand) {
    return 'Спробуйте $brand: оцініть свій час народження';
  }

  @override
  String get inviteCopyBody =>
      'Застосунок оцінює імовірний час народження на основі кількох подій з вашого життя.';

  @override
  String inviteCopyGetApp(String url) {
    return 'Завантажити застосунок: $url';
  }

  @override
  String get resultSaveToHistory => 'Зберегти в історію';

  @override
  String get resultSaved => 'Збережено ✓';

  @override
  String get resultDemoNudgeLabel => 'Запрошення до реального розрахунку';

  @override
  String get resultDemoNudgeTitle => 'Це була демонстрація.';

  @override
  String get resultDemoNudgeBody =>
      'Виконайте реальний розрахунок із вашими власними даними про народження.';

  @override
  String get resultStartNewCalculation => 'Розпочати новий розрахунок';

  @override
  String reviewPromptTitle(String brand) {
    return 'Оцінити $brand?';
  }

  @override
  String reviewPromptBody(String brand) {
    return 'Якщо $brand виявився вам корисним, чесний відгук допоможе іншим вирішити, чи варто його спробувати. Це займе лише хвилину, і це повністю за вашим бажанням.';
  }

  @override
  String get reviewPromptConfirm => 'Залишити відгук';

  @override
  String get reviewPromptDismiss => 'Пізніше';

  @override
  String get updateAvailableTitle => 'Доступне оновлення';

  @override
  String updateAvailableBody(String brand) {
    return 'Нова версія $brand готова до встановлення.';
  }

  @override
  String get updateRequiredTitle => 'Необхідне оновлення';

  @override
  String updateRequiredBody(String brand) {
    return 'Ця версія $brand застаріла. Оновіть її, щоб продовжити.';
  }

  @override
  String get updateAction => 'Оновити';

  @override
  String get updateNotNow => 'Пізніше';

  @override
  String get updateOpenStoreFailed => 'Не вдалося відкрити сторінку магазину.';

  @override
  String get evidenceTitle => 'Докази';

  @override
  String get evidenceNotFoundTitle => 'Докази не знайдено.';

  @override
  String get evidenceNotFoundBody =>
      'Основний результат міг бути видалений. Поверніться до вашої історії, щоб вибрати інший розрахунок.';

  @override
  String evidenceWhyTitle(String time) {
    return 'Чому $time?';
  }

  @override
  String get evidenceNoEvidence =>
      'Для цього результату немає детальних доказів по подіях.';

  @override
  String evidenceStrongSummary(int strong, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$strong з $total подій чітко підтвердили цей час.',
      one: '$strong з 1 події чітко підтвердила цей час.',
    );
    return '$_temp0';
  }

  @override
  String get evidenceEventFallback => 'Подія';

  @override
  String get heroResultEyebrow => 'НАЙ​ІМОВІРНІШИЙ ЧАС НАРОДЖЕННЯ';

  @override
  String heroResultSemantic(String eyebrow, String time, String risingSign) {
    return '$eyebrow: $time, $risingSign';
  }

  @override
  String get confidenceBarLabel => 'Впевненість';

  @override
  String confidenceBarSemantic(String label, int percent) {
    return '$label: $percent відсотків';
  }

  @override
  String get matchStrengthStrong => 'СИЛЬНИЙ';

  @override
  String get matchStrengthModerate => 'ПОМІРНИЙ';

  @override
  String get matchStrengthWeak => 'СЛАБКИЙ';

  @override
  String get matchStrengthNone => 'НЕМАЄ ЗБІГУ';

  @override
  String matchStrengthSemantic(String strength) {
    String _temp0 = intl.Intl.selectLogic(
      strength,
      {
        'strong': 'Сила збігу: сильна',
        'moderate': 'Сила збігу: помірна',
        'weak': 'Сила збігу: слабка',
        'none': 'Збіг відсутній',
        'other': 'Сила збігу',
      },
    );
    return '$_temp0';
  }

  @override
  String candidateCardSemantic(String time, String risingSign, int percent) {
    return 'Кандидат $time, $risingSign, впевненість $percent відсотків';
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
            '$label, $date, $time $risingSign, впевненість $percent відсотків, демо',
        'other':
            '$label, $date, $time $risingSign, впевненість $percent відсотків',
      },
    );
    return '$_temp0';
  }

  @override
  String evidenceCardSemantic(String category, String date, String strength) {
    String _temp0 = intl.Intl.selectLogic(
      strength,
      {
        'strong': 'збіг: сильний',
        'moderate': 'збіг: помірний',
        'weak': 'збіг: слабкий',
        'none': 'збіг відсутній',
        'other': 'збіг',
      },
    );
    return '$category, $date, $_temp0';
  }

  @override
  String get demoPillLabel => 'ДЕМО';

  @override
  String demoPillSemantic(String label) {
    return 'Значок $label розрахунку';
  }

  @override
  String eventCardSemantic(String category, String date) {
    return 'Подія: $category в $date';
  }

  @override
  String eventCardDeleteSemantic(String category) {
    return 'Видалити подію $category';
  }

  @override
  String get commonBack => 'Назад';

  @override
  String get commonDelete => 'Видалити';

  @override
  String get commonNotSet => 'не встановлено';

  @override
  String fieldValueSemantic(String label, String value) {
    return '$label, $value';
  }

  @override
  String get navNew => 'НОВИЙ';

  @override
  String get navHistory => 'ІСТОРІЯ';

  @override
  String get navSettings => 'НАЛАШТУВАННЯ';

  @override
  String stepperStep(int current, int total) {
    return 'КРОК $current З $total';
  }

  @override
  String stepperPercent(int percent) {
    return '$percent відсотків';
  }

  @override
  String get calcFlowTitle => 'Новий розрахунок';

  @override
  String get homeSettingsButton => 'Налаштування';

  @override
  String homeHistoryLoadError(String error) {
    return 'Не вдалося завантажити вашу історію.\n$error';
  }

  @override
  String get homeEmptyTitle => 'Розрахунків ще немає.';

  @override
  String get homeEmptyBody => 'Виконайте перший, щоб побачити результати тут.';

  @override
  String get homeNewCalculation => 'Новий розрахунок';

  @override
  String get homePastCalculations => 'Попередні розрахунки';

  @override
  String get homeDefaultLabel => 'Мій розрахунок';

  @override
  String get historyDeleteTitle => 'Видалити цей розрахунок?';

  @override
  String historyDeleteBody(String label) {
    return 'Це видалить «$label» з вашої історії. Вихідні дані ніде більше не зберігаються.';
  }

  @override
  String historyDeletedSnack(String label) {
    return '«$label» видалено.';
  }

  @override
  String get historyDeleteFailedSnack => 'Не вдалося видалити цей запис.';

  @override
  String get errorTryAgain => 'Спробувати знову';

  @override
  String get errorReviewDraft => 'Переглянути чернетку';

  @override
  String get errorTimeoutTitle => 'Час очікування вичерпано';

  @override
  String get errorTimeoutBody =>
      'Розрахунок не завершився вчасно. Публічні мережі можуть бути повільними. Спробуйте ще раз за мить.';

  @override
  String get errorNoInternetTitle => 'Немає доступу до мережі';

  @override
  String get errorNoInternetBody =>
      'Ви офлайн або мережа блокує запит. Підключіться та спробуйте знову.';

  @override
  String get errorBadRequestTitle => 'У даних виявлено проблему';

  @override
  String get errorBadRequestBody =>
      'Щось у вашій даті народження, часовому вікні або подіях не вдалося обробити. Перевірте їх і спробуйте знову.';

  @override
  String get errorUnauthorizedTitle => 'Не вдалося завершити розрахунок';

  @override
  String get errorUnauthorizedBody =>
      'Наразі ми не можемо завершити цей розрахунок. Спробуйте за мить або увімкніть демо-режим, щоб продовжити дослідження з тестовими даними.';

  @override
  String get errorMissingApiKeyTitle => 'Не вдалося розпочати розрахунок';

  @override
  String get errorMissingApiKeyBody =>
      'Наразі ми не можемо розпочати живий розрахунок. Спробуйте за мить або увімкніть демо-режим, щоб ознайомитися з застосунком за допомогою тестових даних.';

  @override
  String get errorServerTitle => 'Щось пішло не так';

  @override
  String get errorServerBody =>
      'Розрахунок не вдалося завершити зараз. Можливо, це тимчасова проблема. Спробуйте знову за короткий час.';

  @override
  String get errorRateLimitedTitle => 'Досягнуто ліміт розрахунків';

  @override
  String get errorRateLimitedBody =>
      'Ви вичерпали ліміт розрахунків на зараз. Зачекайте трохи та спробуйте знову, або увімкніть демо-режим для офлайн-роботи.';

  @override
  String get errorRateLimitedUseDemo => 'Використати демо-режим';

  @override
  String get errorRateLimitedEnterKey => 'Ввести мій API-ключ';

  @override
  String errorRateLimitedLocalQuotaBody(String resetDetail) {
    return 'Ваш безкоштовний ліміт вичерпано.$resetDetail Перейдіть у демо-режим для подальшого дослідження або додайте власний API-ключ у налаштуваннях.';
  }

  @override
  String errorRateLimitedResetAt(String resetTime) {
    return 'Скидається о $resetTime UTC.';
  }

  @override
  String errorRateLimitedRetryAfter(String duration) {
    return 'Ви можете спробувати знову приблизно через $duration.';
  }

  @override
  String errorRateLimitedRetryMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count хвилин',
      one: '1 хвилину',
    );
    return '$_temp0';
  }

  @override
  String errorRateLimitedRetryHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count годин',
      one: '1 годину',
    );
    return '$_temp0';
  }

  @override
  String get errorMalformedTitle => 'Не вдалося прочитати відповідь';

  @override
  String get errorMalformedBody =>
      'Відповідь не відповідає очікуваному формату. Спробуйте знову або виконайте демо-розрахунок, поки ми розбираємось.';

  @override
  String get settingsTitle => 'Налаштування';

  @override
  String get settingsSectionDefaults => 'Стандарти розрахунку';

  @override
  String get settingsSectionTimeFormat => 'Формат часу';

  @override
  String get settingsSectionApiKey => 'API-ключ';

  @override
  String get settingsSectionData => 'Дані';

  @override
  String get settingsSectionAbout => 'Про застосунок';

  @override
  String get settingsDemoModeLabel => 'Демо-режим';

  @override
  String get settingsDemoModeHelper =>
      'Виконувати розрахунки з тестовими даними (безкоштовно, без мережі).';

  @override
  String get settingsTimeFormat12 => '12-годинний  (7:14 AM)';

  @override
  String get settingsTimeFormat24 => '24-годинний  (07:14)';

  @override
  String get settingsSectionLanguage => 'Мова';

  @override
  String get settingsLanguageAuto => 'Автоматично (мова пристрою)';

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
      'Вже маєте API-ключ Astrology? Додайте його тут.';

  @override
  String get settingsApiKeyGetLink => 'Отримайте ключ на';

  @override
  String get settingsApiKeyConfigured => 'API-ключ додано';

  @override
  String get settingsApiKeyAdd => 'Додати ключ';

  @override
  String get settingsApiKeyRemove => 'Видалити ключ';

  @override
  String get settingsApiKeyFieldLabel => 'API-ключ Astrology';

  @override
  String get settingsApiKeySave => 'Зберегти ключ';

  @override
  String get settingsDeleteAllData => 'Видалити всі дані';

  @override
  String get settingsDeleteAllHelper =>
      'Видаляє всі розрахунки та події з цього пристрою. Дію не можна скасувати.';

  @override
  String get settingsPrivacyPolicy => 'Політика конфіденційності';

  @override
  String get settingsInviteFriend => 'Запросити друга';

  @override
  String get deleteAllTitle => 'Видалити всі дані?';

  @override
  String get deleteAllBodyGeneric =>
      'Це назавжди видалить усі розрахунки, події та налаштування на цьому пристрої. Дію не можна скасувати.';

  @override
  String deleteAllBodyCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Це назавжди видалить $count розрахунки та всі збережені події й налаштування на цьому пристрої. Дію не можна скасувати.',
      one:
          'Це назавжди видалить 1 розрахунок та всі збережені події й налаштування на цьому пристрої. Дію не можна скасувати.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAllFailedSnack =>
      'Не вдалося видалити дані. Спробуйте ще раз.';

  @override
  String get privacyTitle => 'Конфіденційність';

  @override
  String privacyStoresTitle(String brand) {
    return 'Що зберігає $brand';
  }

  @override
  String privacyStoresBody(String brand) {
    return 'Дата народження, місто народження, життєві події та результати залишаються на цьому пристрої. Нічого не завантажується в акаунт $brand, оскільки ми не ведемо облікових записів. Видалення застосунку прибирає ці дані.';
  }

  @override
  String get privacyDemoTitle => 'Демо-режим';

  @override
  String get privacyDemoBody =>
      'Демо-розрахунки виконуються повністю на цьому пристрої. Мережеві запити не надсилаються. Демо-результати позначені значком ДЕМО, щоб їх не сплутали з живими результатами.';

  @override
  String get privacyLiveTitle => 'Живі розрахунки';

  @override
  String privacyLiveBody(String brand) {
    return 'Живий (не демо) розрахунок надсилає вашу дату народження та приблизний час, координати місця народження і описи ваших життєвих подій сторонньому постачальнику через HTTPS. Пошук міста також може використовувати сервіс геокодування, щоб знайти координати місця народження. Ці дані використовуються лише для обчислення ректифікованого часу народження. Вони не використовуються для створення профілю і не прив\'язані до акаунту $brand, оскільки акаунтів немає.';
  }

  @override
  String get privacyDeleteTitle => 'Видалення ваших даних';

  @override
  String get privacyDeleteBody =>
      'На екрані «Налаштування» є дія «Видалити всі дані», яка очищає локальну базу даних і всі налаштування, збережені на цьому пристрої. Очищення завершується до повернення дії; застосунок після цього повертає вас до онбордингу для підтвердження скидання.';

  @override
  String get privacyAnalyticsTitle => 'Аналітика та звіти про збої';

  @override
  String privacyAnalyticsBody(String brand) {
    return 'Цей випуск $brand постачається без SDK аналітики та без звітів про збої. Якщо майбутній випуск додасть будь-яке з них, це буде розкрито тут і обмежено анонімними, не ідентифікуючими даними.';
  }

  @override
  String get demoEvidenceStrongVenus =>
      'Синхронне повернення Венери збіглося з вікном кандидата і відповідає події у партнерській сфері.';

  @override
  String get demoEvidenceStrongSaturn =>
      'Сатурн перетнув вершину 10-го будинку в межах вікна, класична часова сигнатура для кар\'єрного повороту.';

  @override
  String get demoEvidenceModerateJupiter =>
      'Юпітер пройшов поблизу вершини 4-го будинку; помірне підтвердження для домашньої події або переїзду у цьому вікні.';

  @override
  String get demoEvidenceModerateSolarArc =>
      'Сонячна дуга до Марса перебувала в межах допуску вікна. Це правдоподібно для зазначеної події, але не виключно для неї.';

  @override
  String get demoEvidenceWeakMercury =>
      'Меркурій знаходився в широкому орбісі від відповідної вершини; недостатньо для підтвердження часу самостійно.';

  @override
  String get demoEvidenceNoMatch =>
      'Відсутній основний аспект у межах допуску вікна кандидата. Ця подія не підтримує і не суперечить результату.';
}
