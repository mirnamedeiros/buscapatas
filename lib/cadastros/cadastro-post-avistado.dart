import 'package:buscapatas/model/EspecieModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'dart:convert';
import 'package:buscapatas/home.dart';
import 'package:buscapatas/model/UsuarioModel.dart';
import 'package:buscapatas/model/PostModel.dart';
import 'package:buscapatas/model/RacaModel.dart';
import 'package:buscapatas/model/CorModel.dart';
import 'package:http/http.dart' as http;
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;
import 'package:buscapatas/utils/localizacao.dart' as localizacao;

class CadastroPostAvistado extends StatefulWidget {
  const CadastroPostAvistado({super.key, required this.title});

  final String title;

  @override
  State<CadastroPostAvistado> createState() => _CadastroPostAvistadoState();
}

class _CadastroPostAvistadoState extends State<CadastroPostAvistado> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController outrasinformacoesController = TextEditingController();

  bool valorColeiraMarcado = false;
  bool valorLarTemporario = false;
  String valorSexoMarcado = "";
  String? valorEspecieSelecionado;
  String? valorRacaSelecionado;
  String _mensagemValidacao = "";

  List<dynamic> listaEspecies = [];
  List<dynamic> listaRacas = [];

  Map<String, bool> mapaCoresNomeBool = {};
  Map<String, int> mapaCoresNomeId = {};
  List<int> listaCoresSelecionadas = [];
  UsuarioModel usuarioLogado = UsuarioModel();

  @override
  void initState() {
    cargaInicialBD();
    getUsuarioLogado();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Cadastro de Animal Avistado"),
          centerTitle: true,
          foregroundColor: Colors.white,
          backgroundColor: estilo.corprimaria),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(30.0, 50, 30.0, 20.0),
        child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                campoSelect("Espécie", valorEspecieSelecionado, listaEspecies,
                    selecionarEspecie),
                campoSelect(
                    "Raça", valorRacaSelecionado, listaRacas, selecionarRaca),
                const Text("Sexo:",
                    style: TextStyle(color: estilo.corprimaria, fontSize: 16)),
                RadioListTile(
                  visualDensity: const VisualDensity(horizontal: -4.0),
                  dense: true,
                  title: const Text("Macho",
                      style:
                          TextStyle(color: estilo.corprimaria, fontSize: 16)),
                  value: "M",
                  groupValue: valorSexoMarcado,
                  onChanged: (value) {
                    setState(() {
                      valorSexoMarcado = value.toString();
                    });
                  },
                ),
                RadioListTile(
                  visualDensity: const VisualDensity(horizontal: -4.0),
                  dense: true,
                  title: const Text("Fêmea",
                      style:
                          TextStyle(color: estilo.corprimaria, fontSize: 16)),
                  value: "F",
                  groupValue: valorSexoMarcado,
                  onChanged: (value) {
                    setState(() {
                      valorSexoMarcado = value.toString();
                    });
                  },
                ),
                const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 1.0)),
                const Text("Cor:",
                    style: TextStyle(color: estilo.corprimaria, fontSize: 16)),
                FractionallySizedBox(
                  widthFactor: 0.6,
                  child: ListView(
                    shrinkWrap: true,
                    children: mapaCoresNomeBool.keys.map((String key) {
                      return CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: new Text(key,
                            style: TextStyle(
                                color: estilo.corprimaria, fontSize: 16)),
                        value: mapaCoresNomeBool[key],
                        onChanged: (bool? value) {
                          setState(() {
                            mapaCoresNomeBool[key] = value!;
                            if (mapaCoresNomeBool[key] == true) {
                              listaCoresSelecionadas.add(mapaCoresNomeId[key]!);
                            } else {
                              listaCoresSelecionadas
                                  .remove(mapaCoresNomeId[key]);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 10.0)),
                Text("Estava de coleira?",
                    style: TextStyle(color: estilo.corprimaria, fontSize: 16)),
                RadioListTile(
                  visualDensity: const VisualDensity(horizontal: -4.0),
                  dense: true,
                  title: const Text("Sim",
                      style:
                          TextStyle(color: estilo.corprimaria, fontSize: 16)),
                  value: true,
                  groupValue: valorColeiraMarcado,
                  onChanged: (value) {
                    setState(() {
                      valorColeiraMarcado = value!;
                    });
                  },
                ),
                RadioListTile(
                  visualDensity: const VisualDensity(horizontal: -4.0),
                  dense: true,
                  title: const Text("Não",
                      style:
                          TextStyle(color: estilo.corprimaria, fontSize: 16)),
                  value: false,
                  groupValue: valorColeiraMarcado,
                  onChanged: (value) {
                    setState(() {
                      valorColeiraMarcado = value!;
                    });
                  },
                ),
                const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 10.0)),
                Text("Deu lar temporário?",
                    style: TextStyle(color: estilo.corprimaria, fontSize: 16)),
                RadioListTile(
                  visualDensity: const VisualDensity(horizontal: -4.0),
                  dense: true,
                  title: const Text("Sim",
                      style:
                          TextStyle(color: estilo.corprimaria, fontSize: 16)),
                  value: true,
                  groupValue: valorLarTemporario,
                  onChanged: (value) {
                    setState(() {
                      valorLarTemporario = value!;
                    });
                  },
                ),
                RadioListTile(
                  visualDensity: const VisualDensity(horizontal: -4.0),
                  dense: true,
                  title: const Text("Não",
                      style:
                          TextStyle(color: estilo.corprimaria, fontSize: 16)),
                  value: false,
                  groupValue: valorLarTemporario,
                  onChanged: (value) {
                    setState(() {
                      valorLarTemporario = value!;
                    });
                  },
                ),
                campoInputLongo(
                    "Outras informações",
                    outrasinformacoesController,
                    TextInputType.multiline,
                    "Outras características para ajudar na identificação do animal"),
                const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                Text(
                  _mensagemValidacao,
                  style: TextStyle(color: Color(0xFFe53935)),
                ),
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
                        _cadastrarPost();
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

  void getUsuarioLogado() async {
    UsuarioModel usuario;
    usuario = UsuarioModel.fromJson(
        await (FlutterSession().get("sessao_usuarioLogado")));
    setState(() {
      usuarioLogado = usuario;
    });
  }

  void cargaInicialBD() async {
    List<dynamic> especiesTemp = await EspecieModel.getEspecies();
    Map<String, int> coresNomeIdTemp = await CorModel.getCores();
    Map<String, bool> coresTempNomeBool = {};

    for (var cor in coresNomeIdTemp.entries) {
      coresTempNomeBool[cor.key] = false;
    }
    setState(() {
      listaEspecies = especiesTemp;
      mapaCoresNomeId = coresNomeIdTemp;
      mapaCoresNomeBool = coresTempNomeBool;
    });
  }

  void getRacas() async {
    setState(() {
      valorRacaSelecionado = null;
    });

    List<dynamic> racasTemp = await RacaModel.getRacasByEspecie(valorEspecieSelecionado);
    
    setState(() {
      listaRacas.clear();
      listaRacas = racasTemp;
    });
  }

  void _cadastrarPost() {
    // Colocar a validação depois
    if (_formKey.currentState!.validate() &&
        valorEspecieSelecionado != null &&
        listaCoresSelecionadas.isNotEmpty) {
      _addPost();
    } else {
      _mensagemValidacao = "";
      if (valorEspecieSelecionado == null) {
        setState(() {
          _mensagemValidacao += "O campo Espécie deve ser preenchido. ";
        });
      }
      if(listaCoresSelecionadas.isEmpty){
        setState(() {
          _mensagemValidacao += "\nO campo Cor deve ser preenchido. ";
        });

      }
    }
  }

  void _addPost() async {
    var url = PostModel.getUrlSalvarPost();
    double valorLatitude = localizacao.getLatitudeAtual();
    double valorLongitude = localizacao.getLongitudeAtual();

    List<CorModel> cores = [];

    for (int corId in listaCoresSelecionadas) {
      CorModel corSelecionada = CorModel.id(corId);
      cores.add(corSelecionada);
    }

    var response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          if (outrasinformacoesController.text.isNotEmpty)
            "outrasInformacoes": outrasinformacoesController.text,
          //ajustar quando pegar latitude
          "latitude": valorLatitude,
          //ajustar quando pegar longitude
          "longitude": valorLongitude,
          "coleira": valorColeiraMarcado,
          "larTemporario": valorLarTemporario,
          if (valorEspecieSelecionado != null)
            "especieAnimal": {"id": int.parse(valorEspecieSelecionado!)},
          if (valorRacaSelecionado != null)
            "racaAnimal": {"id": int.parse(valorRacaSelecionado!)},
          "coresAnimal": cores,
          if (valorSexoMarcado.isNotEmpty) "sexoAnimal": valorSexoMarcado,
          "tipoPost": "ANIMAL_AVISTADO",
          //ajustar quando pegar usuario
          "usuario": usuarioLogado,
        }));

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return MyAlertDialog(
              titulo: "Mensagem do servidor", conteudo: response.body);
        },
      );
    }
  }

  void selecionarRaca(String racaSelecionada) {
    setState(() {
      valorRacaSelecionado = racaSelecionada;
    });
  }

  void selecionarEspecie(String especieSelecionada) {
    setState(() {
      valorEspecieSelecionado = especieSelecionada;
      valorRacaSelecionado = null;
    });
    getRacas();
  }

  Widget campoSelect(String label, var valorSelecionado, var listaItens,
      Function funcaoOnChange) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 20.0),
        child: DropdownButtonFormField<String>(
          hint: const Text("Selecione"),
          value: valorSelecionado,
          icon: const Icon(Icons.arrow_drop_down_rounded),
          elevation: 16,
          validator: (value) {
            if (label == "Espécie" && valorEspecieSelecionado == null) {
              return "O campo deve ser preenchido";
            }
          },
          decoration: InputDecoration(
            labelText: label,
            labelStyle:
                const TextStyle(fontSize: 21, color: estilo.corprimaria),
            border: OutlineInputBorder(),
          ),
          style: const TextStyle(color: estilo.corprimaria),
          onChanged: (String? valor) {
            funcaoOnChange(valor);
          },
          items: listaItens.map<DropdownMenuItem<String>>((mapa) {
            return DropdownMenuItem<String>(
              value: mapa["id"].toString(),
              child: Text(mapa["nome"]),
            );
          }).toList(),
        ));
  }

  Widget campoInput(String label, TextEditingController controller,
      TextInputType tipoCampo, String placeholder) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 20.0),
        child: TextFormField(
          keyboardType: tipoCampo,
          decoration: InputDecoration(
            labelText: label,
            labelStyle:
                const TextStyle(fontSize: 21, color: estilo.corprimaria),
            hintText: placeholder,
            hintStyle: const TextStyle(
                fontSize: 14.0, color: Color.fromARGB(255, 187, 179, 179)),
            border: const OutlineInputBorder(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          controller: controller,
        ));
  }

  Widget campoInputLongo(String label, TextEditingController controller,
      TextInputType tipoCampo, String placeholder) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 10.0),
        child: TextFormField(
          keyboardType: tipoCampo,
          decoration: InputDecoration(
              labelText: label,
              labelStyle:
                  const TextStyle(fontSize: 21, color: estilo.corprimaria),
              border: const OutlineInputBorder(),
              hintText: placeholder,
              hintStyle: const TextStyle(
                  fontSize: 14.0, color: Color.fromARGB(255, 187, 179, 179)),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              floatingLabelStyle:
                  const TextStyle(color: estilo.corprimaria, fontSize: 16)),
          controller: controller,
          maxLines: 4,
        ));
  }
}

class MyAlertDialog extends StatelessWidget {
  final String titulo;
  final String conteudo;

  MyAlertDialog({
    this.titulo = '',
    this.conteudo = '',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        this.titulo,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      actions: <Widget>[
        ElevatedButton(
            style: const ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll<Color>(estilo.corprimaria),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home(true, title: 'Busca Patas')));

              //Navigator.of(context).pop();
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.white, fontSize: 10.0),
            ))
      ],
      content: Text(
        conteudo,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
