import 'package:flutter/material.dart';

class CategoryChips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Chip(label: Text('Cats')),
          Chip(label: Text('Dogs')),
          Chip(label: Text('Fish')),
          Chip(label: Text('Birds')),
        ],
      ),
    );
  }
}
