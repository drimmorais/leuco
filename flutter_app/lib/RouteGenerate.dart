import 'package:flutter/material.dart';
import 'package:flutter_app/telas/EdicaoPerfil.dart';
import 'package:flutter_app/telas/Perfil.dart';
import 'package:flutter_app/telas/ListaAnonima.dart';
import 'file:///C:/Users/dryka/AndroidStudioProjects/flutter_app/lib/telas/Cadastro.dart';
import 'file:///C:/Users/dryka/AndroidStudioProjects/flutter_app/lib/telas/Login.dart';

import 'package:flutter_app/telas/Home.dart';
import 'package:flutter_app/telas/Curriculos.dart';

class RouteGenarator {

  static Route<dynamic> generateRoute(RouteSettings settings) {

    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
            builder: (_) => Home()
        );
      case "/login":
        return MaterialPageRoute(
            builder: (_) => Login()
        );
      case "/cadastro":
        return MaterialPageRoute(
            builder: (_) => Cadastro()
        );
      case "/lista":
        return MaterialPageRoute(
            builder: (_) => Curriculos()
        );
      case "/edicao":
        return MaterialPageRoute(
            builder: (_) => EdicaoPerfil()
        );
      case "/perfil":
        return MaterialPageRoute(
            builder: (_) => Perfil(args)
        );
      case "/listaAnonima":
        return MaterialPageRoute(
            builder: (_) => ListaAnonima()
        );



      }
  }

}