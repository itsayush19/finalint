import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Cell extends StatefulWidget {
  const Cell({Key? key}) : super(key: key);

  @override
  State<Cell> createState() => _CellState();
}

class _CellState extends State<Cell> {
  static const channel=MethodChannel('num');
  late int num;
  @override
  void initState(){
    super.initState();
    num=0;
    //setColor();
  }
  @override
  Widget build(BuildContext context) {
    channel.setMethodCallHandler((call) async{
      if(call.method=='update'){
        int n=call.arguments;
        setState(()=>num=n);
      }
    });

    //print(num);
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Text((num+3).toString()+' flut', style: theme.textTheme.headline3),
        ),
      ),
    );
  }
}
