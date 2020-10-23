
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class EdicaoPerfil extends StatefulWidget {
  @override
  _EdicaoPerfilState createState() => _EdicaoPerfilState();
}

class _EdicaoPerfilState extends State<EdicaoPerfil> {

  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerTelefone = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  TextEditingController _controllerHabilidade = TextEditingController();
  TextEditingController _controllerResumoHabilidade = TextEditingController();
  TextEditingController _controllerCurso = TextEditingController();
  TextEditingController _controllerData = TextEditingController();
  TextEditingController _controllerInstituicao = TextEditingController();
  File _imagem;
  String _idUsuarioLogado;
  bool _subindoImagem = false;
  String _urlImagemRecuperada;

  Future _recuperarImagem(String origemImagem) async {

    File imagemSelecionada;
    switch( origemImagem ){
      case "camera" :
        imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.camera);
        break;
      case "galeria" :
        imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.gallery);
        break;
    }

    setState(() {
      _imagem = imagemSelecionada;
      if( _imagem != null ){
        _subindoImagem = true;
        _uploadImagem();
      }
    });

  }

  Future _uploadImagem() async {

    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz
        .child("perfil")
        .child(_idUsuarioLogado + ".jpg");

    //Upload da imagem
    StorageUploadTask task = arquivo.putFile(_imagem);

    //Controlar progresso do upload
    task.events.listen((StorageTaskEvent storageEvent){

      if( storageEvent.type == StorageTaskEventType.progress ){
        setState(() {
          _subindoImagem = true;
        });
      }else if( storageEvent.type == StorageTaskEventType.success ){
        setState(() {
          _subindoImagem = false;
        });
      }

    });

    //Recuperar url da imagem
    task.onComplete.then((StorageTaskSnapshot snapshot){
      _recuperarUrlImagem(snapshot);
    });

  }

  Future _recuperarUrlImagem(StorageTaskSnapshot snapshot) async {

    String url = await snapshot.ref.getDownloadURL();
    _atualizarUrlImagemFirestore( url );

    setState(() {
      _urlImagemRecuperada = url;
    });

  }

    _atualizarDadosFirestore(){

    String nome = _controllerNome.text;
    String telefone = _controllerTelefone.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;
    String habilidade = _controllerHabilidade.text;
    String resumoHabilidade = _controllerResumoHabilidade.text;
    String curso = _controllerCurso.text;
    String data = _controllerData.text;
    String instituicao = _controllerInstituicao.text;


    Firestore db = Firestore.instance;

    Map<String, dynamic> dadosAtualizar = {
      "nome" : nome,
      "telefone": telefone,
      "email": email,
      "senha": senha,
      "habilidade": habilidade,
      "resumoHabilidade": resumoHabilidade,
      "curso": curso,
      "data": data,
      "instituicao": instituicao,
    };

    db.collection("usuario")
        .document(_idUsuarioLogado)
        .updateData( dadosAtualizar );

  }

  _atualizarUrlImagemFirestore(String url){

    Firestore db = Firestore.instance;

    Map<String, dynamic> dadosAtualizar = {
      "urlImagem" : url
    };

    db.collection("usuario")
        .document(_idUsuarioLogado)
        .updateData( dadosAtualizar );

  }

  _recuperarDadosUsuario() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot = await db.collection("usuario")
        .document( _idUsuarioLogado )
        .get();

    Map<String, dynamic> dados = snapshot.data;
    _controllerNome.text = dados["nome"];
    _controllerTelefone.text = dados["telefone"];
    _controllerEmail.text = dados["email"];
    _controllerSenha.text = dados["senha"];
    _controllerHabilidade.text = dados["habilidade"];
    _controllerResumoHabilidade.text = dados["resumoHabilidade"];
    _controllerCurso.text = dados["curso"];
    _controllerData.text = dados["data"];
    _controllerInstituicao.text = dados["instituicao"];

    if( dados["urlImagem"] != null ){
      setState(() {
        _urlImagemRecuperada = dados["urlImagem"];
      });
    }

  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edição"),),
      body: Container(
        decoration: BoxDecoration(color: Color(0xff1c1c1c)),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16),
                  child: _subindoImagem
                      ? CircularProgressIndicator()
                      : Container(),
                ),
                CircleAvatar(
                  radius: 45,
                  backgroundImage: _urlImagemRecuperada != null
                      ? NetworkImage(_urlImagemRecuperada)
                      : null,
                  backgroundColor: Color(0xfffafafa),

                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                 children: <Widget>[
                   FlatButton(
                     child: Text("Camera", style: TextStyle( color: Color(0xfffafafa)),),
                     onPressed: (){
                       _recuperarImagem("camera");
                     },
                   ),
                   FlatButton(
                     child: Text("Galeria", style: TextStyle( color: Color(0xfffafafa)),),
                     onPressed: (){
                       _recuperarImagem("galeria");
                     },
                   )
                 ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 9, top: 20),
                  child: TextField(
                    controller: _controllerNome,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 5, 32, 5),
                        hintText: "Qual seu nome completo?",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 9),
                  child: TextField(
                    controller: _controllerTelefone,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 10, 32, 10),
                        hintText: "Qual seu telefone? Com DDD =D",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 9),
                  child: TextField(
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 10, 32, 10),
                        hintText: "Qual seu e-mail?",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 9),
                  child: TextField(
                    controller: _controllerSenha,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 10, 32, 10),
                        hintText: "Qual vai ser a sua senha?",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: TextField(
                    controller: _controllerHabilidade,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 16,),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 10, 32, 10),
                        hintText: "Qual sua Habilidade",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: TextField(
                    controller: _controllerResumoHabilidade,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 16,),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 100, 32, 100),
                        hintText: "Resumo da Habilidade",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: TextField(
                    controller: _controllerCurso,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 16,),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 10, 32, 10),
                        hintText: "Curso",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: TextField(
                    controller: _controllerData,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 16,),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 10, 32, 10),
                        hintText: "Data de Conclusão",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: TextField(
                    controller: _controllerInstituicao,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 16,),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 10, 32, 10),
                        hintText: "Instituição",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 15,),
                  child: RaisedButton(
                      child: Text(
                        "Salvar",
                        style: TextStyle(
                          color: Color(0xFFFAFAFA),
                          fontSize: 18,
                        ),
                      ),
                      color: Color(0xFFF5A622),
                      padding: EdgeInsets.fromLTRB(32, 10, 32, 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () {
                        _atualizarDadosFirestore();
                      }
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
