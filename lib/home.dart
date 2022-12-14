import 'package:buscapatas/cadastros/cadastro-post-avistado.dart';
import 'package:buscapatas/visualizacoes/info-post-avistado.dart';
import 'package:flutter/material.dart';
import 'package:buscapatas/publico/login.dart';
import 'package:buscapatas/cadastros/cadastro-post.dart';
import 'package:buscapatas/perfil-usuario.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:buscapatas/model/UsuarioModel.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;

//OBS: Essa página é temporária e está simulando a página inicial
class Home extends StatefulWidget {
  bool autorizado;
  Home(bool usuario, {super.key, required this.title})
      : this.autorizado = usuario;

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    //Para pegar o valor da sessao
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    if (!widget.autorizado) {
      return Login(title: 'Busca Patas - Login');
    } else {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              title: const Text("Busca Patas"),
              centerTitle: true,
              backgroundColor: estilo.corprimaria),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(30.0, 50, 30.0, 10.0),
            child: Column(
              children: <Widget>[
                const Text("Página inicial ainda não implementada",
                    style: TextStyle(color: estilo.corprimaria, fontSize: 20)),
                Padding(padding: const EdgeInsets.fromLTRB(0, 10, 0, 10.0)),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(estilo.corprimaria),
                      ),
                      onPressed: () {
                        _cadastrarAnimal();
                      },
                      child: const Text(
                        "Cadastrar Animal",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    )),
                Padding(padding: const EdgeInsets.fromLTRB(0, 10, 0, 10.0)),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(estilo.corprimaria),
                      ),
                      onPressed: () {
                        _cadastrarAnimalAvistado();
                      },
                      child: const Text(
                        "Cadastrar Animal Avistado",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    )),
                Padding(padding: const EdgeInsets.fromLTRB(0, 10, 0, 10.0)),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(estilo.corprimaria),
                      ),
                      onPressed: () {
                        _infoPostAvistado();
                      },
                      child: const Text(
                        "Informação Post Avistado",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    )),
                Padding(padding: const EdgeInsets.fromLTRB(0, 10, 0, 10.0)),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(estilo.corprimaria),
                      ),
                      onPressed: () {
                        _visualizarPerfil();
                      },
                      child: const Text(
                        "Visualizar perfil",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    )),
              ],
            ),
          ));
    }
  }

  void _cadastrarAnimal() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CadastroPost(title: "Cadastrar Animal")),
    );
  }

  void _cadastrarAnimalAvistado() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              CadastroPostAvistado(title: "Cadastrar Animal Avistado")),
    );
  }

  void _infoPostAvistado() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => InfoPostAvistado(title: "Animal Avistado")),
    );
  }

  void _visualizarPerfil() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => VisualizarPerfil(title: "Perfil")),
    );
  }
}
