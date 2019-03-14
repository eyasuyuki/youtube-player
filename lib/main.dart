import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:material_search/material_search.dart';

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
  static const searchWordsKey = 'search_words';
  static const searchDataKey = 'search_data';
  static String word = null;
  @override
  void initState() {
    super.initState();
  }

  Future<List<String>> _getPreviousWords() async {
    var sp = await SharedPreferences.getInstance();
    List<String> result = sp.getStringList(searchWordsKey);
    print('_getPreviouseWords: result=' + result.toString()); //TODO debug
    if (result == null) result = new List<String>();
    return result;
  }

  void _setPreviousWords(String value, List<String> words) async {
    var sp = await SharedPreferences.getInstance();
    if (value != null && !words.contains(value)) {
      words.insert(0, value);
      sp.setStringList(searchWordsKey, words);
    }
  }

  Future<Map<String, dynamic>> _getPreviousData() async {
    var sp = await SharedPreferences.getInstance();
    var data = sp.getString(searchDataKey);
    print('_getPreviouseData: data=' + data == null
        ? 'null'
        : data.substring(0, 10)); //TODO debug
    if (data == null) {
      return null;
    } else {
      return json.decode(data);
    }
  }

  Future<Map<String, dynamic>> _search(String word) async {
    if (word == null) {
      // get previouse data
      var result = await _getPreviousData();
      if (result != null) {
        return result;
      }
    }

    var api = YouTubeApi();
    var result = await http.get(api.searcUri(word, Strings.of(context).apiKey));
    print(result.request.toString()); //TODO debug
    if (result == null) return null;
    print('_search: result.statusCode=' +
        result.statusCode.toString()); //TODO debug
    if (result.statusCode == 200) {
      var sp = await SharedPreferences.getInstance();
      await sp.setString(searchDataKey, result.body.toString());
    }
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

  _buildMaterialSearchPage(BuildContext context, List<String> words) {
    return new MaterialPageRoute<String>(
      settings: new RouteSettings(
        name: 'material_search',
        isInitialRoute: false,
      ),
      builder: (BuildContext context) {
        return new Material(
          child: new MaterialSearch<String>(
            placeholder: 'Search', // TODO localize
            results: words
                .map((String v) => new MaterialSearchResult<String>(
                      value: v,
                      text: v,
                    ))
                .toList(),
            filter: (dynamic value, String criteria) {
              return value.contains(new RegExp(r'' + criteria.trim()));
            },
            onSelect: (dynamic value) => Navigator.of(context).pop(value),
            onSubmit: (dynamic value) => Navigator.of(context).pop(value),
          ),
        );
      },
    );
  }

  _showMaterialSearch(BuildContext context, List<String> words) {
    Navigator.of(context)
        .push(_buildMaterialSearchPage(context, words))
        .then((dynamic value) {
      _setPreviousWords(value, words);
      setState(() {
        word = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(Strings.of(context).title),
        actions: <Widget>[
          new FutureBuilder(
            future: _getPreviousWords(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return new IconButton(
                onPressed: () {
                  _showMaterialSearch(context, snapshot.data);
                },
                tooltip: 'Search', // TODO localization
                icon: new Icon(Icons.search),
              );
            },
          ),
        ],
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
