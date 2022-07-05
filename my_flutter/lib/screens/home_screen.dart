import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const channel=MethodChannel("my_channel");
  int settingColor=0xFF0D47A1;

  @override
  void initState(){
    super.initState();
    //setColor();
  }

  // void setColor(){
  //   colorChannel.setMethodCallHandler((call)async{
  //     if(call.method=='getColor'){
  //       final int color=call.arguments;
  //       setState((){
  //         settingColor=color;
  //       });
  //     }
  //   });
  // }

  TextEditingController txtCity=TextEditingController();
  dynamic dataFlutter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(settingColor),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Enter Location',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: (){
                      getData();
                    },),
                ),
                controller: txtCity,
              ),
            ),
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

  Future getData() async{
    print("calling for data");
    dynamic data;
    try{
      final dynamic result=await channel.invokeMethod('callApi',{"data":txtCity.text});
      data=result;
    }on PlatformException catch (e){
      data="Native app is not responsing";
    }
    setState((){
      dataFlutter=jsonDecode(data);
    });
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
}
