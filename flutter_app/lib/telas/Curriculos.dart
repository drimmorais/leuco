
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_app/model/Usuario.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/telas/Home.dart';

class Curriculos extends StatefulWidget {
  @override
  _CurriculosState createState() => _CurriculosState();
}

class _CurriculosState extends State<Curriculos> {


  String _idUsuarioLogado;
  String _emailUsuarioLogado;

  List<String> intensMenus = [
    "Perfil", "Editar", "Deslogar"
  ];


  Future<List<Usuario>> _recuperarUsuario() async {
    Firestore db = Firestore.instance;

    QuerySnapshot querySnapshot = await db.collection("usuario").getDocuments();

    List<Usuario> listaUsuarios = List();
    for (DocumentSnapshot item in querySnapshot.documents) {
      var dados = item.data;
      if( dados["email"] == _emailUsuarioLogado ) continue;

      Usuario usuario = Usuario();
      usuario.nome = dados["nome"];
      usuario.telefone = dados["telefone"];
      usuario.email = dados["email"];
      usuario.senha = dados["senha"];
      usuario.habilidade = dados["habilidade"];
      usuario.resumoHabilidade = dados["resumoHabilidade"];
      usuario.curso = dados ["curso"];
      usuario.data = dados ["data"];
      usuario.instituicao = dados ["instituicao"];
      usuario.urlImagem = dados ["urlImagem"];


      listaUsuarios.add(usuario);
    }
    return listaUsuarios;
  }

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;
    _emailUsuarioLogado = usuarioLogado.email;


  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
  }

  _escolhaMenuItem(String itemEscolhido){
    
    switch (itemEscolhido){
      case"Editar":
        Navigator.pushNamed(context, "/edicao");
        break;
      case "Deslogar":
        _deslogarUsuario();
         break;
      case"Perfil":
        Navigator.pushNamed(context, "/perfil");
        break;
    }
  }

  _deslogarUsuario() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        )
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("          CURRÍCULOS"),
        backgroundColor: Color(0xFF1c1c1c),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context){
                return intensMenus.map((String item){
                  return PopupMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList();
                },
          )
        ],
      ),
      body: Container(
          decoration: BoxDecoration(color: Color(0xff1c1c1c)),
          padding: EdgeInsets.only(top: 15),
          child: FutureBuilder<List<Usuario>>(
            future: _recuperarUsuario(),
            //  ignore: missing_return
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: Column(
                        children: <Widget>[
                          Text("Carregando Currículos"),
                          CircularProgressIndicator()
                        ],
                      ),
                    );
                    break;
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (_, indice) {
                          List<Usuario> listaItens = snapshot.data;
                          Usuario usuario = listaItens[indice];
                          return Container(

                            child: Card(

                              color:  Color(0xFFF5A622),
                               child: Column(

                                 mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                  ListTile(
                                    onTap: () {
                                      Navigator.pushNamed(context, "/perfil", arguments: usuario);

                                    },
                                    contentPadding: EdgeInsets.only(top: 8, bottom: 8, left: 8),
                                    leading: CircleAvatar(
                                      maxRadius: 30,
                                      backgroundColor: Color(0xFFFAFAFA),
                                      backgroundImage:
                                      usuario.urlImagem != null
                                        ? NetworkImage(usuario.urlImagem)
                                        : null),
                                    title: Text(usuario.nome,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: Color(0xfffafafa),
                                        )
                                    ),
                                    ),
                                ],

                              ),

                            ),
                          );
                        });
                    break;
                }
              })
      ),
    //)
    );
  }
}
