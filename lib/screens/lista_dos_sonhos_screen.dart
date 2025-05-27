import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ListaDosSonhosScreen extends StatefulWidget {
  const ListaDosSonhosScreen({super.key});

  @override
  _ListaDosSonhosScreenState createState() => _ListaDosSonhosScreenState();
}

class _ListaDosSonhosScreenState extends State<ListaDosSonhosScreen> {
  List<Map<String, dynamic>> destinos = [];

  @override
  void initState() {
    super.initState();
    carregarDestinos();
  }

  Future<void> carregarDestinos() async {
    final prefs = await SharedPreferences.getInstance();
    final listaString = prefs.getStringList('lista_destinos') ?? [];

    setState(() {
      destinos = listaString
    .map((item) => jsonDecode(item) as Map<String, dynamic>)
    .toList();
    });
  }

  Future<void> removerDestino(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final listaString = prefs.getStringList('lista_destinos') ?? [];

    listaString.removeAt(index);
    await prefs.setStringList('lista_destinos', listaString);

    carregarDestinos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Minha Lista dos Sonhos')),
      body: destinos.isEmpty
          ? Center(child: Text('Nenhum destino salvo ainda.'))
          : ListView.builder(
              itemCount: destinos.length,
              itemBuilder: (context, index) {
                final destino = destinos[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text('${destino['cidade']} - ${destino['pais']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Época: ${destino['epoca']}'),
                        Text('Viajar nos próximos 12 meses: ${destino['viajar_12_meses'] ? "Sim" : "Não"}'),
                        Text('Já visitou: ${destino['ja_visitou'] ? "Sim" : "Não"}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => removerDestino(index),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
