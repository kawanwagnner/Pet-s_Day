import 'package:flutter/material.dart';

class PetCard extends StatelessWidget {
  final String petName;
  final String imagePath;
  final int age;
  final double weight;
  final VoidCallback onTap;

  const PetCard({
    super.key,
    required this.petName,
    required this.imagePath,
    required this.age,
    required this.weight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // Área superior com informações do pet
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    petName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$age anos, ${weight}kg', // Informações dinâmicas do pet
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),

              // Imagem do pet ocupando o espaço disponível
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  imagePath,
                  width: 100, // Faz a imagem ocupar toda a largura
                  fit: BoxFit.cover, // Para ajustar a imagem corretamente
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
