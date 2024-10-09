import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'screens/pet_details_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => WelcomeScreen());
    case '/home':
      return MaterialPageRoute(builder: (context) => HomeScreen());
    case '/petDetails':
      // Verifica se os argumentos são passados corre tamente
      final args = settings.arguments as Map<String, dynamic>?;

      if (args != null) {
        return MaterialPageRoute(
          builder: (context) => PetDetailsScreen(
            petName: args['petName'],
            imagePath: args['imagePath'],
          ),
        );
      } else {
        return _errorRoute();
      }
    default:
      return MaterialPageRoute(builder: (context) => const HomeScreen());
  }
}

// Função para exibir uma tela de erro caso os argumentos não sejam fornecidos corretamente
Route<dynamic> _errorRoute() {
  return MaterialPageRoute(
    builder: (context) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: const Center(
          child: Text('Error: Missing arguments for PetDetailsScreen!')),
    ),
  );
}
