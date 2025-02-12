import 'package:crumbles/common/Containers/primaryHeaderContainer.dart';
import 'package:crumbles/common/Containers/search_Containr.dart';
import 'package:crumbles/common/Containers/section_headings.dart';
import 'package:crumbles/features/authentication/screens/Education_material/Educational_mat.dart';
import 'package:crumbles/features/authentication/screens/home/home_appbar.dart';
import 'package:crumbles/features/authentication/screens/home/home_categories.dart';
import 'package:crumbles/features/authentication/screens/home/new_articles/articles_details_page.dart';
import 'package:crumbles/features/authentication/screens/home/new_articles/fetch_new.dart';
import 'package:crumbles/features/authentication/screens/home/new_articles/news_articles.dart';
import 'package:crumbles/features/authentication/screens/home/promoSlider.dart';
import 'package:crumbles/utils/constants/image_strings.dart';
import 'package:crumbles/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<NewsArt> _newsArticles = [];

  @override
  void initState() {
    super.initState();
    _loadNewsArticles();
  }

  Future<void> _loadNewsArticles() async {
    try {
      List<NewsArt> fetchedArticles = await FetchNews.fetchNewsList();
      setState(() {
        _newsArticles = fetchedArticles;
      });
    } catch (e) {
      print('Error fetching news articles: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const TPrimaryHeaderContainer(
              child: Column(
                children: [
                  THomeAppBar(),
                  SizedBox(height: TSizes.spaceBtwSections),
                  TSearchContainer(text: "Welcome to the Crumbles platform!"),
                  SizedBox(height: TSizes.spaceBtwSections),
                  Padding(
                    padding: EdgeInsets.only(left: TSizes.defaultSpace),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TSectionHeading(
                          title: "External Donations",
                          showActionButton: false,
                          textColor: Colors.white,
                        ),
                        SizedBox(height: TSizes.spaceBtwItems),
                        THomeCategories(),
                      ],
                    ),
                  ),
                  SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: TPromoSlider(
                banners: [
                  TImages.banner1,
                  TImages.banner2,
                  TImages.banner3,
                ],
              ),
            ),
            SizedBox(height: TSizes.spaceBtwSections),
            // New card widget starts here
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
              child: Card(
                color: Color(0xFFE9EDE9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Knowledge Zone',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            const Text(
                              'want to learn more about food and food donation?',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => Get.to(() => const Educational()),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text('GO!'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8), // Reduced the width to make the image closer
                      Image.asset(
                        'assets/icons/R-removebg-preview.png', // Ensure this image is available in your assets folder
                        width: 125, // Increased the width to make the image larger
                        height: 125, // Increased the height to make the image larger
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // New card widget ends here
            SizedBox(height: TSizes.spaceBtwSections),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Latest News Updates",
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: _newsArticles.take(3).map((article) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ArticleDetailPage(newsArt: article),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  article.imgUrl,
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      article.newsHead,
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      _shortenDescription(article.newsDes),
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    SizedBox(height: TSizes.spaceBtwItems),
                                    Text(
                                      'read more...',
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _shortenDescription(String description) {
    if (description.length > 100) {
      return '${description.substring(0, 100)}...';
    }
    return description;
  }
}

