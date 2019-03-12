class YouTubeApi {
  static const baseUri = 'www.googleapis.com';
  static const youTubeEndpoint = 'youtube/v3/search';

  Uri searcUri(String word, String key) {
    return Uri.https(baseUri, youTubeEndpoint, getOptions(word, key));
  }

  Map<String, String> getOptions(String word, String key) {
    Map<String, String> result = {
      'part': 'snippet',
      'maxResults': '10',
      'key': key,
    };
    if (word != null && word.length > 0) result['q'] = word;
    return result;
  }
}
