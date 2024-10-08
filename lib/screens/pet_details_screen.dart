import 'package:flutter/material.dart';

class PetDetailsScreen extends StatelessWidget {
  final String petName;
  final String imagePath;

  const PetDetailsScreen(
      {super.key, required this.petName, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    // Verificando e transformando o nome da imagem com base no valor recebido
    String displayedImagePath = imagePath;
    if (imagePath.contains('dog2.png')) {
      displayedImagePath = 'assets/img/dog.png';
    } else if (imagePath.contains('cat2.png')) {
      displayedImagePath = 'assets/img/cat.png';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFDE4E4), // Cor de fundo similar à imagem
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Card superior com a imagem e informações principais
                  Container(
                    margin: const EdgeInsets.only(top: 60),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Card branco
                        Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.only(
                              top: 300), // Offset para a imagem
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
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
                            children: [
                              Text(
                                petName, // Nome do pet vindo do argumento
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                "Stadtmittel, Essen (5km)",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 15),
                              // Informações de sexo, idade e peso
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildInfoBox("Male", "Sex", Colors.red),
                                  _buildInfoBox(
                                      "2 Years", "Age", Colors.orange),
                                  _buildInfoBox(
                                      "7 kg", "Weight", Colors.purple),
                                ],
                              ),
                              const SizedBox(height: 15),
                              const Divider(),
                              ListTile(
                                leading: const CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/img/profile.png'),
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
                                "I found Lucky while she was being assaulted last November. After a month of therapy, she is now very active and waiting for a new home. Lucky is a loving and friendly pet looking for someone who can provide her with a lot of love and attention.",
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 15),
                              // Botão "Continuar"
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 60, vertical: 15),
                                  backgroundColor: Colors.redAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () {},
                                child: const Text(
                                  "Continue",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Imagem do pet
                        Positioned(
                          top:
                              -40, // Aumentando o valor para descer mais a imagem no card
                          left: 0,
                          right: 0,
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                displayedImagePath, // Caminho da imagem atualizado com a verificação
                                width: 350, // Aumentando a largura da imagem
                                height: 350, // Aumentando a altura da imagem
                                fit: BoxFit.cover,
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
          ),
          // Botão de voltar
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.pop(context); // Volta para a tela anterior
              },
            ),
          ),
        ],
      ),
    );
  }

  // Método para criar um box de informações com estilo
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
