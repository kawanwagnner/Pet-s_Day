import 'package:flutter/material.dart';
import '../widgets/banner_widget.dart';
import '../widgets/category_chips.dart';
import '../widgets/pet_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDE4E4),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Localização',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '+55 (11) - SP, Brasil',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                const BannerWidget(),
                const SizedBox(height: 20),

                CategoryChips(),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pets próximos a mim',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Ver todos',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Carrossel com PageView
                SizedBox(
                  height: 250,
                  child: PageView(
                    pageSnapping: true,
                    children: [
                      _buildPetRow(context, 'Lucky', 'assets/img/dog2.png',
                          'Lily', 'assets/img/cat2.png'),
                      _buildPetRow(context, 'Max', 'assets/img/dog2.png',
                          'Bella', 'assets/img/cat2.png'),
                      // Adicione mais linhas conforme necessário
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _buildPetRow(BuildContext context, String petName1, String imagePath1,
      String petName2, String imagePath2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.scale(
          scale: 1.1, // Ajusta a escala do card
          child: SizedBox(
            width: MediaQuery.of(context).size.width *
                0.45, // Ajusta a largura do card
            child: PetCard(
              petName: petName1,
              imagePath: imagePath1,
            ),
          ),
        ),
        const SizedBox(width: 10), // Espaçamento entre os cartões
        Transform.scale(
          scale: 1.1, // Ajusta a escala do card
          child: SizedBox(
            width: MediaQuery.of(context).size.width *
                0.45, // Ajusta a largura do card
            child: PetCard(
              petName: petName2,
              imagePath: imagePath2,
            ),
          ),
        ),
      ],
    );
  }
}
