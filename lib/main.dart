import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'i18n/Strings.dart';

void main() => runApp(MyApp());

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
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
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
  static final apiKey = Platform.environment['YOUTUBE_API_KEY'];
  @override
  void initState() {
    super.initState();
  }

  void search(String text) {
  }

  @override
  Widget build(BuildContext context) {
    String title = apiKey;
    if (title == null) title = 'VideoList';
    return Scaffold(
      appBar: new AppBar(
        title: const Text('YouTube Player'),
      ),
      body: new Center(
        child: Text(title),
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
