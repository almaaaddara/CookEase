import 'package:flutter/material.dart';
import 'package:mama_recipe/utils/color_theme.dart';

class Ingredients extends StatelessWidget {
  final List<TextEditingController> nameControllers;
  final List<TextEditingController> quantityControllers;
  final VoidCallback addIngredient;
  final Function(int index) onRemoveIngredient;

  const Ingredients({
    Key? key,
    required this.nameControllers,
    required this.quantityControllers,
    required this.addIngredient,
    required this.onRemoveIngredient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ingredients',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: nameControllers.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                key: ValueKey(index), // Gunakan index sebagai key
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: nameControllers[index],
                      decoration: InputDecoration(
                        labelText: 'Ingredient',
                        labelStyle: TextStyle(color: AppColor.primary),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: AppColor.primary)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an ingredient';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: quantityControllers[index],
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        labelStyle: TextStyle(color: AppColor.primary),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: AppColor.primary)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the quantity';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => onRemoveIngredient(index),
                  ),
                ],
              ),
            );
          },
        ),
        TextButton(
          onPressed: addIngredient,
          child: const Text(
            'Add Ingredient',
            style: TextStyle(color: AppColor.primary),
          ),
        ),
      ],
    );
  }
}
