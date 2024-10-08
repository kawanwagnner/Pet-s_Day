import 'package:flutter/material.dart';

class CategoryChips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Chip(label: Text('Gatos')),
          Chip(label: Text('Cachorros')),
          Chip(label: Text('Pássaros')),
        ],
      ),
    );
  }
}
