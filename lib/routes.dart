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
      return MaterialPageRoute(builder: (context) => PetDetailsScreen());
    default:
      return MaterialPageRoute(builder: (context) => HomeScreen());
  }
}
