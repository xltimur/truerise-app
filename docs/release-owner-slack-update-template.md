# Owner Slack Update Template (RU) - TrueRise release status

**Purpose.** A concise, paste-ready Slack message (in Russian) for the owner
(Oleg) summarizing the 2026-06-16 local verification, what still blocks the
store submission, the screenshot status, and the exact owner asks. Copy the
fenced block below into Slack and fill the `[...]` placeholders.

**It deliberately does not claim any owner approval, legal sign-off, hosting,
signing, or store action is done** - those are the asks. Authoritative source:
`docs/publication-readiness-current-status.md` (Sec. 5a); command/result
evidence: `docs/release-verification-report-2026-06-16.md`.

---

```
Привет, Олег! Статус по релизу TrueRise на 16.06.2026.

ЛОКАЛЬНЫЕ ПРОВЕРКИ - ПРОЙДЕНЫ (инженерная часть чистая):
- flutter analyze: без замечаний.
- flutter test: 648 тестов, все зелёные.
- demo/offline поток (integration test): ок.
- релизный guard (release_env_guard) и dry-run скриншотов: проходят, файлы не пишутся.
- git-дерево чистое.
Важно: это значит, что код готов. Это НЕ значит, что релиз можно отправлять в стор -
ниже список того, что закрываешь только ты / бэкенд / юристы / консоли сторов.

ЧТО ЕЩЁ НУЖНО ЗАКРЫТЬ (ничего из этого не делается из кода):

Решения и секреты владельца:
- Bundle ID - финальное решение (после создания первой записи в сторе изменить нельзя).
- Подпись релиза: Android upload keystore + Play App Signing; iOS distribution cert/profile.
- Ротация встроенного demo/review API-ключа на capped-ключ с лимитом бюджета (или удалить).
- Share-URL: домен truerise.com.ua куплен, код обновлён. Остаётся: настройка DNS, HTTPS-сертификат, загрузка сайта, создание почты/форвардера support@truerise.com.ua на хостинге.
- Trademark / доступность имени "TrueRise".

Бэкенд:
- Подтвердить no-key live API host (`api-public.astrology-api.io`) и его лимиты
  или поднять owner-controlled proxy по контракту.
- Серверный анти-абьюз / квота (локальный счётчик - это только UX, не защита).

Юристы:
- Захостить privacy policy по постоянному публичному URL (тот же URL потом в обеих консолях).
- Sign-off по Apple Privacy Labels и Play Data Safety + ввод в консоли.

Консоли сторов:
- Подтвердить категорию = Lifestyle в обоих сторах.
- Возрастные анкеты согласно гейту 18+ (Play target audience = adults).
- Support URL + контактный email для Play.
- Локализованные листинги (de/fr/es/pt-BR): нужен пересчёт символов в консоли и проверка носителем языка. Английский Tier 0 можно запускать первым.
- Решение по устройствам: нужны ли iPad / планшеты Android (влияет на наборы скриншотов).

СКРИНШОТЫ - финальные композиты НЕ готовы:
- dry-run планирует 25 кадров по 5 локалям, но НИЧЕГО не пишет; финальных PNG в репо нет.
- 5 манифестов всё ещё на старых (pre-Appeeky) сырых кадрах; нужно принять текущий 5-кадровый план, снять новые кадры и утвердить подписи.
- Дальше - работа дизайна/владельца: композитинг подписей и рамок устройств, проверка локализованных подписей носителем, доп. размеры устройств для консолей, финальный визуальный апрув, загрузка в консоль.

ЧТО НУЖНО ОТ ТЕБЯ (приоритет сверху вниз):
1. Решение по Bundle ID.
2. Trademark / доступность имени "TrueRise".
3. Подпись релиза (keystore + сертификаты).
4. Хостинг privacy policy + URL.
5. Sign-off юристов по privacy-формам.
6. Production proxy (бэкенд).
7. Хостинг share-URL: DNS + HTTPS + сайт + почта для truerise.com.ua.
8. Ротация demo/review-ключа.
9. Категория Lifestyle + возрастные анкеты + support URL в консолях.

Детали и точные значения для вставки - в docs/release-handoff-owner-checklist.md.
Готов созвониться по любому пункту. Сейчас ни одно из этих согласований ещё не закрыто.
```
