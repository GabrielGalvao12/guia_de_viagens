import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://wft-geo-db.p.rapidapi.com/v1/geo/cities';
  static const String _apiKey = '57277d9330msh438e62e76ea0b6bp1b99cdjsnaf536a7ecec4';

  static Future<List<dynamic>> fetchCities({String country = 'BR'}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?countryIds=$country&limit=10&sort=-population'),
      headers: {
        'X-RapidAPI-Key': _apiKey,
        'X-RapidAPI-Host': 'wft-geo-db.p.rapidapi.com',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> cidades = data['data'];

        // Filtra somente "Greater Rio de Janeiro" (ou variações)
      final cidadesFiltradas = cidades.where((cidade) {
      final nome = cidade['city'].toString().toLowerCase();
      return !nome.contains('greater rio');
}).toList();

return cidadesFiltradas;
    } else {
      throw Exception('Erro ao carregar cidades');
    }
  }
}
