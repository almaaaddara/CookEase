import 'package:flutter/material.dart';

class Ingredients extends StatelessWidget {
  final List<Map<String, String>> ingredients;
  final VoidCallback addIngredient;
  final Function(int index, String value) onNameChanged;
  final Function(int index, String value) onQuantityChanged;

  const Ingredients({
    Key? key,
    required this.ingredients,
    required this.addIngredient,
    required this.onNameChanged,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ingredients',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: ingredients.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Ingredient',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        onNameChanged(index, value);
                      },
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
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        onQuantityChanged(index, value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the quantity';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        TextButton(
          onPressed: addIngredient,
          child: const Text('Add Ingredient'),
        ),
      ],
    );
  }
}
