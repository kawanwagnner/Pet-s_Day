import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pet_adopt/services/google_vision_api.dart';
import 'package:pet_adopt/controllers/home_controller.dart';
import 'package:pet_adopt/views/screens/all_pets_page.dart';
import '../widgets/banner_widget.dart';
import '../widgets/category_chips.dart';
import '../widgets/pet_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController _controller = HomeController();
  final GoogleVisionApi _googleVisionApi =
      GoogleVisionApi("YOUR_GOOGLE_VISION_API_KEY");

  bool _isLoading = true;
  String _selectedCategory = "Todos";

  bool _isFetchingMore = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadPets();

    _controller.pageController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _controller.pageController.removeListener(_scrollListener);
    _controller.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_controller.pageController.position.atEdge) {
      bool isEnd = _controller.pageController.position.pixels != 0;
      if (isEnd) {
        _loadMorePets();
      }
    }
  }

  Future<void> _loadPets(
      {int? page, int? limit, bool isRefresh = false}) async {
    if (isRefresh) {
      _controller.currentPage = 1;
      _hasMore = true;
      _controller.pets.clear();
    }

    if (!_hasMore) return;

    setState(() {
      _isLoading = !isRefresh && _controller.pets.isEmpty;
      _isFetchingMore = !isRefresh && _controller.pets.isNotEmpty;
    });

    await _controller.fetchPets(page: page, limit: limit);

    for (var pet in _controller.pets) {
      if (pet['type'] == null) {
        final petType = await _determineType(pet['imagePath']);
        pet['type'] = petType;
      }
    }

    setState(() {
      _isLoading = false;
      _isFetchingMore = false;
      if (_controller.pets.length <
          (_controller.currentPage * _controller.limit)) {
        _hasMore = false;
      }
    });
  }

  Future<String> _determineType(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) return "Outro";

    try {
      final result = await _googleVisionApi.classifyImage(imagePath);
      if (result.toLowerCase().contains("cachorro")) return "Cachorros";
      if (result.toLowerCase().contains("gato")) return "Gatos";
      return "Outro";
    } catch (e) {
      return "Outro";
    }
  }

  List<Map<String, dynamic>> _getFilteredPets() {
    if (_selectedCategory == "Todos") {
      return _controller.pets;
    }

    return _controller.pets.where((pet) {
      return pet['type'] != null && pet['type'] == _selectedCategory;
    }).toList();
  }

  Future<void> _loadMorePets() async {
    if (_hasMore && !_isFetchingMore) {
      setState(() {
        _isFetchingMore = true;
      });

      await _loadPets(
          page: _controller.currentPage + 1, limit: _controller.limit);

      setState(() {
        _isFetchingMore = false;
      });
    }
  }

  Future<void> _refreshPets() async {
    await _loadPets(isRefresh: true);
  }

  Widget _buildPetCard(BuildContext context, String petName, String imagePath,
      int age, double weight) {
    final String image =
        imagePath.isNotEmpty ? imagePath : HomeController.defaultImageUrl;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Transform.scale(
        scale: 1.0,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          child: PetCard(
            petName: petName,
            imagePath: image,
            age: age,
            weight: weight,
            onTap: () {
              Navigator.pushNamed(
                context,
                '/petDetails',
                arguments: {
                  'petName': petName,
                  'imagePath': image,
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

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(child: CircularProgressIndicator()),
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
                icon:
                    const FaIcon(FontAwesomeIcons.twitter, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredPets = _getFilteredPets();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshPets,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                                FontAwesomeIcons.mapPin,
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  CategoryChips(
                    categories: const ["Todos", "Gatos", "Cachorros"],
                    selectedCategory: _selectedCategory,
                    onCategorySelected: (category) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Pets próximos a mim',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AllPetsPage()),
                          );
                        },
                        child: const Text(
                          'Ver todos',
                          style: TextStyle(
                              color: Color.fromARGB(255, 252, 59, 59),
                              fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : (filteredPets.isEmpty
                          ? const Center(
                              child: Text(
                                "Sem pets disponíveis",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                SizedBox(
                                  height: 250,
                                  child: PageView.builder(
                                    controller: _controller.pageController,
                                    itemCount: filteredPets.length +
                                        (_hasMore ? 1 : 0),
                                    itemBuilder: (context, index) {
                                      if (index == filteredPets.length) {
                                        return _isFetchingMore
                                            ? _buildLoadingIndicator()
                                            : const SizedBox.shrink();
                                      }

                                      final pet = filteredPets[index];
                                      return _buildPetCard(
                                        context,
                                        pet['petName'] ?? 'Sem Nome',
                                        pet['imagePath'] ?? '',
                                        pet['age'] ?? 0,
                                        (pet['weight'] ?? 0.0).toDouble(),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _buildFooter(),
                              ],
                            )),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _controller.selectedIndex,
        onTap: (index) => setState(() {
          _controller.onItemTapped(context, index);
        }),
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.house,
                color: Color.fromARGB(255, 255, 4, 67)),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.user, color: Colors.green),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.star, color: Colors.yellow),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.heartCirclePlus,
                color: Color(0xFF272626)),
            label: '',
          ),
        ],
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
