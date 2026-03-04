import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jnjversion01windows/screens/start_screen.dart';
import 'package:jnjversion01windows/utilities/univariable.dart';
import 'package:upgrader/upgrader.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'J n J Pedal for hope',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'Poppins',
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Univariable.whiteColor,
              statusBarIconBrightness: Brightness.dark,
            ),
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Univariable.primaryColor),
      ),
      home: UpgradeAlert(
            child:StartScreen()
      ),
    );
  }
}
