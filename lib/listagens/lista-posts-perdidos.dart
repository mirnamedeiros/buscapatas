import 'package:buscapatas/components/animal_card.dart';
import 'package:buscapatas/components/navbar.dart';
import 'package:buscapatas/visualizacoes/info-post-perdido-avistar.dart';
import 'package:flutter/material.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;

class ListaPostsPerdidos extends StatefulWidget {
  const ListaPostsPerdidos({super.key, required this.title});

  final String title;

  @override
  State<ListaPostsPerdidos> createState() => _ListaPostsPerdidos();
}

class _ListaPostsPerdidos extends State<ListaPostsPerdidos> {
  List<String> listaPostAvistados = [];
  TextEditingController buscaController = TextEditingController();

  @override
  void initState() {
    //Para pegar o valor da sessao
  }

  @override
  Widget build(BuildContext context) {
    listaPostAvistados.add("Animal 1");
    listaPostAvistados.add("Animal 2");
    listaPostAvistados.add("Animal 3");
    listaPostAvistados.add("Animal 4");
    listaPostAvistados.add("Animal 5");
    listaPostAvistados.add("Animal 6");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text("Animais Perdidos",
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          foregroundColor: Colors.white,
          backgroundColor: estilo.corprimaria),
      bottomNavigationBar: const BuscapatasNavBar(selectedIndex: 1),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 10, 30.0, 10.0),
          child: Column(children: <Widget>[
            campoInput("Busca", buscaController, TextInputType.name,
                "Informe sua Busca"),
            Expanded(
              child: ListView.builder(
                  itemCount: listaPostAvistados.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        child: Card(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide.none,
                          ),
                        ),
                        onPressed: () {
                          _infoPostPerdido();
                        },
                        child: AnimalCard(
                          title: listaPostAvistados[index],
                          details:
                              "Gente, encontrei esse cachorrinho perto da ponte, tava virando uma lata de lixo.",
                          backgroundColor: estilo.corperdido,
                        ),
                      ),
                    ));
                  }),
            ),
          ])),
    );
  }

  void _infoPostPerdido() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              InfoPostPerdidoAvistar(title: "Animal Avistado")),
    );
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
}
