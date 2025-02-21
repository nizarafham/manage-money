import 'package:atur_duit/screens/home/views/home_screen.dart';
import 'package:flutter/material.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Kelola Duit",
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          background: Colors.grey.shade100,
          onBackground: Colors.black,
          primary: Color(0xFF00B2E7),
          secondary: Color(0xFFE064F7),
          tertiary: Color(0xFFFF8D6C),
        )
      ),
      home: HomeScreen(),
    );
  }
}
