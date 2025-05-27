import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/detalhes_screen.dart';
import 'screens/lista_dos_sonhos_screen.dart';

void main() {
  runApp(GuiaDeViagensApp());
}

class GuiaDeViagensApp extends StatelessWidget {
  const GuiaDeViagensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  title: 'Guia de Viagens',
  theme: ThemeData(
    scaffoldBackgroundColor: Color(0xFFBBF2F2), // Fundo geral
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(0xFF03A64A), // cor primária
      primary: Color(0xFF03A64A),
      secondary: Color(0xFF027333),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF027333),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    cardColor: Color(0xFF5D878C),
    textTheme: TextTheme(
      titleLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
    useMaterial3: true,
  ),
  home: HomeScreen(),
  routes: {
    '/detalhes': (context) => DetalhesScreen(),
    '/lista': (context) => ListaDosSonhosScreen(),
  },
);

  }
}
