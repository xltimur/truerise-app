// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get commonContinue => 'Continuar';

  @override
  String get commonNext => 'Siguiente';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get onboardingSkip => 'Omitir';

  @override
  String get onboardingSlide1Title =>
      'Tu carta natal depende de tu hora de nacimiento exacta.';

  @override
  String onboardingSlide1Body(String brand) {
    return 'La mayoría de las personas solo conocen una hora aproximada, o nada en absoluto. $brand la acota usando eventos de tu vida.';
  }

  @override
  String onboardingSlide2Title(String brand) {
    return 'Cómo funciona $brand';
  }

  @override
  String get onboardingSlide2Body =>
      '1. Introduce tu fecha de nacimiento y la hora aproximada.\n2. Añade eventos de tu vida: matrimonio, cambios de trabajo, mudanzas y más.\n3. Calculamos la hora de nacimiento más probable y te explicamos por qué.\n\nCuantos más eventos añadas, más preciso será el resultado.';

  @override
  String get onboardingSlide3Title =>
      '¿Listo para encontrar tu hora de nacimiento?';

  @override
  String get onboardingSlide3Body =>
      'Una demo te muestra primero un resultado de muestra, sin necesidad de cuenta.';

  @override
  String get onboardingTryDemo => 'Probar la demo primero';

  @override
  String get onboardingStartReal => 'Iniciar cálculo real';

  @override
  String onboardingPageLabel(int page, int count) {
    return 'Página $page de $count';
  }

  @override
  String get birthDataTitle => 'Datos de nacimiento';

  @override
  String get birthDataDateLabel => 'Fecha de nacimiento';

  @override
  String get birthDataDatePlaceholder => 'Seleccionar fecha';

  @override
  String get birthDataCityLabel => 'Ciudad de nacimiento';

  @override
  String get birthDataCityHint => 'Empieza a escribir una ciudad';

  @override
  String get birthDataLabelLabel => 'Etiqueta (opcional)';

  @override
  String get birthDataLabelHelper => 'Se muestra en tu lista de historial.';

  @override
  String get birthDataLabelHint => 'p. ej. Mi hora de nacimiento';

  @override
  String get birthDataSearching => 'Buscando…';

  @override
  String get birthDataNoMatches =>
      'Sin coincidencias. La demo acepta el nombre escrito.';

  @override
  String get timeWindowTitle => '¿Conoces una hora de nacimiento aproximada?';

  @override
  String get timeWindowModeApprox => 'Tengo una hora aproximada';

  @override
  String get timeWindowModeUnknown => 'No tengo ni idea';

  @override
  String get timeWindowApproxTimeLabel => 'Hora aproximada';

  @override
  String get timeWindowChooseTime => 'Elegir hora';

  @override
  String get timeWindowTimePickerHelp => 'Hora de nacimiento aproximada';

  @override
  String get timeWindowSearchWindow => 'Ventana de búsqueda';

  @override
  String timeWindowDeltaMinutes(int minutes) {
    return '± $minutes min';
  }

  @override
  String timeWindowDeltaHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '± $hours horas',
      one: '± 1 hora',
    );
    return '$_temp0';
  }

  @override
  String timeWindowRangeCopy(String start, String end) {
    return 'Buscaremos entre las $start y las $end.';
  }

  @override
  String get timeWindowApproxHint =>
      'Una ventana más amplia da más candidatos, pero puede reducir la precisión.';

  @override
  String get timeWindowUnknownBody =>
      'Buscaremos en el rango completo de 24 horas. Esto puede generar más candidatos con un nivel de confianza menor.';

  @override
  String get timeWindowUnknownHint =>
      'Añadir más eventos de vida ayudará a acotarlo.';

  @override
  String get lifeEventsTitle => 'Eventos de vida';

  @override
  String lifeEventsTitleWithCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Eventos de vida  ($count añadidos)',
      one: 'Eventos de vida  (1 añadido)',
    );
    return '$_temp0';
  }

  @override
  String get lifeEventsAddEvent => 'Añadir evento';

  @override
  String get lifeEventsAddFirstEvent => 'Añadir primer evento';

  @override
  String get lifeEventsContinueDemo => 'Continuar (demo)';

  @override
  String get lifeEventsEmptyBody =>
      'Añade eventos memorables de tu vida. Cuantos más añadas, mejor.';

  @override
  String get lifeEventsGuidanceEmpty =>
      'Añade al menos 5 eventos para un cálculo real. 3 para una demo.';

  @override
  String get lifeEventsNoEvents => 'Aún no hay eventos.';

  @override
  String lifeEventsGuidanceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count eventos. Añade 5 o más para un cálculo real más sólido.',
      one: '1 evento. Añade 5 o más para un cálculo real más sólido.',
    );
    return '$_temp0';
  }

  @override
  String get eventCategoryMarriage => 'Matrimonio / Pareja';

  @override
  String get eventCategoryDivorce => 'Divorcio / Separación';

  @override
  String get eventCategoryCareerChange => 'Cambio de carrera';

  @override
  String get eventCategoryJobLoss => 'Pérdida de empleo';

  @override
  String get eventCategoryRelocation => 'Mudanza (importante)';

  @override
  String get eventCategoryChildBirth => 'Nacimiento de un hijo';

  @override
  String get eventCategoryFamilyDeath => 'Fallecimiento de un familiar';

  @override
  String get eventCategoryIllness => 'Enfermedad grave / cirugía';

  @override
  String get eventCategoryAccident => 'Accidente o lesión';

  @override
  String get eventCategoryEducation => 'Hito educativo';

  @override
  String get eventCategoryFinancial => 'Punto de inflexión económico';

  @override
  String get eventCategoryOther => 'Otro';

  @override
  String get confirmationTitle => 'Confirma tu cálculo';

  @override
  String get confirmationBackToEdit => 'Volver a editar';

  @override
  String get confirmationCalculate => 'Calcular';

  @override
  String get confirmationCalculateDemo => 'Calcular (demo)';

  @override
  String get confirmationDatePending => 'Fecha pendiente';

  @override
  String get confirmationRowDate => 'Fecha';

  @override
  String get confirmationRowCity => 'Ciudad';

  @override
  String get confirmationRowLabel => 'Etiqueta';

  @override
  String get confirmationTimeWindow => 'Ventana de tiempo';

  @override
  String get confirmationFullDayWindow => 'Ventana completa de 24 horas';

  @override
  String confirmationWindowApprox(String time, String window) {
    return '$time ($window)';
  }

  @override
  String confirmationLifeEventsCount(int count) {
    return 'Eventos de vida ($count)';
  }

  @override
  String get confirmationDemoNote =>
      'Modo demo: mostraremos un resultado de muestra sin ninguna solicitud de red.';

  @override
  String get loadingTitle => 'Calculando tu hora de nacimiento probable…';

  @override
  String get loadingDemoTitle => 'Ejecutando cálculo de demostración…';

  @override
  String get loadingRotating1 => 'Analizando eventos de vida…';

  @override
  String get loadingRotating2 => 'Trazando tránsitos planetarios…';

  @override
  String get loadingRotating3 => 'Clasificando candidatos…';

  @override
  String get loadingTakesUnder => 'Esto suele tardar menos de 10 segundos.';

  @override
  String get addEventAddTitle => 'Añadir evento de vida';

  @override
  String get addEventEditTitle => 'Editar evento de vida';

  @override
  String get addEventSelectCategory => 'Seleccionar categoría';

  @override
  String get addEventCategoryLabel => 'Categoría';

  @override
  String get addEventChooseCategory => 'Elegir categoría';

  @override
  String get addEventMonth => 'Mes';

  @override
  String get addEventNoMonth => 'Sin mes';

  @override
  String get addEventYear => 'Año';

  @override
  String get addEventMonthOptional => 'El mes es opcional.';

  @override
  String get addEventDescriptionLabel => 'Descripción (opcional)';

  @override
  String get addEventDescriptionHint =>
      'Cualquier cosa que ayude a acotar el momento';

  @override
  String addEventCharCount(int current, int max) {
    return '$current / $max';
  }

  @override
  String get addEventSaveChanges => 'Guardar cambios';

  @override
  String get commonBackToHistory => 'Volver al historial';

  @override
  String get commonDismiss => 'Descartar';

  @override
  String get resultTitle => 'Resultado';

  @override
  String get resultNotFoundTitle => 'No pudimos encontrar ese resultado.';

  @override
  String get resultNotFoundBody =>
      'Es posible que se haya eliminado de tu historial. Abre un cálculo guardado o inicia uno nuevo.';

  @override
  String resultRisingSign(String sign) {
    return 'Ascendente $sign';
  }

  @override
  String get resultSampleData => '(datos de muestra)';

  @override
  String get resultLowConfidenceTitle => 'Resultado de confianza baja';

  @override
  String get resultLowConfidenceTipEvents =>
      'Añade más eventos de vida con fecha.';

  @override
  String get resultLowConfidenceTipReviewInput =>
      'Revisa tu fecha de nacimiento, ciudad y hora aproximada.';

  @override
  String get resultLowConfidenceTipWiderWindow =>
      'Prueba una ventana de hora de nacimiento más amplia.';

  @override
  String get resultConfidenceExplainerTitle =>
      '¿Qué significa este porcentaje?';

  @override
  String get resultConfidenceExplainerBody =>
      'La confianza es una estimación. Indica con qué fuerza tus eventos de vida con fecha respaldan esta hora candidata en comparación con las otras horas candidatas de la ventana de hora de nacimiento que seleccionaste.';

  @override
  String get resultConfidenceExplainerMethod =>
      'Método: cada hora candidata se puntúa con tránsitos y progresiones a partir de tus eventos; una puntuación más alta indica una coincidencia más probable.';

  @override
  String get resultOtherCandidates => 'Otros candidatos';

  @override
  String get resultSeeEvidence => 'Ver cómo lo obtuvimos';

  @override
  String get resultShare => 'Compartir el resultado';

  @override
  String get resultCopiedToClipboard => 'Copiado al portapapeles';

  @override
  String get resultShareImage => 'Compartir imagen';

  @override
  String get resultShareImageUnavailable =>
      'No se pudo abrir el menú para compartir la imagen.';

  @override
  String get resultDemoShareLabel => 'Compartir este ejemplo';

  @override
  String get resultDemoShareTitle => '¿Te gusta este ejemplo? Compártelo.';

  @override
  String get resultDemoShareButton => 'Compartir ejemplo';

  @override
  String get resultFeedbackLabel => 'Comentarios del resultado';

  @override
  String get resultFeedbackTitle => '¿Esta hora te parece plausible?';

  @override
  String get resultFeedbackYes => 'Sí';

  @override
  String get resultFeedbackNotSure => 'No lo sé';

  @override
  String get resultFeedbackNo => 'No';

  @override
  String get resultFeedbackSaved => 'Gracias, guardado.';

  @override
  String get shareCardTagline => 'Rectificación de la hora de nacimiento';

  @override
  String shareCardConfidence(int percent) {
    return '$percent% de confianza';
  }

  @override
  String shareCopyHeadline(String brand) {
    return 'Mi resultado de hora de nacimiento con $brand:';
  }

  @override
  String shareCopyTagline(String brand) {
    return 'Calculado con $brand — rectificación de la hora de nacimiento';
  }

  @override
  String shareCopyGetApp(String url) {
    return 'Averigua tu hora de nacimiento: $url';
  }

  @override
  String inviteCopyHeadline(String brand) {
    return 'Prueba $brand: averigua tu verdadera hora de nacimiento';
  }

  @override
  String get inviteCopyBody =>
      'Estima una hora de nacimiento probable a partir de algunos eventos de tu vida que recuerdes.';

  @override
  String inviteCopyGetApp(String url) {
    return 'Descarga la app: $url';
  }

  @override
  String get resultSaveToHistory => 'Guardar en el historial';

  @override
  String get resultSaved => 'Guardado ✓';

  @override
  String get resultDemoNudgeLabel => 'Sugerencia para pasar de la demo';

  @override
  String get resultDemoNudgeTitle => 'Esto fue una demo.';

  @override
  String get resultDemoNudgeBody =>
      'Ejecuta un cálculo real con tus propios datos de nacimiento.';

  @override
  String get resultStartNewCalculation => 'Iniciar un nuevo cálculo';

  @override
  String reviewPromptTitle(String brand) {
    return '¿Reseñar $brand?';
  }

  @override
  String reviewPromptBody(String brand) {
    return 'Si $brand te ha resultado útil, una reseña honesta ayuda a otras personas a decidir si probarlo. Solo lleva un momento y es totalmente opcional.';
  }

  @override
  String get reviewPromptConfirm => 'Escribir una reseña';

  @override
  String get reviewPromptDismiss => 'Ahora no';

  @override
  String get updateAvailableTitle => 'Actualización disponible';

  @override
  String updateAvailableBody(String brand) {
    return 'Una nueva versión de $brand está lista para instalar.';
  }

  @override
  String get updateRequiredTitle => 'Actualización necesaria';

  @override
  String updateRequiredBody(String brand) {
    return 'Esta versión de $brand está desactualizada. Actualízala para continuar.';
  }

  @override
  String get updateAction => 'Actualizar';

  @override
  String get updateNotNow => 'Ahora no';

  @override
  String get updateOpenStoreFailed =>
      'No se pudo abrir la página de la tienda.';

  @override
  String get evidenceTitle => 'Indicios';

  @override
  String get evidenceNotFoundTitle => 'No pudimos encontrar esos indicios.';

  @override
  String get evidenceNotFoundBody =>
      'Es posible que el resultado original se haya eliminado. Vuelve a tu historial para elegir otro cálculo.';

  @override
  String evidenceWhyTitle(String time) {
    return '¿Por qué las $time?';
  }

  @override
  String get evidenceNoEvidence =>
      'No tenemos indicios por evento para este resultado.';

  @override
  String evidenceStrongSummary(int strong, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$strong de $total eventos respaldaron con fuerza esta hora.',
      one: '$strong de 1 evento respaldó con fuerza esta hora.',
    );
    return '$_temp0';
  }

  @override
  String get evidenceEventFallback => 'Evento';

  @override
  String get heroResultEyebrow => 'TU HORA DE NACIMIENTO MÁS PROBABLE';

  @override
  String heroResultSemantic(String eyebrow, String time, String risingSign) {
    return '$eyebrow: $time, $risingSign';
  }

  @override
  String get confidenceBarLabel => 'Nivel de confianza';

  @override
  String confidenceBarSemantic(String label, int percent) {
    return '$label: $percent por ciento';
  }

  @override
  String get matchStrengthStrong => 'FUERTE';

  @override
  String get matchStrengthModerate => 'MODERADO';

  @override
  String get matchStrengthWeak => 'DÉBIL';

  @override
  String get matchStrengthNone => 'SIN COINCIDENCIA';

  @override
  String matchStrengthSemantic(String strength) {
    String _temp0 = intl.Intl.selectLogic(
      strength,
      {
        'strong': 'Coincidencia fuerte',
        'moderate': 'Coincidencia moderada',
        'weak': 'Coincidencia débil',
        'none': 'Sin coincidencia',
        'other': 'Nivel de coincidencia',
      },
    );
    return '$_temp0';
  }

  @override
  String candidateCardSemantic(String time, String risingSign, int percent) {
    return 'Candidato $time, $risingSign, nivel de confianza $percent por ciento';
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
            '$label, $date, $time $risingSign, nivel de confianza $percent por ciento, demo',
        'other':
            '$label, $date, $time $risingSign, nivel de confianza $percent por ciento',
      },
    );
    return '$_temp0';
  }

  @override
  String evidenceCardSemantic(String category, String date, String strength) {
    String _temp0 = intl.Intl.selectLogic(
      strength,
      {
        'strong': 'coincidencia fuerte',
        'moderate': 'coincidencia moderada',
        'weak': 'coincidencia débil',
        'none': 'sin coincidencia',
        'other': 'coincidencia',
      },
    );
    return '$category, $date, $_temp0';
  }

  @override
  String get demoPillLabel => 'DEMO';

  @override
  String demoPillSemantic(String label) {
    return 'Distintivo de cálculo $label';
  }

  @override
  String eventCardSemantic(String category, String date) {
    return 'Evento: $category el $date';
  }

  @override
  String eventCardDeleteSemantic(String category) {
    return 'Eliminar evento $category';
  }

  @override
  String get commonBack => 'Atrás';

  @override
  String get commonDelete => 'Eliminar';

  @override
  String get commonNotSet => 'sin definir';

  @override
  String fieldValueSemantic(String label, String value) {
    return '$label, $value';
  }

  @override
  String get navNew => 'NUEVO';

  @override
  String get navHistory => 'HISTORIAL';

  @override
  String get navSettings => 'AJUSTES';

  @override
  String stepperStep(int current, int total) {
    return 'PASO $current DE $total';
  }

  @override
  String stepperPercent(int percent) {
    return '$percent por ciento';
  }

  @override
  String get calcFlowTitle => 'Nuevo cálculo';

  @override
  String get homeSettingsButton => 'Ajustes';

  @override
  String homeHistoryLoadError(String error) {
    return 'No pudimos cargar tu historial.\n$error';
  }

  @override
  String get homeEmptyTitle => 'Aún no hay cálculos.';

  @override
  String get homeEmptyBody =>
      'Ejecuta el primero para ver los resultados aquí.';

  @override
  String get homeNewCalculation => 'Nuevo cálculo';

  @override
  String get homePastCalculations => 'Cálculos anteriores';

  @override
  String get homeDefaultLabel => 'Mi cálculo';

  @override
  String get historyDeleteTitle => '¿Eliminar este cálculo?';

  @override
  String historyDeleteBody(String label) {
    return 'Esto elimina «$label» de tu historial. Los datos originales no se conservan en ningún otro lugar.';
  }

  @override
  String historyDeletedSnack(String label) {
    return '«$label» eliminado.';
  }

  @override
  String get historyDeleteFailedSnack => 'No se pudo eliminar esta entrada.';

  @override
  String get errorTryAgain => 'Intentar de nuevo';

  @override
  String get errorReviewDraft => 'Revisar mi borrador';

  @override
  String get errorTimeoutTitle => 'El cálculo agotó el tiempo de espera';

  @override
  String get errorTimeoutBody =>
      'El cálculo no terminó a tiempo. La red puede ser lenta en wifi públicas; vuelve a intentarlo en un momento.';

  @override
  String get errorNoInternetTitle => 'No se puede acceder a la red';

  @override
  String get errorNoInternetBody =>
      'Estás sin conexión o tu red está bloqueando la solicitud. Reconéctate e inténtalo de nuevo.';

  @override
  String get errorBadRequestTitle => 'Algo no cuadraba en los datos';

  @override
  String get errorBadRequestBody =>
      'Algo en tu fecha de nacimiento, la ventana de tiempo o los eventos no se pudo procesar. Verifícalos y luego inténtalo de nuevo.';

  @override
  String get errorUnauthorizedTitle => 'No se pudo completar el cálculo';

  @override
  String get errorUnauthorizedBody =>
      'No pudimos completar este cálculo en este momento. Inténtalo de nuevo en un momento o activa el modo demo para seguir explorando con datos de muestra.';

  @override
  String get errorMissingApiKeyTitle => 'No se pudo iniciar el cálculo';

  @override
  String get errorMissingApiKeyBody =>
      'No pudimos iniciar un cálculo en vivo en este momento. Inténtalo de nuevo en un momento o activa el modo demo para probar la app con datos de muestra.';

  @override
  String get errorServerTitle => 'Algo salió mal';

  @override
  String get errorServerBody =>
      'El cálculo no se pudo completar ahora mismo. Puede ser un problema temporal; vale la pena intentarlo de nuevo en breve.';

  @override
  String get errorRateLimitedTitle => 'Límite de cálculos alcanzado';

  @override
  String get errorRateLimitedBody =>
      'Has alcanzado el límite de cálculos por ahora. Espera un momento e inténtalo de nuevo, o activa el modo demo para seguir explorando sin conexión.';

  @override
  String get errorRateLimitedUseDemo => 'Usar el modo demo';

  @override
  String get errorRateLimitedEnterKey => 'Introducir mi clave de API';

  @override
  String errorRateLimitedLocalQuotaBody(String resetDetail) {
    return 'Tu cupo gratuito de cálculos en vivo se ha agotado.$resetDetail Cambia al modo demo para seguir explorando o añade tu propia clave de API en Ajustes.';
  }

  @override
  String errorRateLimitedResetAt(String resetTime) {
    return 'Se restablece el $resetTime UTC.';
  }

  @override
  String errorRateLimitedRetryAfter(String duration) {
    return 'Puedes intentarlo de nuevo en aproximadamente $duration.';
  }

  @override
  String errorRateLimitedRetryMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutos',
      one: '1 minuto',
    );
    return '$_temp0';
  }

  @override
  String errorRateLimitedRetryHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count horas',
      one: '1 hora',
    );
    return '$_temp0';
  }

  @override
  String get errorMalformedTitle => 'No se pudo leer la respuesta';

  @override
  String get errorMalformedBody =>
      'La respuesta no coincidió con lo que espera esta versión. Inténtalo de nuevo o ejecuta un cálculo de demostración mientras lo investigamos.';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsSectionDefaults => 'Valores predeterminados del cálculo';

  @override
  String get settingsSectionTimeFormat => 'Formato de hora';

  @override
  String get settingsSectionApiKey => 'Clave de API';

  @override
  String get settingsSectionData => 'Datos';

  @override
  String get settingsSectionAbout => 'Acerca de';

  @override
  String get settingsDemoModeLabel => 'Modo demo';

  @override
  String get settingsDemoModeHelper =>
      'Ejecuta cálculos con datos de muestra (gratis, sin red).';

  @override
  String get settingsTimeFormat12 => '12 horas  (7:14 AM)';

  @override
  String get settingsTimeFormat24 => '24 horas  (07:14)';

  @override
  String get settingsApiKeyHelper =>
      '¿Ya tienes una clave de la Astrology API? Añádela aquí.';

  @override
  String get settingsApiKeyConfigured => 'Clave de API añadida';

  @override
  String get settingsApiKeyAdd => 'Añadir clave';

  @override
  String get settingsApiKeyRemove => 'Eliminar clave';

  @override
  String get settingsApiKeyFieldLabel => 'Clave de la Astrology API';

  @override
  String get settingsApiKeySave => 'Guardar clave';

  @override
  String get settingsDeleteAllData => 'Eliminar todos los datos';

  @override
  String get settingsDeleteAllHelper =>
      'Elimina todos los cálculos y eventos de este dispositivo. No se puede deshacer.';

  @override
  String get settingsPrivacyPolicy => 'Política de privacidad';

  @override
  String get settingsInviteFriend => 'Invitar a un amigo';

  @override
  String get deleteAllTitle => '¿Eliminar todos los datos?';

  @override
  String get deleteAllBodyGeneric =>
      'Esto eliminará de forma permanente todos los cálculos, eventos y ajustes de este dispositivo. No se puede deshacer.';

  @override
  String deleteAllBodyCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Esto eliminará de forma permanente $count cálculos y todos los eventos y ajustes guardados en este dispositivo. No se puede deshacer.',
      one:
          'Esto eliminará de forma permanente 1 cálculo y todos los eventos y ajustes guardados en este dispositivo. No se puede deshacer.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAllFailedSnack =>
      'No se pudieron eliminar los datos. Inténtalo de nuevo.';

  @override
  String get privacyTitle => 'Privacidad';

  @override
  String privacyStoresTitle(String brand) {
    return 'Qué almacena $brand';
  }

  @override
  String privacyStoresBody(String brand) {
    return 'Todo lo que introduces (fecha de nacimiento, ciudad de nacimiento, eventos de vida, resultados de cálculo) se almacena solo en este dispositivo. Nada se sube a una cuenta de $brand, porque no gestionamos cuentas de usuario. Eliminar la app borra cada byte de esos datos.';
  }

  @override
  String get privacyDemoTitle => 'Modo demo';

  @override
  String get privacyDemoBody =>
      'Los cálculos de demostración se ejecutan por completo en este dispositivo: no se realizan llamadas de red. Los resultados de demostración se etiquetan claramente con una insignia DEMO para que no se confundan con lecturas reales.';

  @override
  String get privacyLiveTitle => 'Cálculos en vivo';

  @override
  String privacyLiveBody(String brand) {
    return 'Ejecutar un cálculo en vivo (no demo) envía tu fecha de nacimiento y hora aproximada, las coordenadas de tu lugar de nacimiento y las descripciones de los eventos de vida que añadas a un proveedor de cálculo externo a través de HTTPS. Esos datos se transmiten únicamente para calcular tu hora de nacimiento rectificada: no se usan para crear un perfil y no están vinculados a ninguna cuenta de $brand, porque no existen.';
  }

  @override
  String get privacyDeleteTitle => 'Eliminar tus datos';

  @override
  String get privacyDeleteBody =>
      'La pantalla de Ajustes tiene una acción «Eliminar todos los datos» que borra la base de datos local y todas las preferencias almacenadas en este dispositivo. El borrado se completa antes de que la acción termine; la app te devuelve entonces al onboarding para que confirmes el restablecimiento.';

  @override
  String get privacyAnalyticsTitle => 'Analítica e informes de fallos';

  @override
  String privacyAnalyticsBody(String brand) {
    return 'Esta versión de $brand se distribuye sin un SDK de analítica y sin informes de fallos. Si una versión futura añade alguno, se divulgará aquí y se limitará a datos anónimos y no identificativos.';
  }

  @override
  String get demoEvidenceStrongVenus =>
      'Un retorno de Venus con fecha precisa se alineó con la ventana candidata, coherente con un evento de pareja.';

  @override
  String get demoEvidenceStrongSaturn =>
      'Saturno cruzó la cúspide de la casa 10 dentro de la ventana: una firma temporal clásica de un giro profesional.';

  @override
  String get demoEvidenceModerateJupiter =>
      'Júpiter pasó cerca de la cúspide de la casa 4; respaldo moderado para un evento de hogar o mudanza en esta ventana.';

  @override
  String get demoEvidenceModerateSolarArc =>
      'Un arco solar a Marte quedó dentro de la tolerancia de la ventana, plausible para el evento informado pero no exclusivo de él.';

  @override
  String get demoEvidenceWeakMercury =>
      'Mercurio estaba dentro de un orbe amplio de la cúspide relevante; insuficiente para confirmar el momento por sí solo.';

  @override
  String get demoEvidenceNoMatch =>
      'Ningún aspecto principal dentro de la tolerancia de la ventana candidata. Este evento ni respalda ni contradice el resultado.';
}
