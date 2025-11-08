import 'package:flutter/material.dart';

class CategoryTabsWidget extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategoryTabsWidget({super.key, required this.categories, required this.selectedCategory, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        height: 35,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            bool isSelected = selectedCategory == cat;
            return GestureDetector(
              onTap: () => onCategorySelected(cat),
              child: Padding(
                padding: const EdgeInsets.only(right: 24),
                child: Text(
                  cat,
                  style: TextStyle(fontSize: 16, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Theme.of(context).primaryColor : const Color(0xFF44444E)),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}