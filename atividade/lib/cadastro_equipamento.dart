import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CadastroEquipamentoPage extends StatelessWidget {
  final Set<String> nomesEquipamentos;

  CadastroEquipamentoPage({required this.nomesEquipamentos});

  final TextEditingController nomeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastrar Equipamento')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: InputDecoration(labelText: 'Nome do Equipamento'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                cadastrarEquipamento(context);
              },
              child: Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> cadastrarEquipamento(BuildContext context) async {
    final nome = nomeController.text.trim();

    // Verifica se o nome já está no conjunto de nomesEquipamentos
    if (nomesEquipamentos.contains(nome)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Equipamento já existe!'),
      ));
      return; // Retorna se o equipamento já existe
    }

    try {
      final response = await http.post(
        Uri.parse(
            'https://app-web-uniara-example-60f73cc06c77.herokuapp.com/equipamentos'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"nome": nome, "disponivel": true}),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Equipamento cadastrado com sucesso!'),
        ));
        nomesEquipamentos.add(nome);
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Falha ao cadastrar equipamento: ${response.body}'),
        ));
      }
    } catch (e) {
      print('Erro ao cadastrar equipamento: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao cadastrar equipamento'),
      ));
    }
  }
}
