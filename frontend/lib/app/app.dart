import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../components/home/home_screen.dart';
import '../components/settings/settings_screen.dart';
import '../components/profile/profile_screen.dart';
import '../components/focus/focus_screen.dart';
import '../components/Intent/Intent_screen.dart';
import '../components/History/TimeLine_Screen.dart';
import '../components/AuthScreen/authScreen.dart';
import '../components/AuthScreen/signup_page.dart';
import '../components/MyCoach/My_Coach.dart';
// import others later

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.settings: (_) => const SettingsScreen(),
        AppRoutes.profile: (_) => const ProfileScreen(),
        AppRoutes.myIntents:(_) =>const IntentScreen(),
        AppRoutes.timeline:(_) =>const TimeLineScreen(),
        AppRoutes.focus:(_) => const FocusScreen(),
        AppRoutes.login:(_)=>const AuthScreen(),
        AppRoutes.signup:(_)=>const SignUpScreen(),
        AppRoutes.myCoach:(_)=>const MyCoach(),
      }
    );
  }
}
