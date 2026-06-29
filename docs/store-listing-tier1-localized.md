# Store Listing — Tier 1 Localized (TrueRise) — de / fr / es / pt-BR

- **Document:** `docs/store-listing-tier1-localized.md`
- **Run:** Impl Run D.3
- **Version:** v1.0 (draft)
- **Date:** 2026-06-03
- **Model:** `claude-opus-4-8`
- **Status:** `[PROPOSED]` — machine-drafted store copy, **not** native-approved.
  Every string below is a starting point for a human localizer, not a final
  translation. Do not paste into App Store Connect / Play Console without the
  gates in §0.

This document localizes the **descriptor** copy of the English Tier 0 listing
(`docs/store-listing-en.md`) into the four Tier 1 locales chosen in
`docs/l10n-strategy.md` §3: **German (de)**, **French (fr)**, **Spanish (es)**,
**Brazilian Portuguese (pt-BR)**. It follows the same compliance posture as the
English listing (`docs/store-listing-en.md` §6) and the same honest-confidence
terminology as `docs/l10n-strategy.md` §7–§8.

It does **not** create images, screenshots, ARB strings, or any app/config
change. It is documentation only.

> **Category alignment (2026-06-15).** The category guidance in this document
> was aligned to the post-Appeeky decision: the current recommendation is
> **Lifestyle** on both the App Store and Google Play (see §0 gate 6 and the
> per-locale Google Play packages). The earlier category guidance is
> superseded; the honest-confidence copy discipline is unchanged.

---

## 0. How to use this document (status & gates)

These drafts are **not ready to publish as-is.** Before any locale is locked,
the listing owner must clear every gate below:

1. **Native-speaker review (mandatory).** A native or near-native speaker of
   each locale must review tone, grammar, idiom, and — most importantly — the
   honest-confidence wording (no certainty/proof claims; see §1). German has the
   highest credibility bar (`docs/l10n-strategy.md` §8.1, Run 2 **W2**); review
   it hardest.
2. **Legal / privacy review.** The privacy and data-handling sentences in the
   full descriptions and reviewer notes must match the shipped behavior and the
   authoritative posture docs (`docs/apple-privacy-labels.md`,
   `docs/play-data-safety.md`). Localized copy must not over- or under-claim.
3. **Console re-count.** Character counts here are **Unicode code points after
   NFC normalization** (a portable proxy). App Store Connect and Play Console
   are the authoritative counters — re-check every hard-limited field in the
   console UI before saving, especially fields close to their limit.
4. **Trademark / name availability.** "TrueRise" and every localized descriptor
   phrase must be checked for trademark conflict and store-name collision in
   each target market before submission. This document asserts no availability.
5. **Hosted URLs.** Privacy-policy and support URLs are owner-supplied and must
   be live and localized (or at least language-appropriate) before submission.
   Placeholders read `[OWNER: hosted URL]`.
6. **Final category / age-rating owner decision.** The current recommendation
   (post-Appeeky, 2026-06-15) is **Lifestyle** on both the App Store and Google
   Play; the in-app 18+ content rating stays in place. Final category and age
   rating remain owner decisions; this document recommends but does not set them.
7. **Screenshot captions are drafts (§3).** No image is produced here. Caption
   translations need the same native review and must be baked into the capture
   run, not this file.

**Evidence labels:** `[PROPOSED]` = a recommendation for a future owner
decision; `[ASSUMED]` = inherited from prior-run docs, not re-proven here. No
live store rankings, install counts, ratings, trademark status, or policy
approvals are asserted anywhere in this document.

---

## 1. Brand & terminology rules (all locales)

- **Brand token stays English.** "TrueRise" is the global brand and appears
  **verbatim** in every locale's app name, title, descriptions, and captions.
  Only the **descriptor** around it is localized
  (`docs/l10n-strategy.md` §4). Never translate, inflect, or transliterate
  "TrueRise".
- **Honest-confidence wording (the core risk).** Use *probability* / *estimate*
  language, never *proof* or *certainty*:

  | Concept | de | fr | es | pt-BR |
  |---|---|---|---|---|
  | confidence (the metric) | **Wahrscheinlichkeit(swert)** — avoid bare *Konfidenz* | **niveau de confiance** — avoid bare *confiance* | **nivel de confianza** / *probabilidad* | **nível de confiança** / *probabilidade* |
  | evidence (per-event) | **Hinweise** — not *Beweise* | **indices** — not *preuve* | **indicios** — not *pruebas* | **indícios** — not *provas* |
  | estimate / rectify | **schätzen / Rektifizierung** | **estimer / rectification** | **estimar / rectificación** | **estimar / retificação** |

  Source: `docs/l10n-strategy.md` §7.1 and §8. The strings below already follow
  this; a native reviewer must confirm it survived any edit.
- **No fortune-telling lexicon, any locale.** No horoscope/zodiac/fortune/
  psychic/tarot/oracle/destiny/"predict your future" in name, subtitle,
  keywords, description, captions, or promo text
  (`docs/store-listing-en.md` §6). Astrology appears only as the *method*
  (transits/progressions), never as the category in the visible title/subtitle
  or first screenshot (Apple Guideline 4.3(b)).
