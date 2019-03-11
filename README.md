# youtube_player

Flutter YouTube player example

## Getting Started

- Create project at Google Developer Console. ( https://console.developers.google.com )
- Create YouTube API Key at Google Developer Console.
- Edit lib/l10n/app_localizations.dart ```String get apiKey => '<YouTube API Key>';``` to your YouTube API Key.

## generate .arb from .dart

Use these commant at project root.

```
flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/l10n/app_localizations.dart
```

## generate .dart from .arb

```
flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/l10n/app_localizations.dart lib/l10n/intl_*.arb
```
