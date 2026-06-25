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
      expect(AppLinks.isPrivacySafeShareUrl('https://example.com'), isTrue);
      expect(
        AppLinks.isPrivacySafeShareUrl('https://get.example.com'),
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
      expect(AppLinks.isPrivacySafeShareUrl('http://example.com'), isFalse);
      expect(AppLinks.isPrivacySafeShareUrl('ftp://example.com'), isFalse);
    });

    test(
      'rejects a URL carrying a query string (tracking params live here)',
      () {
        expect(
          AppLinks.isPrivacySafeShareUrl(
            'https://example.com/?utm_source=share',
          ),
          isFalse,
        );
        expect(
          AppLinks.isPrivacySafeShareUrl('https://example.com?ref=abc123'),
          isFalse,
        );
      },
    );

    test('rejects a URL carrying a fragment', () {
      expect(
        AppLinks.isPrivacySafeShareUrl('https://example.com/#promo'),
        isFalse,
      );
    });

    test('rejects a URL embedding userinfo (could carry an identifier)', () {
      expect(
        AppLinks.isPrivacySafeShareUrl('https://user@example.com'),
        isFalse,
      );
    });

    test('rejects empty, scheme-less, or hostless input', () {
      expect(AppLinks.isPrivacySafeShareUrl(''), isFalse);
      expect(AppLinks.isPrivacySafeShareUrl('example.com'), isFalse);
      expect(AppLinks.isPrivacySafeShareUrl('https:///path'), isFalse);
    });
  });

  group('AppLinks.versionCheckUrl default invariant', () {
    test('the update check ships disabled: default URL is empty', () {
      // No fake or unowned endpoint is ever called. The owner must opt in
      // with --dart-define=TRUERISE_VERSION_CHECK_URL=... to enable it.
      expect(AppLinks.versionCheckUrl, isEmpty);
    });
  });

  group('AppLinks.privacyPolicyUrl default invariant', () {
    test('the hosted privacy policy ships disabled: default URL is empty', () {
      // The Settings row keeps pushing the bundled in-app screen. The
      // owner must opt in with
      // --dart-define=TRUERISE_PRIVACY_POLICY_URL=... to enable it.
      expect(AppLinks.privacyPolicyUrl, isEmpty);
    });

    test('an empty value never passes the bare-HTTPS validator', () {
      // The same validator gates the hosted path, so empty == disabled.
      expect(
        AppLinks.isPrivacySafeShareUrl(AppLinks.privacyPolicyUrl),
        isFalse,
      );
    });
  });

  group('AppLinks.isPrivacySafeStoreUrl', () {
    test('accepts bare HTTPS store URLs', () {
      expect(
        AppLinks.isPrivacySafeStoreUrl('https://apps.apple.com/app/id1234'),
        isTrue,
      );
      expect(
        AppLinks.isPrivacySafeStoreUrl('https://example.com/get'),
        isTrue,
      );
    });

    test('accepts the canonical Play Store web URL whose only query '
        'param is a non-empty application id', () {
      expect(
        AppLinks.isPrivacySafeStoreUrl(
          'https://play.google.com/store/apps/details?id=app.truerise',
        ),
        isTrue,
      );
    });

    test('rejects an id query param on any non-Play host', () {
      expect(
        AppLinks.isPrivacySafeStoreUrl(
          'https://apps.apple.com/app/id1234?id=app.truerise',
        ),
        isFalse,
      );
      expect(
        AppLinks.isPrivacySafeStoreUrl('https://example.com?id=app.truerise'),
        isFalse,
      );
    });

    test('rejects an id query param on a non-canonical Play path', () {
      expect(
        AppLinks.isPrivacySafeStoreUrl(
          'https://play.google.com/store/search?id=app.truerise',
        ),
        isFalse,
      );
      expect(
        AppLinks.isPrivacySafeStoreUrl(
          'https://play.google.com/store/apps/details/extra?id=app.truerise',
        ),
        isFalse,
      );
      expect(
        AppLinks.isPrivacySafeStoreUrl(
          'https://play.google.com?id=app.truerise',
        ),
        isFalse,
      );
    });

    test('rejects an empty or repeated application id', () {
      expect(
        AppLinks.isPrivacySafeStoreUrl(
          'https://play.google.com/store/apps/details?id=',
        ),
        isFalse,
      );
      expect(
        AppLinks.isPrivacySafeStoreUrl(
          'https://play.google.com/store/apps/details?id',
        ),
        isFalse,
      );
      expect(
        AppLinks.isPrivacySafeStoreUrl(
          'https://play.google.com/store/apps/details?id=a&id=b',
        ),
        isFalse,
      );
    });

    test('rejects any query parameter other than id (tracking lives '
        'in the query)', () {
      expect(
        AppLinks.isPrivacySafeStoreUrl(
          'https://play.google.com/store/apps/details'
          '?id=app.truerise&referrer=utm_source%3Dx',
        ),
        isFalse,
      );
      expect(
        AppLinks.isPrivacySafeStoreUrl(
          'https://apps.apple.com/app/id1234?utm_source=banner',
        ),
        isFalse,
      );
    });

    test('rejects non-HTTPS, userinfo, fragments, and hostless input', () {
      expect(
        AppLinks.isPrivacySafeStoreUrl('http://apps.apple.com/app/id1'),
        isFalse,
      );
      expect(
        AppLinks.isPrivacySafeStoreUrl('https://user@apps.apple.com/a'),
        isFalse,
      );
      expect(
        AppLinks.isPrivacySafeStoreUrl('https://apps.apple.com/a#frag'),
        isFalse,
      );
      expect(AppLinks.isPrivacySafeStoreUrl(''), isFalse);
      expect(AppLinks.isPrivacySafeStoreUrl('market://details?id=x'), isFalse);
    });
  });
}
