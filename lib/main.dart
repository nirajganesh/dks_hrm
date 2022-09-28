import 'package:dks_hrm/auth/Login_screen.dart';
import 'package:dks_hrm/constants/ThemeClass.dart';
import 'package:dks_hrm/provider/Login_provider/Item_provider.dart';
import 'package:dks_hrm/provider/Login_provider/Login_provider.dart';
import 'package:dks_hrm/provider/Login_provider/Search_provider/Search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Login_provider()),
        ChangeNotifierProvider(create:(_)=>Search_provider()),
        ChangeNotifierProvider(create:(_)=>Item_provider()),
       ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digikraftsocial HRM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColorLight: Color(0xff08AEEA),
        fontFamily: 'RobotoCondensed',
        backgroundColor: Color(0xffF9FAFF),
      ),
      home: Login_screen(),
    );
  }
}


