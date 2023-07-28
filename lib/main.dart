import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:polo_s/infoHandler/app_info.dart';
import 'package:polo_s/screens/login_screen.dart';
import 'package:polo_s/screens/main_screen_user.dart';
import 'package:polo_s/screens/register_screen.dart';
import 'package:polo_s/themeProvider/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users");
FirebaseAuth auth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppInfo(),
      child: MaterialApp(
        title: 'Polo-S',
        //themeMode: ThemeMode.system,
        theme: MyThemes.lightTheme,
        themeMode: ThemeMode.light,
        darkTheme: MyThemes.darkTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: FirebaseAuth.instance.currentUser == null
            ? LoginScreen.idScreen
            : MainScreen.idScreen,
        routes: {
          RegisterScreen.idScreen: (context) => const RegisterScreen(),
          LoginScreen.idScreen: (context) => const LoginScreen(),
          MainScreen.idScreen: (context) => const MainScreen(),
        },
      ),
    );
  }
}
