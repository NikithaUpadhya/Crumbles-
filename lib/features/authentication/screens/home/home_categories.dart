import 'package:crumbles/common/Containers/vertical_image_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

const List<Map<String, String>> categories = [
  {
    'title': 'Basic Needs',
    'image': 'https://firebasestorage.googleapis.com/v0/b/crumbles-fyp.appspot.com/o/Users%2FImages%2Fcategories%2Ficons8-basic-needs-64.png?alt=media&token=082b5a0d-4b04-42d9-bf49-1840dda799a6',
    'url': 'https://givebasicneeds.org/donate',
  },

  {
    'title': 'Animal Welfare',
    'image': 'https://firebasestorage.googleapis.com/v0/b/crumbles-fyp.appspot.com/o/Users%2FImages%2Fcategories%2Fanimal-shelter-50.png?alt=media&token=bb27f5e7-fa94-4321-835d-8dd9b3dc0184',
    'url': 'https://mnawf.org.my/Donate/',
  },

  {
    'title': 'Health',
    'image': 'https://firebasestorage.googleapis.com/v0/b/crumbles-fyp.appspot.com/o/Users%2FImages%2Fcategories%2Fout-patient-department-50.png?alt=media&token=d60f9ca3-fc7d-432b-913f-518969a51151',
    'url': 'https://hospismalaysia.org/donations/',
  },

  {
    'title': 'Community Development',
    'image': 'https://firebasestorage.googleapis.com/v0/b/crumbles-fyp.appspot.com/o/Users%2FImages%2Fcategories%2Fhousing-50.png?alt=media&token=e3b9c856-5a08-423e-a79d-86782fc0e1c2',
    'url': 'https://epichome.org/',
  },

  {
    'title': 'Education',
    'image': 'https://firebasestorage.googleapis.com/v0/b/crumbles-fyp.appspot.com/o/Users%2FImages%2Fcategories%2Feducation-50.png?alt=media&token=5019f2e0-ed66-4195-b7f3-65f975fc4ded',
    'url': 'https://donate.sols247.org/',
  },

  {
    'title': 'Environmental Conservation',
    'image': 'https://firebasestorage.googleapis.com/v0/b/crumbles-fyp.appspot.com/o/Users%2FImages%2Fcategories%2Ficons8-environment-50.png?alt=media&token=13dc2f56-e649-4ede-944a-344484f0a13a',
    'url': 'https://www.wwf.org.my/',
  },

  {
    'title': 'Child Protection',
    'image': 'https://firebasestorage.googleapis.com/v0/b/crumbles-fyp.appspot.com/o/Users%2FImages%2Fcategories%2Fchildren-50.png?alt=media&token=8f7174b6-ed6d-40b8-81bd-7f269fbab456',
    'url': 'https://www.psthechildren.org.my/',
  },

  {
    'title': 'Arts Education',
    'image': 'https://firebasestorage.googleapis.com/v0/b/crumbles-fyp.appspot.com/o/Users%2FImages%2Fcategories%2Fartist-50.png?alt=media&token=66c287ef-bb5f-485d-be52-f1459cbdb387',
    'url': 'https://tenaganita.net/donate/',
  },

  {
    'title': 'Drought',
    'image': 'https://firebasestorage.googleapis.com/v0/b/crumbles-fyp.appspot.com/o/Users%2FImages%2Fcategories%2Fdrought-50.png?alt=media&token=9af0a2de-2828-4873-8b53-f4a8d06710ad',
    'url': 'https://hss.mercy.org.my/mercy-start/recent#!#recent',
  },
 
];

class THomeCategories extends StatelessWidget {
  const THomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          final category = categories[index];
          return TVerticalImageText(
            image: category['image']!,
            title: category['title']!,
            onTap: () {
              if (category['url'] != null) {
                _launchURL(category['url']!);
              } else {
                print('No URL provided for this category');
              }
            },
          );
        },
      ),
    );
  }

  Future<void> _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  } else {
    throw 'Could not launch $url';
  }
}
}