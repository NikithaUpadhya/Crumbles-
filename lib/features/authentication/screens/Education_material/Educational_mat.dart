import 'package:crumbles/features/authentication/screens/Education_material/document_viewer.dart';
import 'package:crumbles/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';




class Educational extends StatelessWidget {
  const Educational({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF4867FF).withOpacity(0.5),
                  Color(0xFF4867FF).withOpacity(0.3),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          title: Text('Food Donation Educational Resources'),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4867FF).withOpacity(0.1),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  children: [

                    GestureDetector(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PdfViewerScreen(
                              docUrl: 'https://firebasestorage.googleapis.com/v0/b/crumbles-fyp.appspot.com/o/Educational%20material%2FWhat%20is%20Food%20Donation.pdf?alt=media&token=78922710-0bd1-4b10-926c-7f73f62981c2',
                            ),
                          ),
                        );
                      },
                      child: CategoryCard(
                        icon: FontAwesomeIcons.utensils,
                        title: 'Food Donation',
                        amount: 'Learn more..',
                      ),
                    ),


                    GestureDetector(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PdfViewerScreen(
                              docUrl: 'https://firebasestorage.googleapis.com/v0/b/crumbles-fyp.appspot.com/o/Educational%20material%2FWhy%20is%20Donating%20Food%20Important.pdf?alt=media&token=67925506-e8e4-479b-bed5-4b7ed7f776f4',
                            ),
                          ),
                        );
                      },
                      child: CategoryCard(
                        icon: FontAwesomeIcons.handHoldingHeart,
                        title: 'Importance of Food Donation',
                        amount: 'Learn more..',
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PdfViewerScreen(
                              docUrl: 'https://firebasestorage.googleapis.com/v0/b/crumbles-fyp.appspot.com/o/Educational%20material%2FNutrition%20and%20Food%20Safety.pdf?alt=media&token=4f815f38-a12d-4fb2-aff2-c235314f2492',
                            ),
                          ),
                        );
                      },
                      child: CategoryCard(
                        icon: Iconsax.apple,
                        title: 'Nutrition and Food Safety',
                        amount: 'Learn more..',
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PdfViewerScreen(
                              docUrl: 'https://firebasestorage.googleapis.com/v0/b/crumbles-fyp.appspot.com/o/Educational%20material%2FHow%20to%20Get%20Involved.pdf?alt=media&token=8a816be7-1cbc-41c0-a3a7-bd39ec2cd636',
                            ),
                          ),
                        );
                      },
                      child: CategoryCard(
                        icon: FontAwesomeIcons.handsHolding,
                        title: 'How to get Involved',
                        amount: 'Learn more..',
                      ),
                    ),

                     GestureDetector(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PdfViewerScreen(
                              docUrl: 'https://firebasestorage.googleapis.com/v0/b/crumbles-fyp.appspot.com/o/Educational%20material%2Fsucess_stories.pdf?alt=media&token=e377cd16-d1cf-4748-8299-20a59b4a2ae4',
                            ),
                          ),
                        );
                      },
                      child: CategoryCard(
                        icon: FontAwesomeIcons.star,
                        title: 'Impact/Sucess Stories',
                        amount: 'Learn more..',
                      ),
                    ),

                     GestureDetector(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PdfViewerScreen(
                              docUrl: 'https://firebasestorage.googleapis.com/v0/b/crumbles-fyp.appspot.com/o/Educational%20material%2FSustainability%20and%20Environment.pdf?alt=media&token=e18a9750-2637-4805-a064-f87f8418b0cd',
                            ),
                          ),
                        );
                      },
                      child: CategoryCard(
                        icon: FontAwesomeIcons.recycle,
                        title: 'Sustainability and Environment',
                        amount: 'Learn more..',
                      ),
                    ),

                     GestureDetector(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PdfViewerScreen(
                              docUrl: 'https://firebasestorage.googleapis.com/v0/b/crumbles-fyp.appspot.com/o/Educational%20material%2FFood%20Donation%20Laws%20.pdf?alt=media&token=f925b278-0f3a-4ef7-860c-51cb25b4e168',
                            ),
                          ),
                        );
                      },
                      child: CategoryCard(
                        icon: FontAwesomeIcons.gavel,
                        title: 'Food Donation Laws and Policies',
                        amount: 'Learn more..',
                      ),
                    ),

                     GestureDetector(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PdfViewerScreen(
                              docUrl: 'https://firebasestorage.googleapis.com/v0/b/crumbles-fyp.appspot.com/o/Educational%20material%2FGlobal%20Impact%20of%20Food%20Waste.pdf?alt=media&token=4e111b8e-4c05-4adc-9160-f842d735da4f',
                            ),
                          ),
                        );
                      },
                      child: CategoryCard(
                        icon: Iconsax.global,
                        title: 'Global Impact of Food Waste',
                        amount: 'Learn more..',
                      ),
                    ),

                    
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                TImages.educational,
                height: 75,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String amount;

  CategoryCard({
    required this.icon,
    required this.title,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40.0,
              color: Color(0xFF4867FF),
            ),
            SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.0),
            Text(
              amount,
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
