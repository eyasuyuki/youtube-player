import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:material_search/material_search.dart';

import 'l10n/app_localizations.dart';

import '_youtube_api.dart';

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

  void _setPreviousWords(String value) async {
    var sp = await SharedPreferences.getInstance();
    var words = sp.getStringList(searchWordsKey);
    if (words == null) words = new List<String>();
    if (value != null && !words.contains(value)) {
      words.insert(0, value);
      sp.setStringList(searchWordsKey, words);
    }
  }

  Future<Map<String, dynamic>> _getPreviousData() async {
    var sp = await SharedPreferences.getInstance();
    var data = sp.getString(searchDataKey);
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
    print('_search: request=' + result.request.toString()); //TODO debug
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
              onTap: () {
                final videoId = item['id']['videoId'];
                print('_getListItem: ListTile: videoId=' + videoId);
                Navigator.of(context).pushNamed(
                  '/player',
                  arguments: <String, String>{
                    'videoId': videoId,
                  },
                );
              },
            ))
        .toList());
  }

  List<MaterialSearchResult<String>> _buildMaterialSearchResult(
      List<String> data) {
    if (data == null) return new List<MaterialSearchResult<String>>();
    return data
        .map((String v) => new MaterialSearchResult<String>(
              value: v,
              text: v,
            ))
        .toList();
  }

  _buildMaterialSearchPage(BuildContext context) {
    return new MaterialPageRoute<String>(
      settings: new RouteSettings(
        name: 'material_search',
        isInitialRoute: false,
      ),
      builder: (BuildContext context) {
        return new FutureBuilder(
          future: _getPreviousWords(),
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            return new Material(
              child: new MaterialSearch<String>(
                placeholder: 'Search', // TODO localize
                results: _buildMaterialSearchResult(snapshot.data),
                filter: (dynamic value, String criteria) {
                  return value.contains(new RegExp(r'' + criteria.trim()));
                },
                onSelect: (dynamic value) => Navigator.of(context).pop(value),
                onSubmit: (dynamic value) => Navigator.of(context).pop(value),
              ),
            );
          },
        );
      },
    );
  }

  _showMaterialSearch(BuildContext context) {
    Navigator.of(context)
        .push(_buildMaterialSearchPage(context))
        .then((dynamic value) {
      _setPreviousWords(value);
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
          new IconButton(
            onPressed: () {
              _showMaterialSearch(context);
            },
            tooltip: 'Search', // TODO localization
            icon: new Icon(Icons.search),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _search(word),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
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
