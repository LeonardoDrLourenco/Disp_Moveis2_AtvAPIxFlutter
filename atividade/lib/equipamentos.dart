import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cadastro_equipamento.dart';

class EquipamentosPage extends StatefulWidget {
  @override
  _EquipamentosPageState createState() => _EquipamentosPageState();
}

class _EquipamentosPageState extends State<EquipamentosPage> {
  List<dynamic> equipamentos = [];
  Set<String> nomesEquipamentos = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEquipamentos();
  }

  Future<void> fetchEquipamentos() async {
    try {
      final response = await http.get(Uri.parse(
          'https://app-web-uniara-example-60f73cc06c77.herokuapp.com/equipamentos'));

      if (response.statusCode == 200) {
        setState(() {
          equipamentos = json.decode(response.body);
          isLoading = false;
          nomesEquipamentos = equipamentos.isNotEmpty
              ? equipamentos.map((e) => e['nome'].toString()).toSet()
              : {};
        });
      } else {
        throw Exception('Falha ao carregar equipamentos');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Erro ao buscar equipamentos: $e');
    }
  }

  Future<void> reservarEquipamento(int equipamentoId) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://app-web-uniara-example-60f73cc06c77.herokuapp.com/equipamentos/$equipamentoId/reservar'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        setState(() {
          final index =
              equipamentos.indexWhere((e) => e['id'] == equipamentoId);
          if (index != -1) {
            equipamentos[index]['disponivel'] = false;
            equipamentos[index]['data_retirada'] = DateTime.now().toString();
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Equipamento reservado com sucesso!'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Equipamento já reservado nesse período!'),
        ));
      }
    } catch (e) {
      print('Erro ao reservar equipamento: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao reservar equipamento'),
      ));
    }
  }

  Future<void> liberarEquipamento(int equipamentoId) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://app-web-uniara-example-60f73cc06c77.herokuapp.com/equipamentos/$equipamentoId/liberar'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        setState(() {
          final index =
              equipamentos.indexWhere((e) => e['id'] == equipamentoId);
          if (index != -1) {
            equipamentos[index]['disponivel'] = true;
            equipamentos[index]['data_retirada'] = null;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Reserva liberada com sucesso!'),
        ));
      } else {
        throw Exception('Falha ao liberar reserva');
      }
    } catch (e) {
      print('Erro ao liberar reserva: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao liberar reserva'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Equipamentos')),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Cadastrar Equipamento'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastroEquipamentoPage(
                        nomesEquipamentos: nomesEquipamentos),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Consultar Equipamentos'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: equipamentos.length,
              itemBuilder: (context, index) {
                final equipamento = equipamentos[index];
                return ListTile(
                  title: Text(equipamento['nome']),
                  subtitle: Text(equipamento['disponivel']
                      ? 'Disponível'
                      : 'Reservado em: ${equipamento['data_retirada']}'),
                  trailing: equipamento['disponivel']
                      ? ElevatedButton(
                          onPressed: () {
                            reservarEquipamento(equipamento['id']);
                          },
                          child: Text('Reservar'),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            liberarEquipamento(equipamento['id']);
                          },
                          child: Text('Liberar'),
                        ),
                );
              },
            ),
    );
  }
}
