import 'package:BirdHealthcare/services/NavigationService.dart';
import 'package:BirdHealthcare/settings/Routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'pages/RootPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          elevation: 10,
          selectedLabelStyle: TextStyle(
            color: Colors.blue,
            fontSize: 11,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 11,
          ),
          selectedItemColor: Colors.blue,
        ),
      ),
      home: RootPage(),
      navigatorKey: NavigationService.getInstance().rootNavigatorKey,
      onGenerateRoute: Routes.onGenerateRoute,
    );
  }
}
