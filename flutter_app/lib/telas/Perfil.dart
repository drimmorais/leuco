
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/Usuario.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Perfil extends StatefulWidget {

  Usuario usuario;

  Perfil(this.usuario);


  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Perfil"),),
      body: Container(
        decoration: BoxDecoration(color: Color(0xff1C1C1C)),
        padding: EdgeInsets.only(left: 20, right: 20),
         child: Center(
           child: SingleChildScrollView(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.start,
               children: <Widget>[
                 CircleAvatar(
                 maxRadius: 80,
                 backgroundColor: Color(0xFFFAFAFA),
                //   backgroundImage: widget.usuario.urlImagem,
                 ),
                 Padding(
                   padding: EdgeInsets.only(bottom: 20, top: 30),
                  child: Text(widget.usuario.nome, style: TextStyle(
                     fontWeight: FontWeight.w500,
                     fontSize: 22,
                     color: Color(0xfffafafa),
                   )),
                 ),
                 Card(
                   color:  Color(0xFFF5A622),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: <Widget>[
                       ListTile(
                         onTap: () {

                         },
                         contentPadding: EdgeInsets.only(top: 5, bottom: 5, left: 10),
                           title: Text("Contatos:",
                             style: TextStyle(
                               fontWeight: FontWeight.w500,
                               fontSize: 18,
                               color: Color(0xfffafafa),
                             )
                         ),
                         subtitle: Text("${widget.usuario.email}                  ${widget.usuario.telefone}",
                           style: TextStyle(
                             fontWeight: FontWeight.w300,
                             fontSize: 18,
                             color: Color(0xfffafafa),),
                       ),

                       )
                     ],

                   ),

                 ),
                 Card(

                   color:  Color(0xFFF5A622),
                   child: Column(

                     mainAxisAlignment: MainAxisAlignment.start,
                     children: <Widget>[
                       ListTile(
                         onTap: () {

                         },
                         contentPadding: EdgeInsets.only(top: 5, bottom: 5, left: 10),

                         title: Text("Habilidade: ${widget.usuario.habilidade} ",
                             style: TextStyle(
                               fontWeight: FontWeight.w500,
                               fontSize: 18,
                               color: Color(0xfffafafa),
                             )
                         ),
                         subtitle: Text("${widget.usuario.resumoHabilidade}",
                           style: TextStyle(
                             fontWeight: FontWeight.w300,
                             fontSize: 18,
                             color: Color(0xfffafafa),),
                         ),

                       )
                     ],

                   ),

                 ),
                 Card(

                   color:  Color(0xFFF5A622),
                   child: Column(

                     mainAxisAlignment: MainAxisAlignment.start,
                     children: <Widget>[
                       ListTile(
                         onTap: () {

                         },
                         contentPadding: EdgeInsets.only(top: 5, bottom: 5, left: 10),

                         title: Text("Curso: ${widget.usuario.curso}-${widget.usuario.instituicao}     ",
                             style: TextStyle(
                               fontWeight: FontWeight.w500,
                               fontSize: 18,
                               color: Color(0xfffafafa),
                             )
                         ),
                         subtitle: Text("Conclusão: ${widget.usuario.data}  ",
                           style: TextStyle(
                             fontWeight: FontWeight.w300,
                             fontSize: 18,
                             color: Color(0xfffafafa),),
                         ),

                       )
                     ],

                   ),

                 ),

               ],
             ),
           ),
         ),
      ),
    );
  }
}
