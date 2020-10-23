import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/RouteGenerate.dart';
import 'telas/Home.dart';



void main() {

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
    theme: ThemeData(
        primaryColor: Color(0xff1C1C1C),
        accentColor: Color(0xffF5A622)
    ),
    initialRoute: "/",
    onGenerateRoute:RouteGenarator.generateRoute,

  )
  );
}