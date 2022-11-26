import 'package:buscapatas/model/NotificacaoAvistamentoModel.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:buscapatas/home.dart';
import 'package:buscapatas/model/UsuarioModel.dart';
import 'package:buscapatas/components/campo_texto_longo.dart';
import 'package:http/http.dart' as http;
import 'package:buscapatas/components/caixa_dialogo_alerta.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;
import 'package:buscapatas/utils/localizacao.dart' as localizacao;
import 'package:buscapatas/utils/usuario_logado.dart' as usuario_sessao;

class CadastroNotificacaoAvistado extends StatefulWidget {
  const CadastroNotificacaoAvistado(
      {super.key, required this.title, required this.postId});

  final String title;
  final int postId;

  @override
  State<CadastroNotificacaoAvistado> createState() =>
      _CadastroNotificacaoAvistadoState();
}

class _CadastroNotificacaoAvistadoState
    extends State<CadastroNotificacaoAvistado> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController mensagemController = TextEditingController();

  UsuarioModel usuarioLogado = UsuarioModel();

  @override
  void initState() {
    carregarUsuarioLogado();
    super.initState();
  }

  void carregarUsuarioLogado() async {
    await usuario_sessao
        .getUsuarioLogado()
        .then((value) => usuarioLogado = value);
    //Necessário para recarregar a página após ter pegado o valor de usuarioLogado
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text("Cadastro de Notificação",
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: estilo.corprimaria,
          foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(30.0, 50, 30.0, 20.0),
        child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CampoTextoLongo(
                    rotulo: "Mensagem para o dono",
                    controlador: mensagemController,
                    placeholder:
                        "Informe o estado, a descrição ou algumas informações sobre o animal avistado",
                    obrigatorio: true),
                const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 10)),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(estilo.corprimaria),
                      ),
                      onPressed: () {
                        _cadastrarNotificacao();
                      },
                      child: const Text(
                        "Cadastrar",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    )),
                const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10)),
              ],
            )),
      ),
    );
  }

  void _cadastrarNotificacao() {
    if (_formKey.currentState!.validate()) {
      _addNotificacao();
    }
  }

  void _addNotificacao() async {
    var url = NotificacaoAvistamentoModel.getUrlSalvarNotificacao();
    double valorLatitude = 0;
    await localizacao.getLatitudeAtual().then((value) => valorLatitude = value);

    double valorLongitude = 0;
    await localizacao
        .getLongitudeAtual()
        .then((value) => valorLongitude = value);

    var response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          if (mensagemController.text.isNotEmpty)
            "mensagem": mensagemController.text,
          "latitude": valorLatitude,
          "longitude": valorLongitude,
          "usuario": usuarioLogado,
          "post": {"id": widget.postId}
        }));

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return CaixaDialogoAlerta(
              titulo: "Mensagem do servidor",
              conteudo: response.body,
              funcao: _redirecionarPaginaAposSalvar);
        },
      );
    }
  }

  void _redirecionarPaginaAposSalvar() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Home(true, title: 'Busca Patas')));
  }
}
