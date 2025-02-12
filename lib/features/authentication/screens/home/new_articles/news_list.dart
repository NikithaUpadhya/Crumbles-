
import 'package:crumbles/features/authentication/screens/home/new_articles/articles_details_page.dart';
import 'package:crumbles/features/authentication/screens/home/new_articles/fetch_new.dart';
import 'package:crumbles/features/authentication/screens/home/new_articles/news_articles.dart';
import 'package:flutter/material.dart';

 
class NewsListPage extends StatefulWidget {
  const NewsListPage({Key? key}) : super(key: key);
 
  @override
  _NewsListPageState createState() => _NewsListPageState();
}
 
class _NewsListPageState extends State<NewsListPage> {
  late ScrollController _scrollController;
  bool _isLoading = true;
  late List<NewsArt> _cachedArticles;
  late List<NewsArt> _displayedArticles;
  int _startIndex = 0;
  int _batchSize = 10;
 
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    _loadCachedArticles();
  }
 
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
 
  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadMoreArticles();
    }
  }
 
  Future<void> _loadCachedArticles() async {
    _cachedArticles = await FetchNews.fetchNewsList();
    _displayedArticles = _cachedArticles.sublist(
      _startIndex,
      _startIndex + _batchSize < _cachedArticles.length
          ? _startIndex + _batchSize
          : _cachedArticles.length,
    );
    setState(() {
      _isLoading = false;
    });
  }
 
  Future<void> _loadMoreArticles() async {
    setState(() {
      _isLoading = true;
    });
    _startIndex += _batchSize;
    int endIndex = _startIndex + _batchSize;
    if (endIndex <= _cachedArticles.length) {
      _displayedArticles.addAll(_cachedArticles.sublist(_startIndex, endIndex));
    } else {
      // If there are no more articles to load, show a message
      // or disable further loading
    }
    setState(() {
      _isLoading = false;
    });
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('News List')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: _displayedArticles.length + 1,
              itemBuilder: (context, index) {
                if (index < _displayedArticles.length) {
                  final article = _displayedArticles[index];
                  return NewsItem(
                    newsArt: article,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ArticleDetailPage(newsArt: article),
                        ),
                      );
                    },
                  );
                } else {
                  return _buildLoadingIndicator();
                }
              },
            ),
    );
  }
 
  Widget _buildLoadingIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
 
class NewsItem extends StatelessWidget {
  final NewsArt newsArt;
  final VoidCallback onTap;
 
  NewsItem({required this.newsArt, required this.onTap});
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                // ignore: unnecessary_null_comparison
                child: newsArt.imgUrl != null
                    ? Image.network(
                        newsArt.imgUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey, // Placeholder color
                            child: Icon(Icons.error),
                          );
                        },
                      )
                    : Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey, // Placeholder color
                        child: Icon(Icons.error),
                      ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      newsArt.newsHead ?? 'No Title',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      newsArt.newsDes ?? 'No Description',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}