import 'package:flutter/material.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          // Fundo principal do banner
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          // Pata 1 - canto superior esquerdo com rotação
          Positioned(
            top: 10,
            left: -10,
            child: Transform.rotate(
              angle: 0, // Rotaciona para um lado (em radianos)
              child: Image.asset(
                'assets/img/paw.png',
                height: 80,
                width: 80,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
          // Pata 2 - parte inferior com rotação
          Positioned(
            bottom: -15,
            left: 140,
            child: Transform.rotate(
              angle: -1.6, // Rotaciona para outro lado
              child: Image.asset(
                'assets/img/paw.png',
                height: 70,
                width: 70,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
          // Pata 3 - canto superior direito com rotação
          Positioned(
            top: -10,
            right: -10,
            child: Transform.rotate(
              angle: -3.9, // Rotação sutil
              child: Image.asset(
                'assets/img/paw.png',
                height: 70,
                width: 70,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
          // Adiciona a imagem do gato
          Positioned(
            bottom: -30,
            right: -10,
            child: Image.asset(
              'assets/img/cat.png', // Caminho ajustado para a imagem do gato
              height: 135,
              fit: BoxFit.cover,
            ),
          ),
          // Conteúdo do banner (texto e botão)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Comunidade Amantes de Pets',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Fazer parte'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
