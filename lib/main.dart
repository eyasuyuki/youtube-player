import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'l10n/messages_all.dart';
import 'l10n/messages_messages.dart';

void main() => runApp(MyApp());

class Strings {
  static Future<Strings> load(Locale locale) {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return new Strings();
    });
  }

  static Strings of(BuildContext context) {
    return Localizations.of<Strings>(context, Strings);
  }

  static final Strings instance = new Strings();

  static final MessageLookup defaultLookup = new MessageLookup();
  static final defaultTitle = defaultLookup.messages['title']();
  static final defaultApiKey = defaultLookup.messages['apiKey']();

  String get title => Intl.message(defaultTitle, name: "title");
  String get apiKey => Intl.message(defaultApiKey, name: "apiKey");
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder> {
        '/': (BuildContext context) => new Splash(),
        '/list': (BuildContext context) => new VideoList(),
        '/player': (BuildContext context) => new VideoPlayer(),
      },
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
  bool isSupported(Locale locale) => ['en','ja'].contains(locale.languageCode);

  @override
  Future<Strings> load(Locale locale) => Strings.load(locale);

  @override
  bool shouldReload(_MyLocalizationsDelegate old) => false;
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    new Future.delayed(const Duration(seconds: 3))
        .then((value) => handleTimeout());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
        child: const CircularProgressIndicator(),
      ),
    );
  }

  void handleTimeout() {
    Navigator.of(context).pushReplacementNamed('/list');
  }
}

class VideoList extends StatefulWidget {
  @override
  _VideoListState createState() => new _VideoListState();
}

class _VideoListState extends State<VideoList> {
  @override
  void initState() {
    super.initState();
  }

  void search(String text) {
    // TODO search
  }

  @override
  Widget build(BuildContext context) {
    var strings = Strings.of(context);
    var title = strings == null ? 'main: title: null' : strings.title;
    var apiKey = strings == null ? 'main: apiKey: null' : strings.apiKey;
    if (title == null) title = 'main: title: null';
    if (apiKey == null) apiKey = 'main: apiKey: null';
    return Scaffold(
      appBar: new AppBar(
        title: Text(title),
      ),
      body: new Center(
        child: Text(apiKey),
      ),
    );
  }
}

class VideoPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
        child: const Text('VideoPlayer'),
      ),
    );
  }

}
