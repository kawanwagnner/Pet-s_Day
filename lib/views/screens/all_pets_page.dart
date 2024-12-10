import 'package:flutter/material.dart';
import 'package:pet_adopt/controllers/home_controller.dart';

class AllPetsPage extends StatefulWidget {
  const AllPetsPage({super.key});

  @override
  _AllPetsPageState createState() => _AllPetsPageState();
}

class _AllPetsPageState extends State<AllPetsPage> {
  final HomeController _controller = HomeController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    await _controller.fetchPets();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos os Pets'),
        backgroundColor: Colors.redAccent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : (_controller.pets.isEmpty
              ? const Center(
                  child: Text(
                    "Nenhum pet disponível no momento",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _controller.pets.length,
                  itemBuilder: (context, index) {
                    final pet = _controller.pets[index];
                    return _buildPetListItem(
                      context,
                      pet['petName'] ?? 'Sem Nome',
                      pet['imagePath'] ?? '',
                      pet['age'] ?? 0,
                      (pet['weight'] ?? 0.0).toDouble(),
                    );
                  },
                )),
    );
  }

  Widget _buildPetListItem(BuildContext context, String petName,
      String imagePath, int age, double weight) {
    final String image = imagePath.isNotEmpty
        ? imagePath
        : 'https://github.com/kawanwagnner/Pet-s_Day/blob/main/assets/img/default_image.png?raw=true';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(image),
        ),
        title: Text(
          petName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Idade: $age anos | Peso: ${weight.toStringAsFixed(1)} kg",
          style: const TextStyle(color: Colors.grey),
        ),
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
    );
  }
}
