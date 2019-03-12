# youtube_player

Flutter YouTube player example

![YouTube player example](https://raw.githubusercontent.com/eyasuyuki/youtube-player/images/youtube_player.png)

## Getting Started

- Create project at Google Developer Console. ( https://console.developers.google.com )
- Create YouTube API Key at Google Developer Console.
- Edit lib/l10n/app_localizations.dart, Put your YouTube API Key to  ```String get apiKey => '<YouTube API Key>';```.

## Localization

### Re-generate .arb from .dart
 
Use these commant at project root.

```
flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/l10n/app_localizations.dart
```

### Re-generate .dart from .arb

```
flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/l10n/app_localizations.dart lib/l10n/intl_*.arb
```

## ToDo

- Implement player screen

