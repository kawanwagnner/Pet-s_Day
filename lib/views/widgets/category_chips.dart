import 'package:flutter/material.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Chip(
            label: Text(
              'Gatos',
              style: TextStyle(color: Colors.black),
            ),
          ),
          Chip(
            label: Text(
              'Cachorros',
              style: TextStyle(color: Colors.black),
            ),
          ),
          Chip(
            label: Text(
              'Pássaros',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
