import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeController {
  final PageController pageController = PageController(
    viewportFraction: 0.75,
  );

  int selectedIndex = 0;
  List<Map<String, dynamic>> pets = [];

  Future<void> fetchPets() async {
    try {
      final response = await http.get(
          Uri.parse('https://pet-adopt-dq32j.ondigitalocean.app/pet/pets'));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        final data = jsonResponse['pets'] as List<dynamic>;

        pets = data
            .map((item) => {
                  'petName': item['name'],
                  'imagePath':
                      item['images'] != null && item['images'].isNotEmpty
                          ? item['images'][0]
                          : null,
                  'age': item['age'],
                  'weight': item['weight'],
                  'available': item['available']
                })
            .toList();
      } else {
        throw Exception('Falha ao carregar os dados dos pets');
      }
    } catch (e) {
      print('Erro ao carregar pets: $e');
    }
  }

  void onItemTapped(BuildContext context, int index) {
    selectedIndex = index;
    if (index == 1) {
      Navigator.pushNamed(context, '/profile');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/favorites');
    } else if (index == 3) {
      Navigator.pushNamed(context, '/login');
    }
  }

  void dispose() {
    pageController.dispose();
  }
}
