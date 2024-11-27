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

        pets = data.map((item) {
          final images = item['images'];
          print(images);
          print("=============================================");
          String? firstImage;

          // Verificar se 'images' é uma lista ou uma string
          if (images != null) {
            if (images is List && images.isNotEmpty) {
              firstImage = images[0]; // Atribui a primeira imagem da lista
            } else if (images is String && images.isNotEmpty) {
              firstImage = images; // Se for uma string, usa a URL diretamente
            }
          }

          return {
            'petName': item['name'],
            'imagePath': firstImage ?? '',
            'age': item['age'],
            'weight': item['weight'],
            'available': item['available']
          };
        }).toList();
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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController controller = HomeController();

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    await controller.fetchPets();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pets Disponíveis'),
      ),
      body: controller.pets.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : PageView.builder(
              controller: controller.pageController,
              itemCount: controller.pets.length,
              itemBuilder: (context, index) {
                final pet = controller.pets[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (pet['imagePath'] != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            pet['imagePath'],
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.pets,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        pet['petName'] ?? 'Sem nome',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Idade: ${pet['age'] ?? 'Desconhecida'} anos',
                      ),
                      Text(
                        'Peso: ${pet['weight'] ?? 'Desconhecido'} kg',
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: controller.selectedIndex,
        onTap: (index) => controller.onItemTapped(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Login',
          ),
        ],
      ),
    );
  }
}