- **No deterministic / no-PII rules carry over.** Always "most likely" + a
  confidence/probability score; never a guaranteed or exact result. Sharing copy
  describes the shipped **privacy-safe text and image share** (time + rising +
  confidence + brand, no birth data) - both shipped share surfaces are
  privacy-safe. Do **not** imply **direct Instagram Stories** posting - that is
  out of scope until a Meta/Facebook App ID exists. No accounts, analytics, ads,
  IAP, or paywalls are implied anywhere.
- **Register / orthography per locale:** de uses informal **du**; es uses
  inverted **¿ ¡**; pt-BR uses **horário** (not *hora*) and **compartilhar**
  (not *partilhar*) (`docs/l10n-strategy.md` §8).

---

## 2. Shared reviewer notes (English canonical) + localized one-liners

App Review (Apple) and Play review are conducted in English; the **canonical
reviewer notes stay in English** so nothing is lost in translation. They are
identical in substance to `docs/store-listing-en.md` §2.6 / §3.5 and apply to
every localized submission. A short **localized one-liner** is added per locale
only as a courtesy lead-in for a locale reviewer; it does not replace the
English block.

### 2.1 App Store — canonical review notes (English, all locales)

```
TrueRise is a utility that estimates an unknown birth time from user-entered life events and returns candidate times with an honest confidence score. It is not a horoscope or fortune-telling app and makes no deterministic or predictive claims. This submission is a localized listing (de/fr/es/pt-BR) of the same binary; only store metadata is translated.

NO PAYMENT OR KEY REQUIRED TO REVIEW: enable Settings > Demo mode, which runs the full input > result > evidence flow entirely OFFLINE (no network, no API key, no purchase). Demo results are clearly marked with a DEMO pill.

LIVE MODE (optional): a live calculation sends the user's birth date, approximate birth time/window, birthplace text and coordinates (when available), and life-event categories/dates/descriptions to a third-party calculation provider over HTTPS, solely to compute the result. It is not linked to any identity (the app has no accounts) and is not used for tracking. The review build may embed a low-budget provider key so live mode can be exercised; Demo mode needs no key.

PRIVACY & DATA: on-device storage only; no analytics, crash-reporting, advertising, or tracking SDKs; the app requests NO device Location permission (the coordinates describe a birthplace the user selects, not current device location); Settings > Delete all data erases all local data. Privacy policy: [OWNER: hosted URL].

AGE: the app enforces an in-app 18+ birth-date gate; please set the App Store age rating consistently.
```

### 2.2 Google Play — canonical review notes (English, all locales)

```
TrueRise is a focused Lifestyle utility that estimates an unknown birth time from user-entered life events, returning candidate times with a confidence score. No deterministic, predictive, medical, legal, or financial claims are made. This is a localized listing (de/fr/es/pt-BR) of the same app; only store metadata is translated.

TEST WITHOUT LIVE CREDITS OR PAYMENT: Settings > Demo mode runs the complete flow OFFLINE (no network, no key, no purchase); demo results are marked with a DEMO pill. The Play pre-launch report can be run in Demo mode.

LIVE MODE (optional) transmits birth date, approximate birth time/window, birthplace text + coordinates (when available), and life-event categories/dates/descriptions to a third-party calculation provider over HTTPS, solely to compute the result; not linked to identity (no accounts), not used for tracking. The Data safety form should match this flow (see docs/play-data-safety.md): encrypted in transit = yes; in-app deletion = yes.

PRIVACY & DATA: on-device storage; no analytics/crash/ads/tracking SDKs; only the INTERNET permission is declared; no device Location permission (coordinates are a selected birthplace, not GPS). Privacy policy: [OWNER: hosted URL]. Target audience: adults; in-app 18+ gate. Set the content rating consistently.
```

### 2.3 Localized reviewer one-liners (optional lead-in per locale) `[PROPOSED]`

- **de:** `TrueRise ist ein Dienstprogramm, das eine unbekannte Geburtszeit aus selbst eingegebenen Lebensereignissen schätzt und Kandidatenzeiten mit Wahrscheinlichkeitswert liefert. Kein Horoskop, keine Wahrsagerei. Der Demo-Modus läuft vollständig offline (kein Netzwerk, kein Schlüssel, kein Kauf).`
- **fr:** `TrueRise est un utilitaire qui estime une heure de naissance inconnue à partir d'événements de vie saisis par l'utilisateur et renvoie des heures candidates avec un niveau de confiance. Ni horoscope ni voyance. Le mode démo fonctionne entièrement hors ligne (sans réseau, sans clé, sans achat).`
- **es:** `TrueRise es una utilidad que estima una hora de nacimiento desconocida a partir de eventos de vida introducidos por el usuario y devuelve horas candidatas con un nivel de confianza. No es un horóscopo ni adivinación. El modo demo funciona totalmente sin conexión (sin red, sin clave, sin compra).`
- **pt-BR:** `O TrueRise é um utilitário que estima um horário de nascimento desconhecido a partir de eventos de vida inseridos pelo usuário e retorna horários candidatos com nível de confiança. Não é horóscopo nem adivinhação. O modo demo funciona totalmente off-line (sem rede, sem chave, sem compra).`

