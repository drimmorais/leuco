
import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {

  String _nome;
  String _telefone;
  String _email;
  String _senha;
  String _habilidade;
  String _resumoHabilidade;
  String _curso;
  String _data;
  String _instituicao;
  String _urlImagem;

  Usuario();

  Map<String, dynamic> toMap(){
    Map<String, dynamic>map = {
      "nome" : this.nome,
      "telefone": this.telefone,
      "email": this.email,
      "senha": this.senha,
      "habilidade": this.habilidade,
      "resumoHabilidade": this.resumoHabilidade,
      "curso": this.curso,
      "data": this.data,
      "instituicao": this.instituicao,
      "urlImagem" : this.urlImagem,
    };

    return map;
  }

  String get habilidade => _habilidade;

  set habilidade(String value) {
    _habilidade = value;
  }

  String get resumoHabilidade => _resumoHabilidade;

  set resumoHabilidade(String value) {
    _resumoHabilidade = value;
  }

  String get curso => _curso;

  set curso(String value) {
    _curso = value;
  }

  String get data => _data;

  set data(String value) {
    _data = value;
  }


  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get telefone => _telefone;

  set telefone(String value) {
    _telefone = value;
  }


  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get instituicao => _instituicao;

  set instituicao(String value) {
    _instituicao = value;
  }

  String get urlImagem => _urlImagem;

  set urlImagem(String value) {
    _urlImagem = value;
  }


}