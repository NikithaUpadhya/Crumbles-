import 'package:crumbles/features/authentication/screens/home/new_articles/news_articles.dart';
import 'package:flutter/material.dart';

 
class ArticleDetailPage extends StatelessWidget {
  final NewsArt newsArt;
 
  ArticleDetailPage({required this.newsArt});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Article Details')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInImage.assetNetwork(
              height: 300,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              placeholder: "assets/img/placeholder.jfif",
              image: newsArt.imgUrl,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    newsArt.newsHead,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    newsArt.newsDes,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  SizedBox(height: 16),
                  Text(
                    newsArt.newsCnt,
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}