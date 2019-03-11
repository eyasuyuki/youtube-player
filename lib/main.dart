import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n/app_localizations.dart';

import '_youtube_api.dart';

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
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => new VideoList(),
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
  bool isSupported(Locale locale) => ['en', 'ja'].contains(locale.languageCode);

  @override
  Future<Strings> load(Locale locale) => Strings.load(locale);

  @override
  bool shouldReload(_MyLocalizationsDelegate old) => false;
}

class VideoList extends StatefulWidget {
  @override
  _VideoListState createState() => new _VideoListState();
}

class _VideoListState extends State<VideoList> {
  static const searchWordKey = 'search_word';
  static const searchDataKey = 'search_data';
  static String word;
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    var sp = await SharedPreferences.getInstance();
    word = sp.get(searchWordKey);
  }

  Future<Map<String, dynamic>> _search(String word) async {
    var sp = await SharedPreferences.getInstance();
    var data = sp.get(searchDataKey);
    if (data != null) return json.decode(data);

    var api = YouTubeApi();
    var result = await http.get(api.searcUri(word, Strings.of(context).apiKey));
    if (result == null) return null;
    await sp.setString(searchDataKey, result.body.toString());
    return json.decode(result.body);
  }

  List<Widget> _getListItems(Map<String, dynamic> data) {
    if (data == null) return [];
    return new List<Widget>.from(data['items']
        .map((item) => ListTile(
              leading: Image.network(
                  item['snippet']['thumbnails']['default']['url']),
              title: Text(item['snippet']['title']),
              subtitle: Text(item['snippet']['description']),
            ))
        .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(Strings.of(context).title),
      ),
      body: FutureBuilder(
        future: _search(word),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          } else if (snapshot.data['error'] != null) {
            return Center(
              child: Text(json.encode(snapshot.data)),
            );
          } else {
            return ListView(children: _getListItems(snapshot.data));
          }
        },
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
