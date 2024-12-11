// home_controller.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeController {
  final PageController pageController = PageController(
    viewportFraction: 0.75,
  );

  int selectedIndex = 0;
  List<Map<String, dynamic>> pets = [];

  // URL base da API
  static const String baseUrl =
      'https://pet-adopt-dq32j.ondigitalocean.app/pet/pets';

  // URL da imagem padrão
  static const String defaultImageUrl =
      'https://github.com/kawanwagnner/Pet-s_Day/blob/main/assets/img/default_image.png?raw=true';

  // Variáveis para paginação
  int currentPage = 1;
  final int limit = 3;

  // Função para validar URLs
  bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && uri.hasAuthority;
    } catch (e) {
      return false;
    }
  }

  // Método atualizado para buscar pets com parâmetros dinâmicos
  Future<void> fetchPets({int? page, int? limit}) async {
    final int fetchPage = page ?? currentPage;
    final int fetchLimit = limit ?? this.limit;

    // Construir a URI com parâmetros dinâmicos
    final Uri uri = Uri.parse(baseUrl).replace(
      queryParameters: {
        'page': fetchPage.toString(),
        'limit': fetchLimit.toString(),
      },
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        final data = jsonResponse['pets'] as List<dynamic>;

        List<Map<String, dynamic>> fetchedPets = data.map((item) {
          final images = item['images'];
          String? firstImage;

          // Verificar se 'images' é uma lista ou uma string
          if (images != null) {
            if (images is List && images.isNotEmpty) {
              firstImage = images[0]; // Atribui a primeira imagem da lista
            } else if (images is String && images.isNotEmpty) {
              firstImage = images; // Se for uma string, usa a URL diretamente
            }
          }

          // Se não houver imagem válida ou URL inválido, atribui a imagem padrão
          if (firstImage == null ||
              firstImage.isEmpty ||
              !isValidUrl(firstImage)) {
            firstImage = defaultImageUrl;
          }

          return {
            'petName': item['name'],
            'imagePath': firstImage,
            'age': item['age'],
            'weight': item['weight'],
            'available': item['available']
          };
        }).toList();

        // Se estiver buscando uma página diferente, adicione os pets
        if (fetchPage > 1) {
          pets.addAll(fetchedPets);
        } else {
          pets = fetchedPets;
        }

        // Atualiza a página atual
        currentPage = fetchPage;
      } else if (response.statusCode >= 400 && response.statusCode < 600) {
        // Para qualquer erro de cliente (4xx) ou servidor (5xx), lança uma exceção
        print(
            'Erro ${response.statusCode}: Acesso proibido ou recurso não encontrado.');
        throw Exception(
            'Erro ${response.statusCode}: Acesso proibido ou recurso não encontrado. Imagem padrão será exibida.');
      } else {
        throw Exception(
            'Falha ao carregar os dados dos pets. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar pets: $e');
      // Caso ocorra algum erro, definir a imagem padrão
      if (fetchPage == 1) {
        pets = [
          {
            'petName': 'Erro ao carregar pets',
            'imagePath': defaultImageUrl,
            'age': 'Desconhecida',
            'weight': 'Desconhecido',
            'available': false
          }
        ];
      }
      // Você pode optar por não modificar pets se for uma página adicional
    }
  }

  void onItemTapped(BuildContext context, int index) {
    selectedIndex = index;
    if (index == 1) {
      Navigator.pushNamed(context, '/profile');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/favorites');
    } else if (index == 3) {
      Navigator.pushNamed(context, '/createPet');
    }
  }

  void dispose() {
    pageController.dispose();
  }
}
