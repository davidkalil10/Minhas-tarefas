import 'package:flutter/material.dart';
import 'package:minhas_anotacoes/Model/Anotacao.dart';
import 'package:minhas_anotacoes/helper/AnotacaoHelper.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();

  var _db = AnotacaoHelper();
  List<Anotacao> _anotacoes = List<Anotacao>();


  _exibirTelaCadastro({Anotacao anotacao}){


    String textoSalvarAtualizar = "";
    String tituloCard = "";
    if( anotacao == null){ //salvando
     _tituloController.text="";
     _descricaoController.text="";
     textoSalvarAtualizar = "Salvar";
     tituloCard = "Adicionar anotação";
    }else{ //atualizar

      _tituloController.text=anotacao.titulo;
      _descricaoController.text=anotacao.descricao;

      textoSalvarAtualizar = "Atualizar";
      tituloCard = "Atualizar anotação";

    }


    showDialog(
      context: context,
      builder: (context){
          return AlertDialog(
            title: Text(tituloCard),
            content: Column(
              mainAxisSize: MainAxisSize.min, //ocupar espaço mínimo da tela
              children: <Widget>[
                TextField(
                  controller: _tituloController ,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Título",
                    hintText: "Digite o título.."
                  ),
                ),
                TextField(
                  controller: _descricaoController ,
                  decoration: InputDecoration(
                      labelText: "Descrição",
                      hintText: "Digite a descrição.."
                  ),
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: ()=> Navigator.pop(context),
                  child: Text("Cancelar")
              ),
              FlatButton(
                  onPressed: (){

                    _salvarAtualizarAnotacao(anotacaoSelecionada: anotacao);
                    Navigator.pop(context);
                  },
                  child: Text(textoSalvarAtualizar)
              )
            ],
          );
      }
    );

  }

  _recuperarAnotacao() async{

    List anotacoesRecuperadas = await _db.recuperarAnotacao();

    List<Anotacao> listaTemporaria = List<Anotacao>();
    for (var item in anotacoesRecuperadas){

      Anotacao anotacao = Anotacao.fromMap(item);
      listaTemporaria.add(anotacao);

    }

    setState(() {
      _anotacoes = listaTemporaria;
    });
    listaTemporaria = null;

    print("lista anotações: " + anotacoesRecuperadas.toString());

  }

  _salvarAtualizarAnotacao({Anotacao anotacaoSelecionada}) async{
    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;
    //print("data atual: " + DateTime.now().toString());

    if (anotacaoSelecionada == null){//salvar

      Anotacao anotacao = Anotacao(titulo, descricao, DateTime.now().toString());
      int resultado = await _db.salvarAnotacao(anotacao); //resultado será o id

    }else{//atualizar

      anotacaoSelecionada.titulo = titulo;
      anotacaoSelecionada.descricao = descricao;
      //anotacaoSelecionada.data = DateTime.now().toString(); //se quiser atualizar a data
      int resultado = await _db.atualizarAnotacao(anotacaoSelecionada);

    }




   _tituloController.clear(); //limpar a memoria do controller
   _descricaoController.clear(); //limpar a memoria do controller

    _recuperarAnotacao();

  }

  _formatarData(String data){

    //pacote intl para formatar datas

    initializeDateFormatting("pt_BR");

    //year-> y month->M day-> d
    // Hour-> H minute-> m second -> s

   // var formatador = DateFormat("d/MM-y H:m:s");
    var formatador = DateFormat.yMMMMd("pt_BR");

    DateTime dataConvertida = DateTime.parse(data);
    String dataFormatada = formatador.format(dataConvertida);

    return dataFormatada;
  }

  _removreAnotacao(int id)async{
    await _db.removerAnotacao(id);

    _recuperarAnotacao();

  }


  @override
  void initState() { //metodo que roda antes do build
    super.initState();
    _recuperarAnotacao();
  }


  @override

  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas Anotações"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: <Widget>[
          Expanded( //usado para a lista ocupar todo o espaço disponível
              child: ListView.builder(
                  itemCount: _anotacoes.length,
                  itemBuilder: (context, index){

                    final anotacao  = _anotacoes[index];

                    return Card(
                        child: ListTile(
                        title: Text(anotacao.titulo),
                        subtitle:Text("${_formatarData(anotacao.data)} - ${anotacao.descricao}") ,
                        trailing: Row( //icones no card
                          mainAxisSize: MainAxisSize.min, //icone ocupar o mino de espaço
                          children: <Widget>[
                            GestureDetector(
                              onTap: (){
                                _exibirTelaCadastro(anotacao: anotacao);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 16),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                _removreAnotacao(anotacao.id);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 0),
                                child: Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
              )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightGreen,
          foregroundColor: Colors.white,
          child: Icon(Icons.add),
          onPressed: (){
            _exibirTelaCadastro();

          }
      ),
    );
  }
}
