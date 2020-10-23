import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/model/Usuario.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Curriculos.dart';



class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {

  //Controladores
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerTelefone = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController(text: "teste123");
  TextEditingController _controllerHabilidade = TextEditingController();
  TextEditingController _controllerResumoHabilidade = TextEditingController();
  TextEditingController _controllerCurso = TextEditingController(text: "Sistemas de Informação");
  TextEditingController _controllerData = TextEditingController(text: "31/12/2021");
  TextEditingController _controllerInstituicao = TextEditingController(text: "FAI");
  String _mensagemErro = "";
  bool _isLoggedIn = false;
/*  File _imagem;
  String _idUsuarioLogado;
  bool _subindoImagem = false;
  String _urlImagemRecuperada;*/

/*  Future _recuperarImagem(String origemImagem) async {

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

  _atualizarUrlImagemFirestore(String url){

    Firestore db = Firestore.instance;

    Map<String, dynamic> dadosAtualizar = {
      "urlImagem" : url
    };

    db.collection("usuarios")
        .document(_idUsuarioLogado)
        .updateData( dadosAtualizar );

  }
*/
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  _login() async{

    try{
      await _googleSignIn.signIn();
      setState(() {
        _isLoggedIn = true;
      });
    } catch (err){
      print(err);
    }

    if(_isLoggedIn == true){
      _addGoogle();
    }
  }

  _addGoogle(){

    Usuario usuario = Usuario();
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;

    email = _googleSignIn.currentUser.email;
    nome = _googleSignIn.currentUser.displayName;

    print(email);
    print(nome);

    _cadastroGoogle(usuario);
}

  _cadastroGoogle(Usuario usuario){

    FirebaseAuth auth = FirebaseAuth.instance;
    print("passou1");
      auth.currentUser().then((firebaseUser)  {
        print("passou2");
        Firestore db = Firestore.instance;


        db.collection("usuario")
        .document( firebaseUser.uid)
        .setData(usuario.toMap());


        Navigator.pushReplacement(
            context, MaterialPageRoute(
            builder: (BuildContext context) => Curriculos()
        )
        );

      }).catchError((error) {

        setState(() {
          _mensagemErro = "Erro ao cadastrar, verifique os campos e tente novamente";
        });
      });

  }

  _validarCampos(){
    String nome = _controllerNome.text;
    String telefone = _controllerTelefone.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;
    String habilidade = _controllerHabilidade.text;
    String resumoHabilidade = _controllerResumoHabilidade.text;
    String curso = _controllerCurso.text;
    String data = _controllerData.text;
    String instituicao = _controllerInstituicao.text;

    if (nome.isNotEmpty && nome.length >= 3) {
      if (telefone.isNotEmpty && telefone.length >= 11) {
        if (email.isNotEmpty && email.contains("@")) {
          if (senha.isNotEmpty && senha.length > 6) {
            if (habilidade.isNotEmpty) {
              if (resumoHabilidade.isNotEmpty && resumoHabilidade.length > 10) {
                if (curso.isNotEmpty && curso.length > 3) {
                  if (data.isNotEmpty) {
                    if (instituicao.isNotEmpty && curso.length > 2) {

                      Usuario usuario = Usuario();
                      usuario.nome = nome;
                      usuario.telefone = telefone;
                      usuario.email = email;
                      usuario.senha = senha;
                      usuario.habilidade = habilidade;
                      usuario.resumoHabilidade = resumoHabilidade;
                      usuario.curso = curso;
                      usuario.data = data;
                      usuario.instituicao = instituicao;

                      _cadastrarusuario(usuario);
                    } else
                      setState(() {
                        _mensagemErro =
                        "Poxa, conta para gente qual foi a instituição?";
                      });
                  } else
                    setState(() {
                      _mensagemErro =
                      "Qual a data de conclusão? Ou a de termino";
                    });
                } else
                  setState(() {
                    _mensagemErro =
                    "Poxa, conta para gente o curso que você fez?";
                  });
              } else {
                setState(() {
                  _mensagemErro =
                  "Poxa, conta para gente suas mais sobre suas habilidades?";
                });
              }
            } else {
              setState(() {
                _mensagemErro = "Poxa, conta para gente suas habilidades?";
              });
            }
          } else {
            setState(() {
              _mensagemErro = "Senha Inválida! Digite mais de 6 caracteres";
            });
          }
        } else {
          setState(() {
            _mensagemErro = "E-mail Inválido";
          });
        }
      } else
        setState(() {
          _mensagemErro = "Telefone Inválido";
        });
    } else {
      setState(() {
        _mensagemErro = "Preencha o Nome";
      });
    }
  }

  _cadastrarusuario( Usuario usuario){

    FirebaseAuth auth = FirebaseAuth.instance;

    auth.createUserWithEmailAndPassword(email: usuario.email,
        password: usuario.senha).then((firebaseUser) {

      Firestore db = Firestore.instance;

       db.collection("usuario")
          .document( firebaseUser.uid)
          .setData(usuario.toMap());


      Navigator.pushReplacement(
          context, MaterialPageRoute(
            builder: (BuildContext context) => Curriculos()
        )
        );

    }).catchError((error) {

    setState(() {
      _mensagemErro = "Erro ao cadastrar, verifique os campos e tente novamente";
               });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Conte um pouco sobre você!"),
        backgroundColor: Color(0xFF1c1c1c),
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xFF1c1c1c)),
        padding: EdgeInsets.all(16),
        child: Center(

            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(30),
                    child: Center(
                      child: _isLoggedIn
                            ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                              Image.network(_googleSignIn.currentUser.photoUrl, height: 50.0, width: 50.0, ),
                            Text(_googleSignIn.currentUser.displayName, style: TextStyle(color:
                            Color(0xfffafafa) ),),
                          /*  Text(_, style: TextStyle(color:
                            Color(0xfffafafa)),),*/
                           RaisedButton(
                              child: Text("Desconectar", style: TextStyle( color: Color(0xFFFAFAFA),
                            ),
                            ),
                              color: Color(0xFFF5A622),

                              onPressed: (){
                             // _logout();
                            },)
                          ],
                        )
                            : Center(
                          child: RaisedButton(
                            child: Text("Cadastre-se com Google", style: TextStyle( color: Color(0xFFFAFAFA),
                            ),
                            ),
                            color: Color(0xFFF5A622),

                            onPressed: () {
                              _login();
                            },
                          ),
                        )),
                  ),
                  CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[400],
                    /* backgroundImage:
                      _urlImagemRecuperada != null
                      ? NetworkImage(_urlImagemRecuperada)
                      :null*/
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          color: Color(0xfffafafa),
                          child: Text("Câmera"),

                          onPressed: (){
                         //   _recuperarImagem("camera");

                          }
                      ),
                      FlatButton(
                        color: Color(0xfffafafa),
                        child: Text("Galeria"),
                        onPressed: (){
                         //      _recuperarImagem("galeria");
                        },
                      )],
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
                          "Concluir",
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
                          _validarCampos();
                        }
                    ),
                  ),
                  Center(
                        child: Text(
                          _mensagemErro,
                          style: TextStyle(
                            color: Color(0xfffafafa),
                            fontSize: 20,
                          ),
                        )
                    )
                ],
              ),
            )),
      ),
    );
  }
}

