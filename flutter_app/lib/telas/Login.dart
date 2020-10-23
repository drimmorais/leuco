import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/telas/Curriculos.dart';
import '../model/Usuario.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController _controllerEmail = TextEditingController(text: "adriellefmorais@gmail.com");
  TextEditingController _controllerSenha = TextEditingController(text: "teste123");
  String _mensagemErro = "";
  bool _isLoggedIn = false;

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
  }

  _logout(){
    _googleSignIn.signOut();
    setState(() {
      _isLoggedIn = false;
    });
  }

  _validarCampos() {

    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if( email.isNotEmpty){
      if( senha.isNotEmpty ){
        setState(() {
          _mensagemErro= "";
        });

        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;

        _logarUsuario( usuario );

      }else{
        setState(() {
          _mensagemErro = "Por favor, preencha a senha!";
        });
      }

    }else{
      setState(() {
        _mensagemErro = "Por favor, preencha o e-mail!";
      });
    }
  }

  _logarUsuario(Usuario usuario){

    FirebaseAuth auth = FirebaseAuth.instance;

    auth.signInWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then((firebaseUser){

      Navigator.pushReplacement(
          context, MaterialPageRoute(
          builder: (BuildContext context) => Curriculos()
      )
      );

      }).catchError((error){

      setState(() {
        _mensagemErro = "Erro na autenticação. Verifique e-mail e senha!";
      });

    });

  }


  Future _verificarUsuarioLogado() async{

    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();

    FirebaseUser usuarioLogado = await auth.currentUser();

    if(usuarioLogado != null){

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Curriculos(),
          )
      );


    }else {

    }
  }

  @override
  void initState(){
    _verificarUsuarioLogado();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Color(0xFF1c1c1c),
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xff1C1C1C)),
        padding: EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                     child: Text("LOGIN",
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30, color: Color(0xffFAFAFA),)
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 90 , bottom: 35),
                      child: TextField(
                         controller: _controllerEmail,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "E-mail",
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3)
                          )
                        ),
                      ),
                    ),
                    TextField(
                      controller: _controllerSenha,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Senha",
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3)
                          )
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 35, bottom: 15,),
                      child: RaisedButton(
                        child: Text(
                          "ENTRAR",
                          style: TextStyle(
                            color: Color(0xFFFAFAFA),
                            fontSize: 20,
                          ) ,
                        ),
                          color: Color(0xFFF5A622),
                          padding: EdgeInsets.fromLTRB(25, 16, 25, 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3)
                          ),
                          onPressed:(){

                         _validarCampos();

                          }
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 15),
                     child: Center(
                          child: Text(
                            _mensagemErro,
                            style: TextStyle(
                              color: Color(0xFFFAFAFA),
                              fontSize: 18,
                            ),
                          )
                      )
                    ),
                                      ],
                ),
              )
            ),
          ),
    );
  }
}
