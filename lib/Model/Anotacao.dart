
import 'package:minhas_anotacoes/helper/AnotacaoHelper.dart';

class Anotacao{
  int id;
  String titulo;
  String descricao;
  String data;

  Anotacao(this.titulo, this.descricao, this.data);


  Anotacao.fromMap(Map map){ //construtor recebe um map e retorna um objeto
    this.id = map[AnotacaoHelper.colunaId];
    this.titulo = map[AnotacaoHelper.colunaTitulo];
    this.descricao = map[AnotacaoHelper.colunaDescricao];
    this.data = map[AnotacaoHelper.colunaData];
    // nao precisa ter um return pq ao usar o this já esta instanciando a classe anotacao
  }


  Map toMap(){
    Map<String, dynamic> map = {
      "titulo" : this.titulo,
      "descricao" : this.descricao,
      "data" : this.data,
    };

    if (this.id != null ){ //retorna o id somente se tiver um id
      map["id"] = this.id;
    }

    return map;
  }

}