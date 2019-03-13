class YouTubeApi {
  static const baseUri = 'www.googleapis.com';
  static const youTubeEndpoint = 'youtube/v3/search';

  Uri searcUri(String word, String key) {
    return Uri.https(baseUri, youTubeEndpoint, getOptions(word, key));
  }

  Map<String, String> getOptions(String word, String key) {
    Map<String, String> result = new Map<String, String>();
    if (word != null && !word.isEmpty) result['q'] = word;
    result['part'] = 'snippet';
    result['maxResults'] = '10';
    result['key'] = key;
    return result;
  }
}
