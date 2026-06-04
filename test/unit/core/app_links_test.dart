import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/core/app_links.dart';

/// These tests pin the privacy + configurability invariant for the single
/// share/invite link source of truth ([AppLinks.shareUrl]).
///
/// [AppLinks.shareUrl] is a compile-time constant
/// (`String.fromEnvironment('TRUERISE_SHARE_URL', ...)`), so its *runtime*
/// value inside one test process is fixed to whatever was baked in at
/// compile time (the default, unless the suite itself is run with
/// `--dart-define`). To still cover the **owner-supplied custom URL path**
/// without mutating the environment at runtime, the contract is extracted
/// into the pure [AppLinks.isPrivacySafeShareUrl] validator and exercised
/// here with representative custom values.
void main() {
  group('AppLinks.shareUrl default invariant', () {
    test('default share URL is a bare HTTPS URL', () {
      expect(AppLinks.shareUrl, startsWith('https://'));
    });

    test('default share URL carries no query string / tracking params', () {
      expect(AppLinks.shareUrl, isNot(contains('?')));
      expect(AppLinks.shareUrl, isNot(contains('utm')));
      expect(AppLinks.shareUrl, isNot(contains('ref=')));
    });

    test('default share URL carries no fragment', () {
      expect(AppLinks.shareUrl, isNot(contains('#')));
    });

    test('default share URL passes the privacy-safe validator', () {
      expect(AppLinks.isPrivacySafeShareUrl(AppLinks.shareUrl), isTrue);
    });

    test('landing aliases the same single source of truth', () {
      expect(AppLinks.landing, AppLinks.shareUrl);
    });
  });

  group('AppLinks.isPrivacySafeShareUrl - owner-configurable URL path', () {
    test('accepts representative owner-supplied bare HTTPS URLs', () {
      // Stand-ins for whatever the owner bakes in via
      // --dart-define=TRUERISE_SHARE_URL=... before release.
      expect(AppLinks.isPrivacySafeShareUrl('https://truerise.app'), isTrue);
      expect(
        AppLinks.isPrivacySafeShareUrl('https://get.truerise.app'),
        isTrue,
      );
      expect(
        AppLinks.isPrivacySafeShareUrl(
          'https://apps.apple.com/app/id123456789',
        ),
        isTrue,
      );
    });

    test('rejects non-HTTPS schemes', () {
      expect(AppLinks.isPrivacySafeShareUrl('http://truerise.app'), isFalse);
      expect(AppLinks.isPrivacySafeShareUrl('ftp://truerise.app'), isFalse);
    });

    test(
      'rejects a URL carrying a query string (tracking params live here)',
      () {
        expect(
          AppLinks.isPrivacySafeShareUrl(
            'https://truerise.app/?utm_source=share',
          ),
          isFalse,
        );
        expect(
          AppLinks.isPrivacySafeShareUrl('https://truerise.app?ref=abc123'),
          isFalse,
        );
      },
    );

    test('rejects a URL carrying a fragment', () {
      expect(
        AppLinks.isPrivacySafeShareUrl('https://truerise.app/#promo'),
        isFalse,
      );
    });

    test('rejects a URL embedding userinfo (could carry an identifier)', () {
      expect(
        AppLinks.isPrivacySafeShareUrl('https://user@truerise.app'),
        isFalse,
      );
    });

    test('rejects empty, scheme-less, or hostless input', () {
      expect(AppLinks.isPrivacySafeShareUrl(''), isFalse);
      expect(AppLinks.isPrivacySafeShareUrl('truerise.app'), isFalse);
      expect(AppLinks.isPrivacySafeShareUrl('https:///path'), isFalse);
    });
  });
}
