import 'package:flutter/material.dart';
import 'package:buscapatas/home.dart';
import 'package:buscapatas/listagens/lista-posts-avistados.dart';
import 'package:buscapatas/listagens/lista-posts-perdidos.dart';

import '../perfil_usuario.dart';

class BuscapatasNavBarExtra extends StatefulWidget {
  const BuscapatasNavBarExtra({super.key});

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  BuscapatasNavBarExtraState createState() => BuscapatasNavBarExtraState();
}

class BuscapatasNavBarExtraState extends State<BuscapatasNavBarExtra> {
  void _onItemTapped(int index) {
    setState(() {
      switch (index) {
        case 0:
          return _home();
        case 1: return _listarAnimaisPerdidos();
        case 2: return _listarAnimaisAvistados();
        case 3:
          return _visualizarPerfil();
        default:
      }
    });
  }

  void _home() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Home(true, title: "Cadastrar Animal")),
    );
  }

  void _visualizarPerfil() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => VisualizarPerfil(title: "Perfil")),
    );
  }

  void _listarAnimaisAvistados() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ListaPostsAvistados(title: "Animais avistados")),
    );
  }

  void _listarAnimaisPerdidos() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ListaPostsPerdidos(title: "Animais avistados")),
    );
  }


  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Página inicial',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Animais perdidos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Animais avistados',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
      currentIndex: 0,
      selectedItemColor: Color.fromARGB(255, 115, 115, 115),

      onTap: _onItemTapped,
    );
  }
}
