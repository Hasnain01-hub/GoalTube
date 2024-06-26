// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:edutube/chat.dart';
import 'package:edutube/components/forms/contact_us.dart';
import 'package:edutube/components/forms/requestplaylist_data.dart';
import 'package:edutube/components/my_playlists.dart';
import 'package:edutube/components/recommended_courses.dart';
import 'package:edutube/home.dart';
import 'package:edutube/provider/locale_provider.dart';
import 'package:edutube/user_profile.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'authentication/authPage.dart';
import 'authentication/firebase_auth_service.dart';
import 'basicTheme.dart';
import 'components/all_courses.dart';
import 'components/forms/requestplaylist_data.dart';
import 'components/notes_page.dart';
import 'l10n/l10n.dart';
import 'onboarding_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
   await FlutterDownloader.initialize();
  WidgetsFlutterBinding.ensureInitialized();
  // WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isIOS) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCkK8zMbeW4nZ96a5fLAxeJVueJg2TYUz8",
            appId: "1:820037585946:ios:9c0d0950aa2232cdb315a3",
            messagingSenderId: "Your Sender id found in Firebase",
            projectId: "edutube-55ae5"
            ));
  } else {
    await Firebase.initializeApp();
  }
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context)=> ChangeNotifierProvider(
  create: (context) => LocaleProvider(),
  builder: (context, child){
    final provider = Provider.of<LocaleProvider>(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(create: (_) => FirebaseAuthService()),
        FutureProvider<Map<String, dynamic>?>(
          create: (context) async {
            var user = Provider.of<FirebaseAuthService>(context, listen: false)
                .currentUser();
            var userDoc = await FirebaseFirestore.instance
                .collection("Users")
                .doc(user!.email)
                .get();
            return userDoc.data();
          },
          initialData: {},
        ),
      ],
      child: GetMaterialApp(
        routes: {
          "/home": (context) => HomePage(),
          "/add": (context) => PlaylistForm(),
          "/onboard": (context) => OnboardingScreen(),
          "/profile": (context) => UserProfile(),
          "/myPlaylist": (context) => MyPlaylistView(),
          "/chat": (context) => ChatScreen(),
          "/allCourses" : (context) => AllCourses(),
          "/contact": (context) => ContactScreen(),
          "/notes":(context) => NotesPage(),
          "/recommended": (context) => RecommendedCourseView()
        },
        debugShowCheckedModeBanner: false,
        title: 'EduTube',
        theme: basicTheme(),
        home: AuthPage(),
        locale: provider.locale,
        supportedLocales: L10n.all,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
      ),
    );
  }
  );
}