---

## 3. Screenshot caption localization plan

No images are created here. These adapt the **five** English captions
(`docs/store-listing-en.md` §5, post-Appeeky story order: problem hook -> life
events -> result -> evidence -> privacy / offline demo) for the future capture
run. Frame order and the "real shipped UI only" rule follow the English plan. An
optional **bonus share frame** may use either shipped privacy-safe share surface
(the text share or the shipped share-card image) - both shipped share surfaces
are privacy-safe; only **direct Instagram Stories** posting stays out of scope
(no Meta/Facebook App ID yet). Captions are short by design but are **not
hard-limited** - keep them on one line at the chosen overlay size and re-check
wrap per device. All `[PROPOSED]`, pending native review.

| # | Frame | English (source) | de | fr | es | pt-BR |
|---|---|---|---|---|---|---|
| 1 | Problem hook | Don't know your exact birth time? | Du kennst deine genaue Geburtszeit nicht? | Vous ne connaissez pas votre heure de naissance exacte ? | ¿No sabes tu hora de nacimiento exacta? | Não sabe seu horário de nascimento exato? |
| 2 | Life events | Add the life events you remember. | Füge die Lebensereignisse hinzu, an die du dich erinnerst. | Ajoutez les événements de vie dont vous vous souvenez. | Añade los eventos de vida que recuerdas. | Adicione os eventos de vida que você lembra. |
| 3 | The result | Estimate your birth time and rising sign. | Schätze deine Geburtszeit und deinen Aszendenten. | Estimez votre heure de naissance et votre ascendant. | Estima tu hora de nacimiento y tu ascendente. | Estime seu horário de nascimento e seu ascendente. |
| 4 | The evidence | See the evidence behind every candidate. | Sieh die Hinweise hinter jeder Kandidatenzeit. | Voyez les indices derrière chaque heure candidate. | Mira los indicios detrás de cada hora candidata. | Veja os indícios por trás de cada horário candidato. |
| 5 | Private & offline demo | Private by default. Try it free, offline. | Privat von Anfang an. Teste kostenlos, offline. | Privé par défaut. Essayez gratuitement, hors ligne. | Privado por defecto. Pruébalo gratis, sin conexión. | Privado por padrão. Experimente grátis, off-line. |

Caption-length caution: the German lines run longest - verify caption 2
(`Füge die Lebensereignisse hinzu, an die du dich erinnerst.`) and caption 4 do
not wrap awkwardly over the underlying screen at the chosen type size, and
shorten per native review if they do.

---

## 4. German (de)

Highest credibility bar of the four locales (`docs/l10n-strategy.md` §8.1).
Keep the tone sober and exact; over-promising reads worse in German than in any
other Tier 1 market.

### 4.1 App Store package (de)

**App name — limit 30**

```
TrueRise: Geburtszeit finden
```

(28) Brand + the core job ("find birth time").

**Subtitle — limit 30**

```
Wahrscheinliche Geburtszeit
```

(27) Honest-confidence framing in the second-highest-signal slot.
Alternative (20): `Geburtszeit schätzen`.

**Promotional text — limit 170 (updatable without review)**

```
Schätze deine unbekannte Geburtszeit anhand der Lebensereignisse, an die du dich erinnerst. Privat, auf deinem Gerät. Teile das Ergebnis, nie deine privaten Daten.
```

(163)

**iOS keyword field — limit 100 (comma-separated, NO spaces)**

```
geburtszeitkorrektur,aszendent,rektifizierung,unbekannt,berechnen,geburtsort,radix,häuser
```

(89) Long-tail intent first (`geburtszeitkorrektur`), then chart vocabulary in
the hidden field only. No horoscope/zodiac terms.

**Full description**

