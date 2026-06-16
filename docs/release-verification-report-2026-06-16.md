# Release Verification Report - 2026-06-16 (TrueRise)

**Purpose.** A point-in-time record of the local verification commands run on
2026-06-16 and their exact outcomes. It captures what the **engineering / local
check** side proves on this date and, separately, what still blocks submission
on the **owner / backend / legal / store** side.

**This report does not change any blocker status and does not unblock the
release.** Passing local checks means the working tree is engineering-clean; it
does **not** mean the app is submittable. The authoritative status doc remains
`docs/publication-readiness-current-status.md` (per-blocker reconciliation); if
this snapshot ever disagrees with it, that doc wins. The condensed owner handoff
is `docs/release-handoff-owner-checklist.md`; the canonical command list with
expected outcomes is `docs/release-preflight-commands.md`.

**Toolchain.** Flutter 3.44 / Dart 3.12.

**Tree state.** Branch `main`, in sync with `origin/main` before this docs task;
last commit before this task `c9fe9e8` (`docs: add release handoff and preflight
checklist`); the working tree remained clean after the verification commands
below (this docs change is the only edit).

---

## 1. Passed local checks (engineering-clean on 2026-06-16)

All commands below ran locally and passed. None makes a live API call or spends
provider credit.

| # | Command | Result |
| --- | --- | --- |
| 1 | `git diff --check` | clean - no whitespace/conflict-marker errors |
| 2 | `flutter analyze` | `No issues found!` |
| 3 | `flutter test` | 648 tests, all passed |
| 4 | `flutter test integration_test/demo_flow_test.dart` | demo / offline flow, all passed |
| 5 | `flutter test test/tool/release_env_guard_test.dart` | 33 tests, all passed |
| 6 | `dart run tool/release_env_guard.dart --share-url=https://truerise.example --proxy-base-url=https://proxy.example --allow-bundled-key --purpose=review-capped` | exit 0 (3 OK/ACKNOWLEDGED lines) |
| 7 | `dart run tool/store_screenshot_compositor_dry_run.dart` | exit 0 - planned 25 composites across `en`/`de`/`fr`/`es`/`pt-BR`, wrote no files, rendered nothing |

Notes:

- **Command 6 used illustrative bare-HTTPS placeholders** (`https://truerise.example`,
  `https://proxy.example`), not the real owner share/proxy URLs. The pass proves
  the guard accepts well-formed `--flag=value` input and the bundled-key
  acknowledgement path - it is **not** evidence that the real share/proxy URLs
  exist, resolve, or are owned. Those remain owner/backend inputs (section 2).
- **Command 5 must run under `flutter test`**, not `dart test`: the file imports
  `package:flutter_test`, which the standalone Dart runner cannot compile. This
  is a runner choice, not a code defect.
- The `flutter test` count drifts as tests are added; 648 (2026-06-16) is the
  current recorded figure and supersedes the earlier +587 (2026-06-14) sweep.

---

## 2. Still blocking submission (owner / backend / legal / store)

None of the items below is an engineering artifact; none is decidable or doable
from code. They are reproduced here only as a pointer - the authoritative,
dependency-ordered list is `docs/publication-readiness-current-status.md` Sec.
5a (mirrored in `docs/release-handoff-owner-checklist.md` Sec. 2).

- **P0-3** Bundle-ID decision (irreversible after the first store record).
- **P0-2** Android upload keystore + Play App Signing; iOS distribution
  cert/profile.
- **P0-4** Host the privacy policy at a canonical public URL; build with and
  enter the same `TRUERISE_PRIVACY_POLICY_URL` in both consoles.
- **P0-5** Apple privacy labels + Play Data Safety: legal sign-off + console
  entry.
- **P0-10** Confirm category = Lifestyle in both consoles.
- **P0-11** Rotate the bundled demo/review key to a low-budget capped key (or
  remove it).
- Production proxy host + contract confirmation (backend); server-side
  anti-abuse / quota enforcement.
- Resolvable share/invite landing URL (`truerise.app` is an unverified
  placeholder).
- Support URL + Play support email/contact.
- Trademark clearance + App Store name availability for "TrueRise".
- Console character re-count + native-speaker review of localized copy/captions
  (gates localized listings, not EN Tier 0).
- Age-rating questionnaires consistent with the 18+ gate; Play target audience =
  adults.
- Device-matrix decision (iPad / Android tablet) affecting screenshot sets.

**No owner approval, legal sign-off, hosting, signing, or console action is
asserted as done by this report.**

---

## 3. Screenshot final-compositing status

- The dry-run CLI (command 7) **plans** all 25 composited screenshots across the
  5 supported locales and confirms it **wrote no files, created no directories,
  and rendered nothing**. `find screenshots/store -name composited -type d`
  returns no output - no final/composited PNGs exist in the repo.
- **Final composites are not ready.** The 5 canonical locale manifests
  (`screenshots/store/{en,de,fr,es,pt-BR}/manifest.json`) still carry the
  pre-Appeeky raw captures (`captionPlanStatus: pre_appeeky_reference_raw_captures`,
  `currentCaptionPlanRequiresNewFrames: true`); adopting the current post-Appeeky
  five-frame plan, capturing the new frames, and getting caption approval is what
  unblocks the guarded compositor write path.
- The two previously-missing post-Appeeky frames (problem hook, life events)
  exist only as clearly-labeled RAW DRAFT scratch frames in
  `screenshots/store/en-current-draft/`, which is deliberately **not** a
  supported store locale, so the compositor never consumes them.
- Remaining work is owner/design: caption/device compositing, native-speaker
  localized caption review, any additional device sizes the consoles require,
  final visual approval, and console upload. None is an engineering blocker.

---

## 4. Bottom line

On 2026-06-16 the local engineering checks pass (analyze clean, 648 tests green,
release guard and screenshot dry-run pass, tree clean). The release stays **not
submittable** because every open item in section 2 is an owner / backend / legal
/ store action. This report records evidence only; it confers no approval and
changes no blocker status.
