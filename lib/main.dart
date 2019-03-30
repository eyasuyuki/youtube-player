import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/widgets.dart';

import 'l10n/app_localizations.dart';

import '_video_list.dart';
import '_video_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  Route _getRoute(RouteSettings settings) {
    PlayList playList = settings.arguments;
    String videoId;
    switch (settings.name) {
      case '/player':
        return new MaterialPageRoute(builder: (BuildContext context) {
          return new VideoPlayer(playList: playList);
        });
      case '/':
      default:
        return new MaterialPageRoute(builder: (BuildContext context) {
          return new VideoList();
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: _getRoute,
      localizationsDelegates: [
        const _MyLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', "US"),
        const Locale('ja', 'JP'),
      ],
    );
  }
}

class _MyLocalizationsDelegate extends LocalizationsDelegate<Strings> {
  const _MyLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ja'].contains(locale.languageCode);

  @override
  Future<Strings> load(Locale locale) => Strings.load(locale);

  @override
  bool shouldReload(_MyLocalizationsDelegate old) => false;
}
