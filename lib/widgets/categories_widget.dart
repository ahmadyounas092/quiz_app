import 'package:flutter/material.dart';
import 'package:quiz_api_app/components/categories_container.dart';
import 'package:quiz_api_app/utils/list_files_data.dart';

class CategoriesWidget extends StatefulWidget {
  final void Function(String)? onCategorySelected;
  const CategoriesWidget({super.key, required this.onCategorySelected});

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        itemCount: categoriesNames.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selected = index;
              });
              widget.onCategorySelected?.call(categoriesNames[index]);
            },
            child: CategoriesContainer(
              text: categoriesNames[index],
              selectCategory: selected == index,
            ),
          );
        },
      ),
    );
  }
}
