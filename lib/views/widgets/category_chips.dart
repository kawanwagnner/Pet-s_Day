import 'package:flutter/material.dart';

class CategoryChips extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategoryChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: categories.map((category) {
          final isSelected = selectedCategory == category;
          return GestureDetector(
            onTap: () => onCategorySelected(category),
            child: Chip(
              label: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
              backgroundColor: isSelected
                  ? Colors.grey // Estilo para o selecionado
                  : Colors.white, // Estilo para não selecionado
            ),
          );
        }).toList(),
      ),
    );
  }
}
