import 'package:flutter/material.dart';
import 'equipamentos.dart';
import 'cadastro_equipamento.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gerenciamento de Equipamentos')),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Cadastrar Equipamento'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CadastroEquipamentoPage(nomesEquipamentos: {})),
                );
              },
            ),
            ListTile(
              title: Text('Consultar Equipamentos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EquipamentosPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Escolha uma opção no menu do canto superior esquerdo'),
      ),
    );
  }
}
