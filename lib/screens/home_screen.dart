import 'package:flutter/material.dart';
import '../services/api_service.dart';

String obterImagemEstado(String nome) {
  final estado = nome.toLowerCase();

  if (estado.contains('são paulo') || estado.contains('sao paulo')) return 'assets/images/sao_paulo.jpg';
  if (estado.contains('rio de janeiro')) return 'assets/images/rio.jpg';
  if (estado.contains('brasília') || estado.contains('brasilia')) return 'assets/images/brasilia.jpg';
  if (estado.contains('fortaleza')) return 'assets/images/fortaleza.jpg';
  if (estado.contains('salvador')) return 'assets/images/salvador.jpg';
  if (estado.contains('belo horizonte')) return 'assets/images/belo_horizonte.jpg';
  if (estado.contains('manaus')) return 'assets/images/manaus.jpg';
  if (estado.contains('curitiba')) return 'assets/images/curitiba.jpg';
  if (estado.contains('recife')) return 'assets/images/recife.jpg';

  return 'assets/images/default.jpg';
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _todasCidades = [];
  List<dynamic> _cidadesFiltradas = [];
  bool _carregando = true;
  bool _pesquisando = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    carregarCidades();
  }

  Future<void> carregarCidades() async {
    try {
      final cidades = await ApiService.fetchCities();
      setState(() {
        _todasCidades = cidades;
        _cidadesFiltradas = cidades;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _carregando = false;
      });
    }
  }

  void _filtrar(String texto) {
    setState(() {
      _cidadesFiltradas = _todasCidades
          .where((city) =>
              city['city'].toString().toLowerCase().contains(texto.toLowerCase()))
          .toList();
    });
  }

  void _ativarBusca() {
    setState(() {
      _pesquisando = true;
      _controller.clear();
      _cidadesFiltradas = _todasCidades;
    });
  }

  void _cancelarBusca() {
    setState(() {
      _pesquisando = false;
      _controller.clear();
      _cidadesFiltradas = _todasCidades;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _pesquisando
            ? TextField(
                controller: _controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Buscar destino...',
                  border: InputBorder.none,
                ),
                onChanged: _filtrar,
              )
            : Text('Destinos Populares'),
        actions: [
          _pesquisando
              ? IconButton(
                  icon: Icon(Icons.close),
                  onPressed: _cancelarBusca,
                )
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _ativarBusca,
                ),
          IconButton(
            icon: Icon(Icons.edit_note),
            onPressed: () {
              Navigator.pushNamed(context, '/lista');
            },
          ),
        ],
      ),
      body: _carregando
          ? Center(child: CircularProgressIndicator())
          : _pesquisando
              ? ListView(
                  children: _cidadesFiltradas.map((city) {
                    return ListTile(
                      leading: Icon(Icons.location_city),
                      title: Text(city['city']),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/detalhes',
                          arguments: city,
                        );
                      },
                    );
                  }).toList(),
                )
              : ListView.builder(
                  itemCount: _todasCidades.length,
                  itemBuilder: (context, index) {
                    final city = _todasCidades[index];

                    return Card(
                      margin: EdgeInsets.all(10),
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Stack(
                        children: [
                          Image.asset(
                            obterImagemEstado(city['city']),
                            width: double.infinity,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            height: 160,
                            width: double.infinity,
                            color: Colors.black.withOpacity(0.4),
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${city['city']} - ${city['country']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'População: ${city['population']}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/detalhes',
                                        arguments: city,
                                      );
                                    },
                                    child: Text('Detalhes'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
