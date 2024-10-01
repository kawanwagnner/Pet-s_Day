import 'package:flutter/material.dart';

class PetCard extends StatelessWidget {
  final String petName;
  final String imagePath; // Novo parâmetro para o caminho da imagem

  PetCard(
      {required this.petName,
      required this.imagePath}); // Inclua imagePath no construtor

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Passa os argumentos ao navegar para a PetDetailsScreen
        Navigator.pushNamed(
          context,
          '/petDetails',
          arguments: {
            'petName': petName, // Nome do pet
            'imagePath': imagePath, // Caminho da imagem do pet
          },
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Exibe a imagem fornecida pelo imagePath
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  imagePath,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    petName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('2 Years, 7kg'), // Informações adicionais do pet
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
