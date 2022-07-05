import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  dynamic dataFlutter;
  static const channel=MethodChannel("weather_channel");
  final String authority='api.openweathermap.org';
  final String path='data/2.5/weather';
  final String apiKey='c486bbcc84c0215de8bea7817e30d13a';
  @override
  Widget build(BuildContext context) {
    String wString='';
    //channel.invokeMethod('update',wString);
    channel.setMethodCallHandler((call)async{
      wString=await getWeather(call.arguments);
      setState((){
        dataFlutter=jsonDecode(wString);
      });
    });

    return Scaffold(
      backgroundColor: Colors.white,
      //backgroundColor: Color(settingColor),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            WeatherRow('City Name',dataFlutter!=null?dataFlutter["name"]:" "),
            WeatherRow('Description',dataFlutter!=null?dataFlutter["weather"][0]["description"]:" "),
            WeatherRow('Temperature',dataFlutter!=null?dataFlutter["main"]["temp"]:" "),
            WeatherRow('Humidity',dataFlutter!=null?dataFlutter["main"]["humidity"]:" "),
            WeatherRow('Pressure',dataFlutter!=null?dataFlutter["main"]["pressure"]:" "),
            WeatherRow('Feels Like',dataFlutter!=null?dataFlutter["main"]["feels_like"]:" "),
            // Center(
            //   child: Text(dataFlutter.toString()),
            // )
          ],
        ),
      ),
    );
  }

  Widget WeatherRow(String label,dynamic value){
    return Padding(
      padding: EdgeInsets.symmetric(vertical:16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$label',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: Text(
              '$value',
              style: TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
  Future<String> getWeather(String location) async{
    Map<String,dynamic> parameters={
      'q': location,
      'appId': apiKey
    };

    Uri uri = Uri.https(authority, path,parameters);

    http.Response result = await http.get(uri);
    return result.body;

  }
}
