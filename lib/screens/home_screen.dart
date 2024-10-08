import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/banner_widget.dart';
import '../widgets/category_chips.dart';
import '../widgets/pet_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(
    viewportFraction: 0.75,
  );

  // Lista de pets com informações dinâmicas
  final List<Map<String, dynamic>> pets = List.generate(
    10,
    (index) => {
      'petName': 'Dog ${index + 1}', // Nome do cachorro dinâmico
      'imagePath': 'assets/img/dog2.png', // Caminho da imagem do cachorro
      'age': 2 + (index % 3), // Idade (exemplo de variação)
      'weight': 5.0 + (index % 3) * 2, // Peso (exemplo de variação)
    },
  );

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.mapPin, // Ícone do FontAwesome
                              color: Colors.grey,
                              size: 20,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Localização',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            "São Paulo, Brasil",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const FaIcon(FontAwesomeIcons.searchengin,
                              size: 25),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const FaIcon(FontAwesomeIcons.bell, size: 25),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const BannerWidget(),
                const SizedBox(height: 30),
                const Text(
                  'Categorias',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CategoryChips(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pets próximos a mim',
                      style: TextStyle(
                        fontSize: 18,
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
                // Atualizando para exibir os 10 cards dinâmicos
                SizedBox(
                  height: 250,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: pets.length, // Usando o tamanho da lista de pets
                    itemBuilder: (context, index) {
                      return _buildPetRow(
                        context,
                        pets[index]['petName'], // Nome do cachorro
                        pets[index]['imagePath'], // Caminho da imagem
                        pets[index]['age'], // Idade
                        pets[index]['weight'], // Peso
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.house), // Ícone home
            label: '',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.user), // Ícone perfil (favoritos)
            label: '',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.heart), // Ícone coração (favoritos)
            label: '',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.gears), // Ícone de configurações
            label: '',
          ),
        ],
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  // Passando os parâmetros dinâmicos para o PetCard
  Widget _buildPetRow(BuildContext context, String petName, String imagePath,
      int age, double weight) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Transform.scale(
        scale: 1.0,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          child: PetCard(
            petName: petName,
            imagePath: imagePath,
            age: age,
            weight: weight,
            onTap: () {
              // Navegação para a tela de detalhes do pet
              Navigator.pushNamed(
                context,
                '/petDetails',
                arguments: {
                  'petName': petName,
                  'imagePath': imagePath,
                  'age': age,
                  'weight': weight,
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sobre Nós',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Somos uma comunidade apaixonada por pets e buscamos sempre ajudar os animais a encontrarem um novo lar.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Nos siga nas redes sociais para ficar por dentro das novidades e conhecer mais sobre nossos projetos!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.facebook,
                    color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.instagram,
                    color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.xTwitter,
                    color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
