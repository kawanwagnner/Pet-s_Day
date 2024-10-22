import 'package:flutter/material.dart';

class PetDetailsScreen extends StatefulWidget {
  final String petName;
  final String imagePath;
  final int age;
  final double weight;

  const PetDetailsScreen({
    super.key,
    required this.petName,
    required this.imagePath,
    required this.age,
    required this.weight,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PetDetailsScreenState createState() => _PetDetailsScreenState();
}

class _PetDetailsScreenState extends State<PetDetailsScreen> {
  bool isFavorited = false; // Variável que controla se o pet está favoritado

  // Função para alternar o estado de favorito
  void toggleFavorite() {
    setState(() {
      isFavorited = !isFavorited;
    });

    // Salvar ou remover o pet da lista de favoritos
    if (isFavorited) {
      // Salva o pet na lista de favoritos
      addPetToFavorites();
      showSnackBar("Pet favoritado com sucesso!");
    } else {
      // Remove o pet da lista de favoritos
      removePetFromFavorites();
      showSnackBar("Pet removido dos favoritos.");
    }
  }

  // Função para adicionar pet aos favoritos (essa função pode ser implementada com algum gerenciador de estado)
  void addPetToFavorites() {
    // Aqui, você pode implementar um método que adiciona o pet a uma lista de favoritos
    // Por exemplo, você pode usar o Provider, Riverpod ou Bloc para gerenciar o estado global.
    // Por enquanto, vamos fazer um print apenas para simulação.
    // ignore: avoid_print
    print("Pet ${widget.petName} adicionado aos favoritos!");
  }

  // Função para remover pet dos favoritos
  void removePetFromFavorites() {
    // ignore: avoid_print
    print("Pet ${widget.petName} removido dos favoritos!");
  }

  // Função para exibir o SnackBar com a mensagem de sucesso ou erro
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
    String displayedImagePath = widget.imagePath;
    if (widget.imagePath.contains('dog2.png')) {
      displayedImagePath = 'assets/img/dog.png';
    } else if (widget.imagePath.contains('cat2.png')) {
      displayedImagePath = 'assets/img/cat.png';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFDE4E4),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 350,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(displayedImagePath),
                  fit: BoxFit.cover,
                ),
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
                        "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      // Botão "Favoritar"
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
