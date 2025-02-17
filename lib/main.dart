import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saloon_app/Cartmodel.dart';
import 'package:saloon_app/frontpage.dart';

void main() {
  runApp( ChangeNotifierProvider(
    create: (context) => CartModel(),
    child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Saloon Info',
      home: DoorHubOnboardingScreen(),
    );
  }
}
