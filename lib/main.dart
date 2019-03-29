import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:material_search/material_search.dart';
import 'package:flutter_youtube_view/flutter_youtube_view.dart';

import 'l10n/app_localizations.dart';

import '_youtube_api.dart';
import '_video_list.dart';
import '_video_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  Route _getRoute(RouteSettings settings) {
    Map<String, String> arg = settings.arguments;
    String videoId;
    if (arg != null) {
      videoId = arg['videoId'];
    }
    switch (settings.name) {
      case '/player':
        return new MaterialPageRoute(builder: (BuildContext context) {
          return new VideoPlayer(videoId: videoId);
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
