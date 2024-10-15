import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/banner_widget.dart';
import '../widgets/category_chips.dart';
import '../widgets/pet_card.dart';
import 'favorites_screen.dart'; // Certifique-se de importar o arquivo da tela de favoritos

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(
    viewportFraction: 0.75,
  );

  int _selectedIndex = 0; // Índice selecionado no BottomNavigationBar

  // Lista de URLs de imagens transparentes de cães e gatos
  final List<String> imageUrls = [
    'https://cdn.pixabay.com/photo/2017/04/23/07/35/isolated-2253166_1280.png', // Cão 1
    'https://cdn.pixabay.com/photo/2018/08/16/20/00/colli-3611293_1280.png', // Cão 2
    'https://cdn.pixabay.com/photo/2018/11/03/12/17/dog-3791920_1280.png', // Cão 3
    'https://cdn.pixabay.com/photo/2018/03/17/15/30/dog-3234285_1280.png', // Cão 4
    'https://cdn.pixabay.com/photo/2018/02/15/13/10/golden-retriever-3155242_960_720.png', // Cão 5
    'https://cdn.pixabay.com/photo/2018/08/16/20/01/rhodesian-ridgeback-3611294_1280.png', // Cão 6
    'https://cdn.pixabay.com/photo/2018/04/06/17/27/animal-3296309_1280.png', // Gato 1
    'https://cdn.pixabay.com/photo/2017/08/22/16/23/cat-2669554_1280.png', // Gato 2
    'https://cdn.pixabay.com/photo/2017/08/13/19/23/sofa-2638296_960_720.png', // Gato 3
    'https://cdn.pixabay.com/photo/2018/11/02/15/54/cat-3790477_960_720.png', // Gato 4
  ];

  // Lista de pets com informações dinâmicas
  final List<Map<String, dynamic>> pets = List.generate(
    10,
    (index) => {
      'petName': 'Pet ${index + 1}', // Nome do pet dinâmico
      'imagePath': '', // Caminho da imagem do pet
      'age': 2 + (index % 3), // Idade (exemplo de variação)
      'weight': 5.0 + (index % 3) * 2, // Peso (exemplo de variação)
    },
  );

  @override
  void initState() {
    super.initState();
    _assignImagesToPets();
  }

  // Atribuindo imagens transparentes para cada pet dinamicamente
  void _assignImagesToPets() {
    for (int i = 0; i < pets.length; i++) {
      pets[i]['imagePath'] = imageUrls[i];
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Método para navegação
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 2) {
      Navigator.pushNamed(
          context, '/favorites'); // Navega para a tela de Favoritos
    }
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
                      return _buildPetCard(
                        context,
                        pets[index]['petName'], // Nome do pet
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
        currentIndex: _selectedIndex, // Controle do índice selecionado
        onTap: _onItemTapped, // Definindo o método de navegação
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
  Widget _buildPetCard(BuildContext context, String petName, String imagePath,
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
