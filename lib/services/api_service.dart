import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article_model.dart';

class ApiService {
  static const String baseUrl = 'https://api.spaceflightnewsapi.net/v4';

  Future<List<Article>> fetchArticles(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$endpoint/'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Article> articles = [];

        for (var item in data['results']) {
          articles.add(Article.fromJson(item));
        }

        return articles;
      } else {
        throw Exception('Failed to load articles');
      }
    } catch (e) {
      print('Error fetching articles: $e');
      throw Exception('Error: $e');
    }
  }

  Future<Article> fetchArticleDetail(String endpoint, int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$endpoint/$id/'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Article.fromJson(data);
      } else {
        throw Exception('Failed to load article detail');
      }
    } catch (e) {
      print('Error fetching article detail: $e');
      throw Exception('Error: $e');
    }
  }
}
