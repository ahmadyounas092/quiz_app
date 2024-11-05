import 'package:flutter/material.dart';

class CategoriesContainer extends StatelessWidget {
  final bool selectCategory;
  final String text;

  const CategoriesContainer({
    super.key,
    required this.text,
    required this.selectCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(right: 20.0),
      decoration: BoxDecoration(
          color: selectCategory
              ? const Color.fromARGB(255, 164, 228, 69)
              : Colors.white,
          borderRadius: BorderRadius.circular(50)),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              color: selectCategory
                  ? Colors.white
                  : Color.fromARGB(255, 37, 11, 90),
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
