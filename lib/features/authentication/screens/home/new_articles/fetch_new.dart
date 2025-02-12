import 'dart:convert';
import 'package:crumbles/features/authentication/screens/home/new_articles/news_articles.dart';
import 'package:http/http.dart';
 
class FetchNews {
  static Future<List<NewsArt>> fetchNewsList() async {
    try {
      Response response = await get(Uri.parse(
          "https://newsapi.org/v2/everything?q=environment&domains=thestar.com.my,nst.com.my,malaymail.com,freemalaysiatoday.com&apiKey=6aba4fbb56d543b7ba7995843b45b62b"));
 
      if (response.statusCode == 200) {
        Map<String, dynamic> bodyData = jsonDecode(response.body);
        if (bodyData.containsKey('articles') && bodyData['articles'] is List) {
          List<dynamic> articles = bodyData['articles'];
          // Filter out articles without images
          List<NewsArt> newsArticles = articles
              .where((article) =>
                  article["urlToImage"] != null &&
                  article["urlToImage"].isNotEmpty)
              .map((article) => NewsArt.fromAPItoApp(article))
              .toList();
 
          return newsArticles;
        } else {
          throw Exception("Invalid response format: articles key not found");
        }
      } else {
        throw Exception("Failed to load articles: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching news: $e");
      throw Exception("Error fetching news: $e");
    }
  }
}
 