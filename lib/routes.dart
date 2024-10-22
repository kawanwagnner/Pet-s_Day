import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'screens/pet_details_screen.dart';
import 'screens/favorites_screen.dart'; // Adicione a importação da tela de favoritos

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => const WelcomeScreen());
    case '/home':
      return MaterialPageRoute(builder: (context) => const HomeScreen());
    case '/petDetails':
      // Verifica se os argumentos são passados corretamente
      final args = settings.arguments as Map<String, dynamic>?;

      // Verifique se os argumentos não são nulos e se todos os campos esperados estão presentes
      if (args != null &&
          args.containsKey('petName') &&
          args.containsKey('imagePath') &&
          args.containsKey('age') &&
          args.containsKey('weight')) {
        return MaterialPageRoute(
          builder: (context) => PetDetailsScreen(
            petName: args['petName'],
            imagePath: args['imagePath'],
            age: args['age'], // Passa a idade correta
            weight: args['weight'], // Passa o peso correto
          ),
        );
      } else {
        return _errorRoute();
      }
    case '/favorites': // Nova rota para a tela de favoritos
      return MaterialPageRoute(builder: (context) => const FavoritesScreen());
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
