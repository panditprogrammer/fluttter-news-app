import 'package:flutter/material.dart';
import 'package:inn/constants/colors.dart';

class CategoryCard extends StatelessWidget {
  final String category;
  final String? selectedCategory;

  CategoryCard({required this.category, required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: category == selectedCategory ? cRed : cGray,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Center(
        child: Text(
          category,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: category == selectedCategory ? cWhite : cBlack,
          ),
        ),
      ),
    );
  }
}