```
Kennst du deine genaue Geburtszeit? Die meisten Menschen nicht. Ohne sie bleiben dein Aszendent und deine Häuser unsicher. TrueRise schätzt deine wahrscheinlichste Geburtszeit anhand der Lebensereignisse, an die du dich erinnerst, und zeigt dir die Hinweise hinter jeder Kandidatenzeit.

SO FUNKTIONIERT ES
- Gib ein ungefähres Zeitfenster ein (oder gib an, dass du es nicht weißt) und deinen Geburtsort.
- Füge einige datierte Lebensereignisse hinzu: Umzüge, Beziehungen, berufliche Wendepunkte, Familienmomente und mehr.
- TrueRise bewertet Kandidatenzeiten mit astrologischen Zeitmethoden (Transite und Progressionen) und ordnet sie nach Wahrscheinlichkeit.
- Öffne die Hinweis-Ansicht und sieh Ereignis für Ereignis, warum jede Kandidatenzeit so bewertet wurde.

EHRLICH GEBAUT
Eine Rektifizierung ist eine Schätzung, keine Gewissheit. Jedes Ergebnis erscheint als wahrscheinlichste Zeit mit einem Wahrscheinlichkeitswert und einigen Alternativen. Es ist nie eine garantierte Antwort und nie eine Vorhersage über deine Zukunft. Je mehr datierte Ereignisse du hinzufügst, desto belastbarer wird die Schätzung.

PRIVAT VON ANFANG AN
- Deine Geburtsdaten und Lebensereignisse werden auf deinem Gerät gespeichert.
- Kein Konto, keine Anmeldung, kein Profil.
- Der Demo-Modus zeigt den gesamten Ablauf offline, ohne Netzwerk und ohne Schlüssel, damit du alles ausprobieren kannst, bevor du echte Daten eingibst.
- Ein Tippen in den Einstellungen löscht alle deine Daten.
- Eine Live-Berechnung sendet deine Geburts- und Ereignisdaten über eine sichere Verbindung an einen Berechnungsanbieter, nur um dein Ergebnis zu berechnen. Nie für Werbung oder Tracking.

TEILEN OHNE ZU VIEL PREISZUGEBEN
Teile dein Ergebnis als kurze Zeile: geschätzte Zeit, Aszendent und Wahrscheinlichkeit. Ohne Geburtsdatum, Geburtsort oder Lebensereignisse. Das Ergebnis kannst du teilen. Deine privaten Daten bleiben bei dir.

FÜR WEN
Für alle mit unbekannter oder unsicherer Geburtszeit, die ihren Aszendenten und ihre Häuser möchten. TrueRise ist ein fokussierter Geburtszeit-Rechner, kein Horoskop-Feed.

TrueRise liefert astrologische Schätzungen der Geburtszeit zum persönlichen Interesse. Es bietet keine medizinische, psychologische, rechtliche oder finanzielle Beratung, und seine Ergebnisse sind nicht deterministisch.

Probiere die kostenlose Offline-Demo. Du brauchst keine Geburtszeit, um zu starten.
```

(2388)

### 4.2 Google Play package (de)

**Title — limit 30**

```
TrueRise: Geburtszeit finden
```

(28)

**Short description — limit 80**

```
Schätze deine unbekannte Geburtszeit aus Lebensereignissen. Privat, lokal.
```

(74) Intent + method + privacy.

**Full description — limit 4000** (first ~250 chars are the hook): use the §4.1
App Store full description verbatim (2388).

**Category / tags:** Category **Lifestyle**; closest supporting tags
*Lifestyle*, *Calculator*; at most one astrology tag, kept secondary. `[PROPOSED]`

### 4.3 ASO rationale & query mapping (de)

Long-tail intent the German listing supports (from `docs/growth-thesis.md`
§7.2). Lanes follow `docs/store-listing-en.md` §4: **compete** = realistic
single-purpose long-tail; **stretch** = generic-calculator competition;
**reach-only** = head term, hidden-field reach at most. No ranking position is
guaranteed.

| Likely search (de) | Lane | Covered in | Rationale |
|---|---|---|---|
| Geburtszeitkorrektur | compete | keyword `geburtszeitkorrektur`; description | The exact job; uncontested by a like-for-like app. |
| Geburtszeit berechnen | compete | keyword `berechnen`; name "Geburtszeit finden"; short desc | High-intent calculator query in the highest-signal slots. |
| Geburtszeit unbekannt | compete | keyword `unbekannt`; description ("unbekannte Geburtszeit") | Names the user's exact problem state. |
| Aszendent berechnen | stretch | keyword `aszendent`; description ("Aszendent") | Generic chart-calc competition is heavy; targeted as reach. |
| Radix / Häuser | reach-only | keywords `radix`, `häuser` (hidden field) | Supporting chart vocabulary; never in the visible title/subtitle. |

**Avoided on purpose:** Horoskop, Sternzeichen, Wahrsagen, Hellsehen, Tarot,
Schicksal — raise 4.3(b)/misleading-claim risk and pull the wrong audience.

### 4.4 Owner / native-review checklist (de)

- [ ] Native de reviewer confirms tone is sober and exact (no over-promising).
- [ ] "Wahrscheinlichkeit", not "Konfidenz"; "Hinweise", not "Beweise".
- [ ] Informal **du** is consistent and on-brand for the target audience.
- [ ] Re-count name (28), subtitle (27), promo (163), keyword (89), Play short
      (74) in the consoles.
- [ ] Compound nouns do not overflow the localized in-app UI
      (`docs/l10n-strategy.md` §6/§11) — listing copy only here, but verify the
      same terms in-app.
- [ ] Privacy sentences match `docs/apple-privacy-labels.md` /
      `docs/play-data-safety.md`.

---

## 5. French (fr)

Large astrology audience, well-defined vocabulary. Watch the "preuve/confiance"
traps (`docs/l10n-strategy.md` §8.2).

