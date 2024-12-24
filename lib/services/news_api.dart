library echo_flutter_news_package;

import 'dart:convert';
import 'package:echo_flutter_news/models/response.dart';
import 'package:http/http.dart' as http;

const String BASE_URL = "newsapi.org";

class NewsAPI {
  final String apiKey;
  final String BASE_URL = "newsapi.org";

  NewsAPI(this.apiKey);

  Future<ResponseModel> getArticles({
    required String sortBy,
    required String query,
    String? category,
    int pageSize = 20,
    int page = 1,
  }) async {
    final bool useEverything = category == null;
    final String endpoint = useEverything ? "everything" : "top-headlines";

    Map<String, dynamic> queryParameters = {
      'apiKey': apiKey,
      'pageSize': pageSize.toString(),
      'page': page.toString(),
    };

    if (useEverything) {
      // For everything endpoint, we need at least one required parameter
      queryParameters.addAll({
        'sortBy': sortBy,
        'language': 'en',
        // If no query provided, use default domains to ensure valid request
        'q': query.isNotEmpty ? query : 'news',  // Default search term if no query
        'domains': 'bbc.com,cnn.com,reuters.com,nytimes.com',  // Default trusted sources
      });
    } else {
      queryParameters.addAll({
        'category': category,
        'country': 'us',
        if (query.isNotEmpty) 'q': query,
      });
    }

    try {
      final uri = Uri.https(BASE_URL, '/v2/$endpoint', queryParameters);
      
      print('=================== API Call Debug ===================');
      print('Endpoint: $endpoint');
      print('Full URI: $uri');
      print('Query Parameters:');
      queryParameters.forEach((key, value) => print('  $key: $value'));

      final response = await http.get(
        uri,
        headers: {'X-Api-Key': apiKey},
      ).timeout(const Duration(seconds: 10));

      print('=================== Response Debug ===================');
      print('Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        print('Total Results: ${decodedResponse['totalResults']}');
        if (decodedResponse['articles']?.isNotEmpty ?? false) {
          print('First article title: ${decodedResponse['articles'][0]['title']}');
          print('First article image: ${decodedResponse['articles'][0]['urlToImage']}');
        }
        return ResponseModel.fromJson(decodedResponse);
      } else {
        print('Error Response: ${response.body}');
        return ResponseModel(
          "error",
          null,
          null,
          "apiError",
          "API error: ${response.statusCode} - ${response.reasonPhrase}",
        );
      }
    } catch (e, stackTrace) {
      print('API Exception: $e');
      print('Stack trace: $stackTrace');
      return ResponseModel(
        "error",
        null,
        null,
        "networkError",
        "Network error: ${e.toString()}",
      );
    }
  }
}