import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DetalhesScreen extends StatefulWidget {
  const DetalhesScreen({super.key});

  @override
  _DetalhesScreenState createState() => _DetalhesScreenState();
}

class _DetalhesScreenState extends State<DetalhesScreen> {
  String epocaPreferida = 'Verão';
  bool desejaViajar = false;
  bool jaVisitou = false;

  late Map city;

  final List<String> opcoesEpoca = ['Verão', 'Inverno', 'Outono', 'Primavera'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    city = ModalRoute.of(context)!.settings.arguments as Map;
  }

  Future<void> salvarDestino() async {
    final prefs = await SharedPreferences.getInstance();
    final String chave = 'lista_destinos';
    final destino = {
      'cidade': city['city'],
      'pais': city['country'],
      'epoca': epocaPreferida,
      'viajar_12_meses': desejaViajar,
      'ja_visitou': jaVisitou,
    };

    final listaAtual = prefs.getStringList(chave) ?? [];
    listaAtual.add(jsonEncode(destino));
    await prefs.setStringList(chave, listaAtual);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Destino salvo na lista dos sonhos!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${city['city']} - ${city['country']}')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Planeje sua viagem',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Qual a melhor época para visitar?'),
            Column(
              children: opcoesEpoca.map((epoca) {
                return RadioListTile<String>(
                  title: Text(epoca),
                  value: epoca,
                  groupValue: epocaPreferida,
                  onChanged: (valor) {
                    setState(() {
                      epocaPreferida = valor!;
                    });
                  },
                );
              }).toList(),
            ),
            SwitchListTile(
              title: Text('Deseja viajar nos próximos 12 meses?'),
              value: desejaViajar,
              onChanged: (valor) {
                setState(() {
                  desejaViajar = valor;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Você já visitou este lugar?'),
              value: jaVisitou,
              onChanged: (valor) {
                setState(() {
                  jaVisitou = valor!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: salvarDestino,
              child: Text('Salvar destino'),
            ),
          ],
        ),
      ),
    );
  }
}