### 5.1 App Store package (fr)

**App name — limit 30**

```
TrueRise: Heure de naissance
```

(28)

**Subtitle — limit 30**

```
Estimez votre heure probable
```

(28) Honest-confidence verb ("estimez") + "probable".
Alternative (27): `Heure de naissance inconnue`.

**Promotional text — limit 170**

```
Estimez votre heure de naissance inconnue à partir des événements dont vous vous souvenez. En privé, sur votre appareil. Partagez le résultat, jamais vos données.
```

(162)

**iOS keyword field — limit 100 (comma-separated, NO spaces)**

```
rectification,ascendant,calculer,inconnue,thème,natal,maisons,signe
```

(67) Room to spare — a native reviewer may add one or two long-tail terms
(e.g. `naissance`, `astrologie`) if relevant; re-count after any edit.

**Full description**

```
Connaissez-vous votre heure de naissance exacte ? La plupart des gens l'ignorent. Sans elle, votre ascendant et vos maisons restent incertains. TrueRise estime votre heure de naissance la plus probable à partir des événements de vie dont vous vous souvenez, et vous montre les indices derrière chaque heure candidate.

COMMENT ÇA MARCHE
- Indiquez une plage horaire approximative (ou précisez que vous ne la connaissez pas) et votre lieu de naissance.
- Ajoutez quelques événements de vie datés : déménagements, relations, tournants professionnels, moments familiaux, et plus encore.
- TrueRise évalue les heures candidates avec des méthodes astrologiques de temporalité (transits et progressions) et les classe par niveau de confiance.
- Ouvrez la vue des indices pour voir, événement par événement, pourquoi chaque candidate a obtenu son score.

HONNÊTE PAR CONCEPTION
Une rectification est une estimation, pas une certitude. Chaque résultat est présenté comme l'heure la plus probable, avec un niveau de confiance et quelques candidates alternatives. Ce n'est jamais une réponse garantie ni une prédiction sur votre avenir. Plus vous ajoutez d'événements datés, plus l'estimation se précise.

PRIVÉ PAR DÉFAUT
- Vos données de naissance et vos événements de vie sont stockés sur votre appareil.
- Aucun compte, aucune inscription, aucun profil.
- Le mode démo déroule tout le parcours hors ligne, sans réseau ni clé, pour que vous puissiez l'essayer avant de saisir vos données.
- Une touche dans les réglages efface toutes vos données.
- Un calcul en direct envoie vos données de naissance et d'événements à un fournisseur de calcul via une connexion sécurisée, uniquement pour calculer votre résultat. Jamais pour la publicité ou le suivi.

PARTAGER SANS TROP EN DIRE
Partagez votre résultat en une courte ligne : heure estimée, ascendant et niveau de confiance. Sans date de naissance, lieu de naissance ni événements de vie. Vous partagez le résultat. Vos données privées restent avec vous.

POUR QUI
Pour toute personne dont l'heure de naissance est inconnue ou incertaine et qui souhaite son ascendant et ses maisons. TrueRise est un calculateur d'heure de naissance ciblé, pas un fil d'horoscope.

TrueRise fournit des estimations astrologiques de l'heure de naissance à titre d'intérêt personnel. Il ne fournit aucun conseil médical, psychologique, juridique ou financier, et ses résultats ne sont pas déterministes.

Essayez la démo gratuite et hors ligne. Aucune heure de naissance requise pour commencer.
```

(2518)

### 5.2 Google Play package (fr)

**Title — limit 30**

```
TrueRise: Heure de naissance
```

(28)

**Short description — limit 80**

```
Estimez votre heure de naissance inconnue à partir de vos événements de vie.
```

(76)

**Full description — limit 4000:** use the §5.1 App Store full description
verbatim (2518).

**Category / tags:** Category **Lifestyle**; tags *Lifestyle*, *Calculator*;
at most one astrology tag, secondary. `[PROPOSED]`

### 5.3 ASO rationale & query mapping (fr)

| Likely search (fr) | Lane | Covered in | Rationale |
|---|---|---|---|
| rectification heure de naissance | compete | keyword `rectification`; description | Core job; uncontested long-tail. |
| trouver / calculer mon heure de naissance | compete | keyword `calculer`; name "Heure de naissance"; short desc | High-intent in the visible slots. |
| heure de naissance inconnue | compete | keyword `inconnue`; subtitle alt; description | Names the exact problem state. |
| calcul ascendant | stretch | keyword `ascendant`; description | Generic chart-calc competition; targeted as reach. |
| thème natal / maisons | reach-only | keywords `thème`, `natal`, `maisons` (hidden) | Supporting chart vocabulary, hidden field only. |

**Avoided on purpose:** horoscope, voyance, signe astrologique (as a head
category), médium, tarot, destin.

### 5.4 Owner / native-review checklist (fr)

- [ ] Native fr reviewer confirms "niveau de confiance" (not bare "confiance")
      and "indices" (not "preuve").
