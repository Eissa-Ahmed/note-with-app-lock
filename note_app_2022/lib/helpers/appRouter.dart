import 'package:flutter/material.dart';
import 'package:note_app_2022/helpers/stringsManager.dart';
import 'package:note_app_2022/presentation/addNoteScreen/addNoteScreen.dart';
import 'package:note_app_2022/presentation/homeScreen/homeScreen.dart';
import 'package:note_app_2022/presentation/singleNoteScreen/singleNoteScreen.dart';
import 'package:note_app_2022/presentation/splashScreen/splashScreen.dart';
import 'package:note_app_2022/presentation/storeIamgesAndVideos/homeImagesScreen.dart';
import 'package:note_app_2022/presentation/storeIamgesAndVideos/homeItemImagesAndVideo.dart';
import 'package:note_app_2022/presentation/storeIamgesAndVideos/homeVideoScreen.dart';
import 'package:note_app_2022/presentation/storeIamgesAndVideos/loginScreen.dart';
import 'package:note_app_2022/presentation/updateScreen/updateScreen.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesString.homeScreen:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );

      case RoutesString.splashScreen:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

      case RoutesString.addNoteScreen:
        return MaterialPageRoute(
          builder: (_) => const AddNoteScreen(),
        );
      case RoutesString.updateScreen:
        return MaterialPageRoute(
          builder: (_) => const UpdateScreen(),
        );
      case RoutesString.singleNoteScreen:
        return MaterialPageRoute(
          builder: (_) => const SingleNoteScreen(),
        );
      case RoutesString.loginScreen:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case RoutesString.homeStoreImagesScreen:
        return MaterialPageRoute(
          builder: (_) => const HomeStoreImagesScreen(),
        );
      case RoutesString.homeStoreVideosScreen:
        return MaterialPageRoute(
          builder: (_) => const HomeVideoScreen(),
        );
      case RoutesString.homeImagesAndVideoScreen:
        return MaterialPageRoute(
          builder: (_) => const HomeItemImagesAndVideo(),
        );
      default:
    }
    return null;
  }
}
