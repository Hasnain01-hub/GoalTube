import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class Category {
  Category({
    this.title = '',
    this.imagePath = '',
    this.lessonCount = 0,
    this.rating = 0.0,
  });

  String title;
  int lessonCount;
  double rating;
  String imagePath;

  static List<Category> categoryList = <Category>[
    Category(
      imagePath: 'assets/courses/course1.jpg',
      // title: AppLocalizations.of(context)!.lessons,
      lessonCount: 24,
      rating: 4.3,
    ),
    Category(
      imagePath: 'assets/courses/course2.jpg',
      title: 'Learn English',
      lessonCount: 22,
      rating: 4.6,
    ),
    Category(
      imagePath: 'assets/courses/course3.jpg',
      title: 'Learn Physics',
      lessonCount: 24,
      rating: 4.3,
    ),
    Category(
      imagePath: 'assets/courses/course4.jpg',
      title: 'Learn Python with Krishan Naik',
      lessonCount: 22,
      rating: 4.6,
    ),
  ];

  List<Category> createCategoryList(List<Map<String, dynamic>> course) {
    var listCategory = <Category>[];
    for (int i = 0; i < course.length; i++) {
      listCategory.add(Category(
        imagePath: course[i]["videos_data"][0]["thumbnailLink"],
        title: course[i]["courseName"],
        lessonCount: course[i]["videos_data"].length,
        rating: course[i]["rating"].toDouble(),
      ));
    }
    return listCategory;
  }

  static List<Category> popularCourseList = <Category>[
    Category(
      imagePath: 'assets/courses/course3.jpg',
      title: 'Learn Physics',
      lessonCount: 12,
      rating: 4.8,
    ),
    Category(
      imagePath: 'assets/courses/course4.jpg',
      title: 'Learn Python with Krishan Naik',
      lessonCount: 28,
      rating: 4.9,
    ),
    Category(
      imagePath: 'assets/courses/course5.jpg',
      title: 'Learn Kinetics with Physics Wallah',
      lessonCount: 12,
      rating: 4.8,
    ),
    Category(
      imagePath: 'assets/courses/course6.jpg',
      title: 'Learn Javascript wiht Hitesh Chowdhary',
      lessonCount: 28,
      rating: 4.9,
    ),
    Category(
      imagePath: 'assets/courses/course1.jpg',
      title: 'Learn Mathematics',
      lessonCount: 28,
      rating: 4.9,
    ),
    Category(
      imagePath: 'assets/courses/course2.jpg',
      title: 'Learn English',
      lessonCount: 28,
      rating: 4.9,
    ),
  ];
}