- [ ] Spacing before `?`/`:` matches French typography in console rendering.
- [ ] Re-count name (28), subtitle (28), promo (162), keyword (67), Play short
      (76).
- [ ] Optional long-tail keyword additions re-counted if added.
- [ ] Privacy sentences match the authoritative data-posture docs.

---

## 6. Spanish (es)

Use inverted `¿ ¡`. Avoid "pruebas" for evidence; prefer "indicios" and
"nivel de confianza"/"probabilidad" (`docs/l10n-strategy.md` §8.3). This draft
targets a broad, region-neutral Spanish; a reviewer should confirm it reads well
for the primary target markets.

### 6.1 App Store package (es)

**App name — limit 30**

```
TrueRise: Hora de nacimiento
```

(28)

**Subtitle — limit 30**

```
Estima tu hora probable
```

(23) Alternative (27): `Hora de nacimiento incierta`.

**Promotional text — limit 170**

```
Estima tu hora de nacimiento desconocida a partir de los eventos de tu vida que recuerdas: en privado, en tu dispositivo. Comparte el resultado, nunca tus datos.
```

(161)

**iOS keyword field — limit 100 (comma-separated, NO spaces)**

```
rectificación,ascendente,desconocida,calcular,calculadora,carta,natal,casas,signo
```

(81)

**Full description**

```
¿Conoces tu hora de nacimiento exacta? La mayoría no la conoce, y sin ella tu ascendente y tus casas quedan inciertos. TrueRise estima tu hora de nacimiento más probable a partir de los eventos de tu vida que recuerdas, y te muestra los indicios detrás de cada hora candidata.

CÓMO FUNCIONA
- Indica una franja horaria aproximada (o marca que no la sabes) y tu lugar de nacimiento.
- Añade algunos eventos de vida con fecha: mudanzas, relaciones, giros profesionales, momentos familiares y más.
- TrueRise puntúa las horas candidatas con métodos astrológicos de temporalidad (tránsitos y progresiones) y las ordena por nivel de confianza.
- Abre la vista de indicios para ver, evento por evento, por qué cada candidata obtuvo su puntuación.

HONESTO POR DISEÑO
Una rectificación es una estimación, no una certeza. Cada resultado se muestra como la hora más probable, con un nivel de confianza y algunas candidatas alternativas; nunca como una respuesta garantizada ni como una predicción sobre tu futuro. Cuantos más eventos con fecha añadas, más sólida será la estimación.

PRIVADO POR DEFECTO
- Tus datos de nacimiento y tus eventos de vida se guardan en tu dispositivo.
- Sin cuenta, sin registro, sin perfil.
- El modo demo recorre todo el proceso sin conexión (sin red ni clave) para que lo pruebes antes de introducir nada real.
- Un toque en los ajustes borra todos tus datos.
- Un cálculo real envía tus datos de nacimiento y de eventos a un proveedor de cálculo a través de una conexión segura, solo para calcular tu resultado; nunca para publicidad ni seguimiento.

COMPARTE SIN REVELAR DE MÁS
Comparte tu resultado en una línea breve (hora estimada, ascendente y nivel de confianza) sin fecha de nacimiento, lugar de nacimiento ni eventos de vida. Tu hallazgo viaja; tus datos privados se quedan contigo.

PARA QUIÉN ES
Para cualquiera con una hora de nacimiento desconocida o incierta que quiera su ascendente y sus casas: una calculadora de hora de nacimiento enfocada, no un feed de horóscopos.

TrueRise ofrece estimaciones astrológicas de la hora de nacimiento por interés personal. No ofrece asesoramiento médico, psicológico, legal ni financiero, y sus resultados no son deterministas.

Prueba la demo gratuita y sin conexión: no necesitas ninguna hora de nacimiento para empezar.
```

(2299)

### 6.2 Google Play package (es)

**Title — limit 30**

```
TrueRise: Hora de nacimiento
```

(28)

**Short description — limit 80**

```
Estima tu hora de nacimiento desconocida a partir de tus eventos de vida.
```

(73)

**Full description — limit 4000:** use the §6.1 App Store full description
verbatim (2299).

**Category / tags:** Category **Lifestyle**; tags *Lifestyle*, *Calculator*;
at most one astrology tag, secondary. `[PROPOSED]`

### 6.3 ASO rationale & query mapping (es)

| Likely search (es) | Lane | Covered in | Rationale |
|---|---|---|---|
| rectificación hora de nacimiento | compete | keyword `rectificación`; description | Core job; uncontested long-tail. |
| calcular hora de nacimiento | compete | keywords `calcular`,`calculadora`; name; short desc | High-intent calculator query in visible slots. |
| hora de nacimiento desconocida | compete | keyword `desconocida`; promo; description | Names the exact problem state. |
| calculadora ascendente | stretch | keywords `ascendente`,`calculadora` | Generic chart-calc competition; targeted as reach. |
| carta natal / casas | reach-only | keywords `carta`,`natal`,`casas`,`signo` (hidden) | Supporting chart vocabulary, hidden field only. |

