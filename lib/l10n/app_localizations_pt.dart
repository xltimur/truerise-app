// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get commonContinue => 'Continuar';

  @override
  String get commonNext => 'Avançar';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get onboardingSkip => 'Pular';

  @override
  String get onboardingSlide1Title =>
      'Seu mapa natal depende do seu horário exato de nascimento.';

  @override
  String onboardingSlide1Body(String brand) {
    return 'A maioria das pessoas só conhece um horário aproximado — ou não conhece nenhum. O $brand o restringe usando eventos da sua vida.';
  }

  @override
  String onboardingSlide2Title(String brand) {
    return 'Como o $brand funciona';
  }

  @override
  String get onboardingSlide2Body =>
      '1. Informe sua data de nascimento e o horário aproximado.\n2. Adicione eventos da sua vida — casamento, mudanças de emprego, mudanças de cidade e muito mais.\n3. Calculamos o horário de nascimento mais provável e mostramos o porquê.\n\nQuanto mais eventos você adicionar, mais preciso será o resultado.';

  @override
  String get onboardingSlide3Title =>
      'Pronto para descobrir seu horário de nascimento?';

  @override
  String get onboardingSlide3Body =>
      'Uma demonstração mostra primeiro um resultado de exemplo, sem precisar de conta.';

  @override
  String get onboardingTryDemo => 'Testar a demonstração primeiro';

  @override
  String get onboardingStartReal => 'Iniciar cálculo real';

  @override
  String onboardingPageLabel(int page, int count) {
    return 'Página $page de $count';
  }

  @override
  String get birthDataTitle => 'Dados de nascimento';

  @override
  String get birthDataDateLabel => 'Data de nascimento';

  @override
  String get birthDataDatePlaceholder => 'Selecionar data';

  @override
  String get birthDataCityLabel => 'Cidade de nascimento';

  @override
  String get birthDataCityHint => 'Comece a digitar uma cidade';

  @override
  String get birthDataLabelLabel => 'Identificação (opcional)';

  @override
  String get birthDataLabelHelper => 'Exibida na sua lista de histórico.';

  @override
  String get birthDataLabelHint => 'ex.: Meu horário de nascimento';

  @override
  String get birthDataSearching => 'Pesquisando…';

  @override
  String get birthDataNoMatches =>
      'Nenhum resultado. A demonstração aceita o nome digitado.';

  @override
  String get timeWindowTitle =>
      'Você sabe um horário aproximado de nascimento?';

  @override
  String get timeWindowModeApprox => 'Tenho um horário aproximado';

  @override
  String get timeWindowModeUnknown => 'Não faço ideia';

  @override
  String get timeWindowApproxTimeLabel => 'Horário aproximado';

  @override
  String get timeWindowChooseTime => 'Escolher horário';

  @override
  String get timeWindowTimePickerHelp => 'Horário aproximado de nascimento';

  @override
  String get timeWindowSearchWindow => 'Janela de busca';

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
    return 'Vamos pesquisar entre $start e $end.';
  }

  @override
  String get timeWindowApproxHint =>
      'Uma janela mais ampla gera mais candidatos, mas pode reduzir a precisão.';

  @override
  String get timeWindowUnknownBody =>
      'Vamos pesquisar todo o intervalo de 24 horas. Isso pode gerar mais candidatos com menor nível de confiança.';

  @override
  String get timeWindowUnknownHint =>
      'Adicionar mais eventos da vida ajudará a restringir o resultado.';

  @override
  String get lifeEventsTitle => 'Eventos da vida';

  @override
  String lifeEventsTitleWithCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Eventos da vida  ($count adicionados)',
      one: 'Eventos da vida  (1 adicionado)',
    );
    return '$_temp0';
  }

  @override
  String get lifeEventsAddEvent => 'Adicionar evento';

  @override
  String get lifeEventsAddFirstEvent => 'Adicionar primeiro evento';

  @override
  String get lifeEventsContinueDemo => 'Continuar (demonstração)';

  @override
  String get lifeEventsEmptyBody =>
      'Adicione eventos marcantes da sua vida. Quanto mais você adicionar, melhor.';

  @override
  String get lifeEventsGuidanceEmpty =>
      'Adicione pelo menos 5 eventos para um cálculo real. 3 para uma demonstração.';

  @override
  String get lifeEventsNoEvents => 'Nenhum evento ainda.';

  @override
  String lifeEventsGuidanceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count eventos. Adicione 5 ou mais para um cálculo real mais consistente.',
      one:
          '1 evento. Adicione 5 ou mais para um cálculo real mais consistente.',
    );
    return '$_temp0';
  }

  @override
  String get eventCategoryMarriage => 'Casamento / União';

  @override
  String get eventCategoryDivorce => 'Divórcio / Separação';

  @override
  String get eventCategoryCareerChange => 'Mudança de carreira';

  @override
  String get eventCategoryJobLoss => 'Perda de emprego';

  @override
  String get eventCategoryRelocation => 'Mudança de cidade (grande)';

  @override
  String get eventCategoryChildBirth => 'Nascimento de filho';

  @override
  String get eventCategoryFamilyDeath => 'Falecimento de familiar';

  @override
  String get eventCategoryIllness => 'Doença grave / cirurgia';

  @override
  String get eventCategoryAccident => 'Acidente ou lesão';

  @override
  String get eventCategoryEducation => 'Marco educacional';

  @override
  String get eventCategoryFinancial => 'Ponto de virada financeiro';

  @override
  String get eventCategoryOther => 'Outro';

  @override
  String get confirmationTitle => 'Confirme seu cálculo';

  @override
  String get confirmationBackToEdit => 'Voltar para editar';

  @override
  String get confirmationCalculate => 'Calcular';

  @override
  String get confirmationCalculateDemo => 'Calcular (demonstração)';

  @override
  String get confirmationDatePending => 'Data pendente';

  @override
  String get confirmationRowDate => 'Data';

  @override
  String get confirmationRowCity => 'Cidade';

  @override
  String get confirmationRowLabel => 'Identificação';

  @override
  String get confirmationTimeWindow => 'Janela de horário';

  @override
  String get confirmationFullDayWindow => 'Janela completa de 24 horas';

  @override
  String confirmationWindowApprox(String time, String window) {
    return '$time ($window)';
  }

  @override
  String confirmationLifeEventsCount(int count) {
    return 'Eventos da vida ($count)';
  }

  @override
  String get confirmationDemoNote =>
      'Modo de demonstração — vamos mostrar um resultado de exemplo sem requisição de rede.';

  @override
  String get loadingTitle => 'Calculando seu horário de nascimento provável…';

  @override
  String get loadingDemoTitle => 'Executando cálculo de demonstração…';

  @override
  String get loadingRotating1 => 'Analisando eventos da vida…';

  @override
  String get loadingRotating2 => 'Mapeando trânsitos planetários…';

  @override
  String get loadingRotating3 => 'Classificando candidatos…';

  @override
  String get loadingTakesUnder => 'Isso geralmente leva menos de 10 segundos.';

  @override
  String get addEventAddTitle => 'Adicionar evento da vida';

  @override
  String get addEventEditTitle => 'Editar evento da vida';

  @override
  String get addEventSelectCategory => 'Selecionar categoria';

  @override
  String get addEventCategoryLabel => 'Categoria';

  @override
  String get addEventChooseCategory => 'Escolher categoria';

  @override
  String get addEventMonth => 'Mês';

  @override
  String get addEventNoMonth => 'Sem mês';

  @override
  String get addEventYear => 'Ano';

  @override
  String get addEventMonthOptional => 'O mês é opcional.';

  @override
  String get addEventDescriptionLabel => 'Descrição (opcional)';

  @override
  String get addEventDescriptionHint =>
      'Qualquer coisa que ajude a precisar o momento';

  @override
  String addEventCharCount(int current, int max) {
    return '$current / $max';
  }

  @override
  String get addEventSaveChanges => 'Salvar alterações';

  @override
  String get commonBackToHistory => 'Voltar ao histórico';

  @override
  String get commonDismiss => 'Dispensar';

  @override
  String get resultTitle => 'Resultado';

  @override
  String get resultNotFoundTitle =>
      'Não foi possível encontrar esse resultado.';

  @override
  String get resultNotFoundBody =>
      'Ele pode ter sido excluído do seu histórico. Abra um cálculo salvo ou inicie um novo.';

  @override
  String resultRisingSign(String sign) {
    return 'Ascendente em $sign';
  }

  @override
  String get resultSampleData => '(dados de exemplo)';

  @override
  String get resultOtherCandidates => 'Outros candidatos';

  @override
  String get resultSeeEvidence => 'Veja como chegamos a isso';

  @override
  String get resultShare => 'Compartilhar resultado';

  @override
  String get resultCopiedToClipboard => 'Copiado para a área de transferência';

  @override
  String get resultShareImage => 'Compartilhar imagem';

  @override
  String get resultShareImageUnavailable =>
      'Não foi possível abrir o menu de compartilhamento da imagem.';

  @override
  String get resultDemoShareLabel => 'Compartilhar este exemplo';

  @override
  String get resultDemoShareTitle => 'Gostou deste exemplo? Compartilhe.';

  @override
  String get resultDemoShareButton => 'Compartilhar exemplo';

  @override
  String get shareCardTagline => 'Retificação da hora de nascimento';

  @override
  String shareCardConfidence(int percent) {
    return '$percent% de confiança';
  }

  @override
  String shareCopyHeadline(String brand) {
    return 'Meu resultado de horário de nascimento com $brand:';
  }

  @override
  String shareCopyTagline(String brand) {
    return 'Calculado com $brand — retificação do horário de nascimento';
  }

  @override
  String shareCopyGetApp(String url) {
    return 'Descubra seu horário de nascimento: $url';
  }

  @override
  String inviteCopyHeadline(String brand) {
    return 'Experimente o $brand — descubra seu horário de nascimento real';
  }

  @override
  String get inviteCopyBody =>
      'Ele estima um horário de nascimento provável a partir de alguns eventos da sua vida que você lembra.';

  @override
  String inviteCopyGetApp(String url) {
    return 'Baixe o app: $url';
  }

  @override
  String get resultSaveToHistory => 'Salvar no histórico';

  @override
  String get resultSaved => 'Salvo ✓';

  @override
  String get resultDemoNudgeLabel => 'Sugestão para sair da demonstração';

  @override
  String get resultDemoNudgeTitle => 'Isso foi uma demonstração.';

  @override
  String get resultDemoNudgeBody =>
      'Faça um cálculo real com seus próprios dados de nascimento.';

  @override
  String get resultStartNewCalculation => 'Iniciar um novo cálculo';

  @override
  String reviewPromptTitle(String brand) {
    return 'Avaliar o $brand?';
  }

  @override
  String reviewPromptBody(String brand) {
    return 'Se o $brand foi útil para você, uma avaliação honesta ajuda outras pessoas a decidir se vão experimentar. Leva só um momento e é totalmente opcional.';
  }

  @override
  String get reviewPromptConfirm => 'Escrever uma avaliação';

  @override
  String get reviewPromptDismiss => 'Agora não';

  @override
  String get updateAvailableTitle => 'Atualização disponível';

  @override
  String updateAvailableBody(String brand) {
    return 'Uma nova versão do $brand está pronta para instalar.';
  }

  @override
  String get updateRequiredTitle => 'Atualização necessária';

  @override
  String updateRequiredBody(String brand) {
    return 'Esta versão do $brand está desatualizada. Atualize para continuar.';
  }

  @override
  String get updateAction => 'Atualizar';

  @override
  String get updateNotNow => 'Agora não';

  @override
  String get updateOpenStoreFailed =>
      'Não foi possível abrir a página da loja.';

  @override
  String get evidenceTitle => 'Indícios';

  @override
  String get evidenceNotFoundTitle =>
      'Não foi possível encontrar esses indícios.';

  @override
  String get evidenceNotFoundBody =>
      'O resultado relacionado pode ter sido excluído. Volte ao seu histórico para escolher outro cálculo.';

  @override
  String evidenceWhyTitle(String time) {
    return 'Por que $time?';
  }

  @override
  String get evidenceNoEvidence =>
      'Não temos indícios por evento para este resultado.';

  @override
  String evidenceStrongSummary(int strong, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$strong de $total eventos apoiaram fortemente este horário.',
      one: '$strong de 1 evento apoiou fortemente este horário.',
    );
    return '$_temp0';
  }

  @override
  String get evidenceEventFallback => 'Evento';

  @override
  String get heroResultEyebrow => 'SEU HORÁRIO DE NASCIMENTO MAIS PROVÁVEL';

  @override
  String heroResultSemantic(String eyebrow, String time, String risingSign) {
    return '$eyebrow: $time, $risingSign';
  }

  @override
  String get confidenceBarLabel => 'Nível de confiança';

  @override
  String confidenceBarSemantic(String label, int percent) {
    return '$label — $percent por cento';
  }

  @override
  String get matchStrengthStrong => 'FORTE';

  @override
  String get matchStrengthModerate => 'MODERADO';

  @override
  String get matchStrengthWeak => 'FRACO';

  @override
  String get matchStrengthNone => 'SEM CORRESPONDÊNCIA';

  @override
  String matchStrengthSemantic(String strength) {
    String _temp0 = intl.Intl.selectLogic(
      strength,
      {
        'strong': 'Força da correspondência forte',
        'moderate': 'Força da correspondência moderada',
        'weak': 'Força da correspondência fraca',
        'none': 'Força da correspondência sem correspondência',
        'other': 'Força da correspondência',
      },
    );
    return '$_temp0';
  }

  @override
  String candidateCardSemantic(String time, String risingSign, int percent) {
    return 'Candidato $time, $risingSign, nível de confiança $percent por cento';
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
            '$label, $date, $time $risingSign, nível de confiança $percent por cento, demonstração',
        'other':
            '$label, $date, $time $risingSign, nível de confiança $percent por cento',
      },
    );
    return '$_temp0';
  }

  @override
  String evidenceCardSemantic(String category, String date, String strength) {
    String _temp0 = intl.Intl.selectLogic(
      strength,
      {
        'strong': 'correspondência forte',
        'moderate': 'correspondência moderada',
        'weak': 'correspondência fraca',
        'none': 'sem correspondência',
        'other': 'correspondência',
      },
    );
    return '$category, $date, $_temp0';
  }

  @override
  String get demoPillLabel => 'DEMO';

  @override
  String demoPillSemantic(String label) {
    return 'Selo de cálculo $label';
  }

  @override
  String eventCardSemantic(String category, String date) {
    return 'Evento: $category em $date';
  }

  @override
  String eventCardDeleteSemantic(String category) {
    return 'Excluir evento $category';
  }

  @override
  String get commonBack => 'Voltar';

  @override
  String get commonDelete => 'Excluir';

  @override
  String get commonNotSet => 'não definido';

  @override
  String fieldValueSemantic(String label, String value) {
    return '$label, $value';
  }

  @override
  String get navNew => 'NOVO';

  @override
  String get navHistory => 'HISTÓRICO';

  @override
  String get navSettings => 'AJUSTES';

  @override
  String stepperStep(int current, int total) {
    return 'ETAPA $current DE $total';
  }

  @override
  String stepperPercent(int percent) {
    return '$percent por cento';
  }

  @override
  String get calcFlowTitle => 'Novo cálculo';

  @override
  String get homeSettingsButton => 'Configurações';

  @override
  String homeHistoryLoadError(String error) {
    return 'Não foi possível carregar seu histórico.\n$error';
  }

  @override
  String get homeEmptyTitle => 'Nenhum cálculo ainda.';

  @override
  String get homeEmptyBody => 'Faça o primeiro para ver os resultados aqui.';

  @override
  String get homeNewCalculation => 'Novo cálculo';

  @override
  String get homePastCalculations => 'Cálculos anteriores';

  @override
  String get homeDefaultLabel => 'Meu cálculo';

  @override
  String get historyDeleteTitle => 'Excluir este cálculo?';

  @override
  String historyDeleteBody(String label) {
    return 'Isso remove \"$label\" do seu histórico. Os dados originais não ficam guardados em nenhum outro lugar.';
  }

  @override
  String historyDeletedSnack(String label) {
    return '\"$label\" excluído.';
  }

  @override
  String get historyDeleteFailedSnack => 'Não foi possível excluir este item.';

  @override
  String get errorTryAgain => 'Tentar novamente';

  @override
  String get errorReviewDraft => 'Revisar meu rascunho';

  @override
  String get errorTimeoutTitle => 'Tempo do cálculo esgotado';

  @override
  String get errorTimeoutBody =>
      'O cálculo não terminou a tempo. A rede pode ficar lenta em Wi-Fi público — tente novamente em instantes.';

  @override
  String get errorNoInternetTitle => 'Não foi possível acessar a rede';

  @override
  String get errorNoInternetBody =>
      'Você está off-line ou sua rede está bloqueando a requisição. Reconecte-se e tente novamente.';

  @override
  String get errorBadRequestTitle => 'Algo parecia errado nos dados';

  @override
  String get errorBadRequestBody =>
      'Algo na sua data de nascimento, na janela de horário ou nos eventos não pôde ser processado. Confira esses dados e tente novamente.';

  @override
  String get errorUnauthorizedTitle => 'Não foi possível concluir o cálculo';

  @override
  String get errorUnauthorizedBody =>
      'Não foi possível concluir este cálculo agora. Tente novamente em instantes ou ative o modo de demonstração para continuar explorando com dados de exemplo.';

  @override
  String get errorMissingApiKeyTitle => 'Não foi possível iniciar o cálculo';

  @override
  String get errorMissingApiKeyBody =>
      'Não foi possível iniciar um cálculo ao vivo agora. Tente novamente em instantes ou ative o modo de demonstração para testar o app com dados de exemplo.';

  @override
  String get errorServerTitle => 'Algo deu errado';

  @override
  String get errorServerBody =>
      'O cálculo não pôde ser concluído agora. Pode ser um problema temporário — vale a pena tentar de novo em breve.';

  @override
  String get errorRateLimitedTitle => 'Limite de cálculos atingido';

  @override
  String get errorRateLimitedBody =>
      'Você atingiu o limite de cálculos por enquanto. Aguarde um momento e tente novamente, ou ative o modo de demonstração para continuar explorando off-line.';

  @override
  String get errorMalformedTitle => 'Não foi possível ler a resposta';

  @override
  String get errorMalformedBody =>
      'A resposta não correspondeu ao que esta versão espera. Tente novamente ou faça um cálculo de demonstração enquanto investigamos.';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsSectionDefaults => 'Padrões de cálculo';

  @override
  String get settingsSectionTimeFormat => 'Formato de horário';

  @override
  String get settingsSectionData => 'Dados';

  @override
  String get settingsSectionAbout => 'Sobre';

  @override
  String get settingsDemoModeLabel => 'Modo de demonstração';

  @override
  String get settingsDemoModeHelper =>
      'Faça cálculos com dados de exemplo (gratuito, sem rede).';

  @override
  String get settingsTimeFormat12 => '12 horas  (7:14 AM)';

  @override
  String get settingsTimeFormat24 => '24 horas  (07:14)';

  @override
  String get settingsDeleteAllData => 'Excluir todos os dados';

  @override
  String get settingsDeleteAllHelper =>
      'Remove todos os cálculos e eventos deste dispositivo. Não pode ser desfeito.';

  @override
  String get settingsPrivacyPolicy => 'Política de Privacidade';

  @override
  String get settingsInviteFriend => 'Convidar um amigo';

  @override
  String get deleteAllTitle => 'Excluir todos os dados?';

  @override
  String get deleteAllBodyGeneric =>
      'Isso vai excluir permanentemente todos os cálculos, eventos e configurações deste dispositivo. Não pode ser desfeito.';

  @override
  String deleteAllBodyCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Isso vai excluir permanentemente $count cálculos e todos os eventos e configurações salvos neste dispositivo. Não pode ser desfeito.',
      one:
          'Isso vai excluir permanentemente 1 cálculo e todos os eventos e configurações salvos neste dispositivo. Não pode ser desfeito.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAllFailedSnack =>
      'Não foi possível excluir os dados. Tente novamente.';

  @override
  String get privacyTitle => 'Privacidade';

  @override
  String privacyStoresTitle(String brand) {
    return 'O que o $brand armazena';
  }

  @override
  String privacyStoresBody(String brand) {
    return 'Tudo o que você informa — data de nascimento, cidade de nascimento, eventos da vida, resultados de cálculos — é armazenado somente neste dispositivo. Nada é enviado para uma conta do $brand, porque não trabalhamos com contas de usuário. Excluir o app remove cada byte desses dados.';
  }

  @override
  String get privacyDemoTitle => 'Modo de demonstração';

  @override
  String get privacyDemoBody =>
      'Os cálculos de demonstração rodam inteiramente neste dispositivo — nenhuma chamada de rede é feita. Os resultados de demonstração são claramente identificados com uma etiqueta DEMO para que não se misturem com leituras reais.';

  @override
  String get privacyLiveTitle => 'Cálculos ao vivo';

  @override
  String privacyLiveBody(String brand) {
    return 'Fazer um cálculo ao vivo (não de demonstração) envia sua data de nascimento e horário aproximado, as coordenadas do seu local de nascimento e as descrições dos eventos da vida que você adiciona para um provedor de cálculo de terceiros por HTTPS. Esses dados são transmitidos somente para calcular seu horário de nascimento retificado — não são usados para criar um perfil e não são vinculados a nenhuma conta do $brand, porque não existem contas.';
  }

  @override
  String get privacyDeleteTitle => 'Excluindo seus dados';

  @override
  String get privacyDeleteBody =>
      'A tela de Configurações tem uma ação \"Excluir todos os dados\" que apaga o banco de dados local e todas as preferências armazenadas neste dispositivo. A limpeza é concluída antes de a ação retornar; o app então o leva de volta para a integração inicial para que você confirme a redefinição.';

  @override
  String get privacyAnalyticsTitle => 'Análises e relatórios de falhas';

  @override
  String privacyAnalyticsBody(String brand) {
    return 'Esta versão do $brand é distribuída sem SDK de análise e sem relatórios de falhas. Se uma versão futura adicionar qualquer um deles, isso será divulgado aqui e limitado a dados anônimos e não identificáveis.';
  }

  @override
  String get demoEvidenceStrongVenus =>
      'Um retorno de Vênus datado coincidiu com a janela do candidato, condizente com um evento de relacionamento.';

  @override
  String get demoEvidenceStrongSaturn =>
      'Saturno cruzou a cúspide da casa 10 dentro da janela — uma assinatura de tempo clássica para uma virada na carreira.';

  @override
  String get demoEvidenceModerateJupiter =>
      'Júpiter passou perto da cúspide da casa 4; apoio moderado para um evento de lar / mudança de cidade nesta janela.';

  @override
  String get demoEvidenceModerateSolarArc =>
      'Um arco solar a Marte ficou dentro da tolerância da janela, plausível para o evento relatado, mas não exclusivo dele.';

  @override
  String get demoEvidenceWeakMercury =>
      'Mercúrio estava dentro de uma órbita ampla da cúspide relevante; insuficiente para confirmar o momento por si só.';

  @override
  String get demoEvidenceNoMatch =>
      'Nenhum aspecto principal dentro da tolerância da janela do candidato. Este evento nem apoia nem contradiz o resultado.';
}
