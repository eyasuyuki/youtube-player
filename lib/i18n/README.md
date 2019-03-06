## generate arb

Use these commant at project root.

```
flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/i18n ./lib/i18n/Strings.dart
```

## generate .dart

```
flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/i18n --no-use-deferred-loading lib/i18n/Strings.dart lib/i18n/intl_messages.arb
```
