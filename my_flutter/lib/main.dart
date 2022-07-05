import 'package:flutter/material.dart';
import 'package:my_flutter/screens/home_screen.dart';
import 'package:my_flutter/screens/view_screen.dart';
import 'package:my_flutter/weather_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/':(context)=>HomePage(),
        'cell':(context)=>Cell(),
        'weather':(context)=>WeatherScreen()
      },
    );
  }
}