**Avoided on purpose:** horóscopo, zodiaco, videncia, tarot, adivinación,
destino.

### 6.4 Owner / native-review checklist (es)

- [ ] Native es reviewer confirms "indicios" (not "pruebas") and
      "nivel de confianza"/"probabilidad" wording.
- [ ] Inverted `¿ ¡` present and correct throughout.
- [ ] Region fit confirmed for the primary target market(s).
- [ ] Re-count name (28), subtitle (23), promo (161), keyword (81), Play short
      (73).
- [ ] Privacy sentences match the authoritative data-posture docs.

---

## 7. Brazilian Portuguese (pt-BR)

Use **horário** (not *hora*) and **compartilhar** (not *partilhar*); "indícios"
over "provas" (`docs/l10n-strategy.md` §8.4). The full description adds the "10
or more events" nuance practitioners expect.

> **App-name constraint.** The highest-intent phrase
> `TrueRise: Horário de nascimento` is **31** chars — over the 30 limit — so it
> is **rejected** as the app name. Primary name uses `Horário natal` (23) to
> keep the BR "horário"; the full "horário de nascimento" phrase is carried in
> the subtitle, short description, and full description instead, where it has no
> hard limit.

### 7.1 App Store package (pt-BR)

**App name — limit 30**

```
TrueRise: Horário natal
```

(23) Rejected high-intent alternative (31, over limit):
`TrueRise: Horário de nascimento`.

**Subtitle — limit 30**

```
Seu horário de nascimento
```

(25) Carries the full high-intent phrase the name cannot.
Alternative (29): `Descubra seu horário provável`.

**Promotional text — limit 170**

```
Estime seu horário de nascimento desconhecido a partir dos eventos que você lembra: de forma privada, no seu aparelho. Compartilhe o resultado, nunca seus dados.
```

(161)

**iOS keyword field — limit 100 (comma-separated, NO spaces)**

```
retificação,ascendente,desconhecido,calcular,mapa,astral,casas,signo
```

(68)

**Full description**

```
Você sabe seu horário de nascimento exato? A maioria das pessoas não sabe. Sem ele, seu ascendente e suas casas ficam incertos. O TrueRise estima seu horário de nascimento mais provável a partir dos eventos de vida que você lembra e mostra os indícios por trás de cada horário candidato.

COMO FUNCIONA
- Informe uma faixa de horário aproximada (ou marque que não sabe) e seu local de nascimento.
- Adicione alguns eventos de vida com data: mudanças, relacionamentos, viradas na carreira, momentos de família e mais.
- O TrueRise pontua os horários candidatos com métodos astrológicos de temporalidade (trânsitos e progressões) e os ordena por nível de confiança.
- Abra a visão de indícios para ver, evento por evento, por que cada candidato recebeu sua pontuação.

HONESTO POR CONCEPÇÃO
Uma retificação é uma estimativa, não uma certeza. Cada resultado aparece como o horário mais provável, com um nível de confiança e alguns candidatos alternativos. Nunca é uma resposta garantida nem uma previsão sobre seu futuro. Quanto mais eventos com data você adicionar (muitos praticantes usam 10 ou mais), mais sólida fica a estimativa.

PRIVADO POR PADRÃO
- Seus dados de nascimento e seus eventos de vida ficam no seu aparelho.
- Sem conta, sem cadastro, sem perfil.
- O modo demo percorre todo o fluxo off-line (sem rede e sem chave) para você experimentar antes de inserir qualquer dado real.
- Um toque nas configurações apaga todos os seus dados.
- Um cálculo ao vivo envia seus dados de nascimento e de eventos a um provedor de cálculo por uma conexão segura, apenas para calcular seu resultado. Nunca para publicidade ou rastreamento.

COMPARTILHE SEM EXPOR DEMAIS
Compartilhe seu resultado em uma linha curta: horário estimado, ascendente e nível de confiança. Sem data de nascimento, local de nascimento ou eventos de vida. Você compartilha o resultado. Seus dados privados ficam com você.

PARA QUEM É
Para quem tem um horário de nascimento desconhecido ou incerto e quer seu ascendente e suas casas: uma calculadora de horário de nascimento focada, não um feed de horóscopos.

O TrueRise oferece estimativas astrológicas do horário de nascimento por interesse pessoal. Não oferece orientação médica, psicológica, jurídica ou financeira, e seus resultados não são determinísticos.

Experimente a demo gratuita e off-line: você não precisa de nenhum horário de nascimento para começar.
```

(2390)

### 7.2 Google Play package (pt-BR)

**Title — limit 30**

```
TrueRise: Horário natal
```

(23)

**Short description — limit 80**

```
Estime seu horário de nascimento desconhecido pelos eventos da sua vida.
```

(72)

**Full description — limit 4000:** use the §7.1 App Store full description
verbatim (2390).

**Category / tags:** Category **Lifestyle**; tags *Lifestyle*, *Calculator*;
at most one astrology tag, secondary. `[PROPOSED]`

