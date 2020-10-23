
import 'package:flutter/material.dart';
import 'package:flutter_app/telas/Login.dart';

import 'Cadastro.dart';
import 'Curriculos.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}



class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xff1C1C1C)),
        padding: EdgeInsets.all(10),
        child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                   Column(
                      children: <Widget>[
                        Image.asset("images/curriculo.png")
                     ],
                     ),

                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 0),
                    child: Text("CURRÍCULO",
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30, color: Color(0xffFAFAFA),)
                    ),
                  ),
                  Text("ONLINE",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30, color: Color(0xffFAFAFA),)
                  ),

                  Padding(
                    padding: EdgeInsets.only(bottom: 10, top: 80),
                    child: RaisedButton(
                        child: Text(
                          "ENTRAR",
                          style: TextStyle(
                            color: Color(0xFFFAFAFA),
                            fontSize: 18,
                          ) ,
                        ),
                        color: Color(0xFFF5A622),
                        padding: EdgeInsets.fromLTRB(90, 12, 90, 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        onPressed:(){
                          Navigator.pushNamed(context, "/login");
                        }
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: RaisedButton(
                        child: Text(
                          "VISUALIZAR CANDIDATOS",
                          style: TextStyle(
                            color: Color(0xFFFAFAFA),
                            fontSize: 18,
                          ) ,
                        ),
                        color: Color(0xFFF5A622),
                        padding: EdgeInsets.fromLTRB(17, 12, 17, 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        onPressed:(){
                          Navigator.pushNamed(context, "/lista");
                        }
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Center(
                      child: GestureDetector(
                          child: Text(
                            "Não tem conta? Cadastre-se!",
                            style: TextStyle(
                              color: Colors.grey[50],
                              fontSize: 18,
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, "/cadastro");
                          }
                      ),
                    ),
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }
}
