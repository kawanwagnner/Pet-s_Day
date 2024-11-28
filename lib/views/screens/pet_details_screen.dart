import 'package:flutter/material.dart';

class PetDetailsScreen extends StatefulWidget {
  final String petName;
  final List<String> imagePaths; // Lista de imagens
  final int age;
  final double weight;

  const PetDetailsScreen({
    super.key,
    required this.petName,
    required this.imagePaths, // Recebe várias imagens
    required this.age,
    required this.weight,
    required imagePath,
  });

  static List<Map<String, dynamic>> favoritePets = [];

  @override
  _PetDetailsScreenState createState() => _PetDetailsScreenState();
}

class _PetDetailsScreenState extends State<PetDetailsScreen> {
  late bool isFavorited;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    isFavorited = PetDetailsScreen.favoritePets
        .any((pet) => pet['name'] == widget.petName);
    _pageController = PageController(); // Controlador para o carrossel
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void toggleFavorite() {
    setState(() {
      isFavorited = !isFavorited;
    });

    if (isFavorited) {
      addPetToFavorites();
      showSnackBar("Pet favoritado com sucesso!");
    } else {
      removePetFromFavorites();
      showSnackBar("Pet removido dos favoritos.");
    }
  }

  void addPetToFavorites() {
    PetDetailsScreen.favoritePets.add({
      'name': widget.petName,
      'age': widget.age,
      'weight': widget.weight,
      'imagePaths': widget.imagePaths,
    });
    print("Pet ${widget.petName} adicionado aos favoritos!");
  }

  void removePetFromFavorites() {
    PetDetailsScreen.favoritePets
        .removeWhere((pet) => pet['name'] == widget.petName);
    print("Pet ${widget.petName} removido dos favoritos!");
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDE4E4),
      body: Stack(
        children: [
          // Carrossel de imagens
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 350,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.imagePaths.length,
                itemBuilder: (context, index) {
                  final imagePath = widget.imagePaths[index];
                  return Image.network(
                    imagePath,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 300),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          widget.petName,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Center(
                        child: Text(
                          "São Paulo, Brasil (7km)",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInfoBox("Macho", "Sexo", Colors.red),
                          _buildInfoBox(
                              "${widget.age} Anos", "Idade", Colors.orange),
                          _buildInfoBox(
                              "${widget.weight.toStringAsFixed(1)} kg",
                              "Peso",
                              Colors.purple),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Divider(),
                      ListTile(
                        leading: const CircleAvatar(
                          backgroundImage: AssetImage('assets/img/profile.png'),
                          radius: 30,
                        ),
                        title: const Text(
                          'Hana',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text('Lucky Owner'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.phone),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.message),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Aqui você encontrará mais detalhes sobre o pet. Descubra o que faz deste pet tão especial.",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 60, vertical: 15),
                            backgroundColor:
                                isFavorited ? Colors.redAccent : Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: toggleFavorite,
                          child: Text(
                            isFavorited ? "Favoritado" : "Favoritar",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String value, String label, Color color) {
    return Container(
      width: 90,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