### 7.3 ASO rationale & query mapping (pt-BR)

| Likely search (pt-BR) | Lane | Covered in | Rationale |
|---|---|---|---|
| retificação hora/horário de nascimento | compete | keyword `retificação`; description | Core job; uncontested long-tail. |
| calcular horário de nascimento | compete | keyword `calcular`; subtitle; short desc | High-intent calculator query in visible slots. |
| horário de nascimento desconhecido | compete | keyword `desconhecido`; promo; description | Names the exact problem state. |
| calcular ascendente | stretch | keyword `ascendente`; description | Generic chart-calc competition; targeted as reach. |
| mapa astral / casas | reach-only | keywords `mapa`,`astral`,`casas`,`signo` (hidden) | Supporting chart vocabulary, hidden field only. |

**Avoided on purpose:** horóscopo, zodíaco, vidência, tarô, adivinhação,
destino.

### 7.4 Owner / native-review checklist (pt-BR)

- [ ] Native pt-BR reviewer confirms "horário"/"compartilhar" and "indícios"
      (not "provas").
- [ ] Confirm "Horário natal" reads naturally as the app name vs. the rejected
      31-char "Horário de nascimento".
- [ ] "10 ou mais" nuance is acceptable and not over-claiming for the market.
- [ ] Re-count name (23), subtitle (25), promo (161), keyword (68), Play short
      (72).
- [ ] Privacy sentences match the authoritative data-posture docs.

---

## 8. Character-count summary (all hard-limited fields)

Counts are Unicode code points after NFC normalization (portable proxy;
consoles authoritative — see §0.3). Generated by the verification script in §9.

| Locale | Field | Limit | Count | Status |
|---|---|---:|---:|---|
| de | App Store name | 30 | 28 | OK |
| de | Subtitle | 30 | 27 | OK |
| de | Subtitle (alt) | 30 | 20 | OK |
| de | Promo text | 170 | 163 | OK |
| de | Keyword field | 100 | 89 | OK |
| de | Play title | 30 | 28 | OK |
| de | Play short desc | 80 | 74 | OK |
| de | Full description | 4000 | 2388 | OK |
| fr | App Store name | 30 | 28 | OK |
| fr | Subtitle | 30 | 28 | OK |
| fr | Subtitle (alt) | 30 | 27 | OK |
| fr | Promo text | 170 | 162 | OK |
| fr | Keyword field | 100 | 67 | OK |
| fr | Play title | 30 | 28 | OK |
| fr | Play short desc | 80 | 76 | OK |
| fr | Full description | 4000 | 2518 | OK |
| es | App Store name | 30 | 28 | OK |
| es | Subtitle | 30 | 23 | OK |
| es | Subtitle (alt) | 30 | 27 | OK |
| es | Promo text | 170 | 161 | OK |
| es | Keyword field | 100 | 81 | OK |
| es | Play title | 30 | 28 | OK |
| es | Play short desc | 80 | 73 | OK |
| es | Full description | 4000 | 2299 | OK |
| pt-BR | App Store name | 30 | 23 | OK |
| pt-BR | App Store name (rejected alt) | 30 | 31 | over (documented) |
| pt-BR | Subtitle | 30 | 25 | OK |
| pt-BR | Subtitle (alt) | 30 | 29 | OK |
| pt-BR | Promo text | 170 | 161 | OK |
| pt-BR | Keyword field | 100 | 68 | OK |
| pt-BR | Play title | 30 | 23 | OK |
| pt-BR | Play short desc | 80 | 72 | OK |
| pt-BR | Full description | 4000 | 2390 | OK |

Keyword fields contain no space after any comma (iOS counts spaces); verified in
§9.

---

## 9. Verification & sources

**Character-count method.** Counts above were produced by a throwaway script
(run from outside the repo so it does not alter the working tree) that NFC-
normalizes each string, counts code points, checks it against the field limit,
checks every keyword field for an accidental `", "`, and — with this document
present — asserts every counted string appears in it verbatim, so the published
counts provably belong to the published strings. The script is **not** committed
(documentation-only scope).

**Preserved conclusions / sources (read-only this run):**

- `docs/store-listing-en.md` — Tier 0 English listing: structure, compliance
  guardrails (§6), canonical reviewer notes (§2.6 / §3.5), English screenshot
  captions (§5).
- `docs/l10n-strategy.md` — locale priority (§3), brand rule (§4), terminology
  tables (§7), per-locale tone/risk (§8), store-metadata direction (§9).
- `docs/growth-thesis.md` §7.2 — per-locale long-tail keyword candidates.
- `docs/aso-naming-strategy.md` — naming options and blocked (Group D) terms.
- `docs/store-submission-readiness.md` — policy guardrails and reviewer-note
  language.

No app code, ARB, config, asset, screenshot, pubspec, test, README, or
privacy/data-safety doc was changed in this run. No secrets are present. These
drafts are `[PROPOSED]` and require the §0 gates — above all native-speaker
review — before any are entered into App Store Connect or Play Console.
