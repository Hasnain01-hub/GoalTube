// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'category.dart';

class RecommendedCategory {
  RecommendedCategory({
    this.title = '',
    this.thumbnailUrl = '',
    this.duration = 0,
    this.youtubeUrl = '',
  });

  String title;
  int duration;
  String youtubeUrl;
  String thumbnailUrl;

  List<RecommendedCategory> createCategoryList(
      List<Map<String, dynamic>> course) {
    var listCategory = <RecommendedCategory>[];
    for (int i = 0; i < course.length; i++) {
      listCategory.add(RecommendedCategory(
        thumbnailUrl: course[i]["thumbnail"],
        title: course[i]["title"],
        duration: course[i]["duration"],
        youtubeUrl: course[i]["url"],
      ));
    }
    return listCategory;
  }

  static List<Category> categoryList = <Category>[
    Category(
      imagePath: 'assets/courses/course1.png',
      lessonCount: 24,
      rating: 4.3,
    ),
    Category(
      imagePath: 'assets/courses/course2.png',
      title: 'Next.js & Contentful Tutorial',
      lessonCount: 22,
      rating: 4.6,
    ),
    Category(
      imagePath: 'assets/courses/course3.png',
      title: 'Material UI Tutorial',
      lessonCount: 24,
      rating: 4.3,
    ),
    Category(
      imagePath: 'assets/courses/course4.png',
      title: 'Vue 3 with TypeScript Jump',
      lessonCount: 22,
      rating: 4.6,
    ),
  ];
}
