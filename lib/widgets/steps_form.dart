import 'package:flutter/material.dart';
import 'package:mama_recipe/utils/color_theme.dart';

class Steps extends StatelessWidget {
  final List<TextEditingController> stepControllers;
  final VoidCallback addStep;
  final Function(int index) onRemoveStep;

  const Steps({
    Key? key,
    required this.stepControllers,
    required this.addStep,
    required this.onRemoveStep,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cooking Steps',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: stepControllers.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Text(
                    'Step ${index + 1}:',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: stepControllers[index],
                      decoration: const InputDecoration(
                        labelText: 'Step Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3, // Membatasi baris input menjadi maksimal 2
                      keyboardType: TextInputType
                          .multiline, // Memungkinkan input multiline
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the step description';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => onRemoveStep(index),
                  ),
                ],
              ),
            );
          },
        ),
        TextButton(
          onPressed: addStep,
          child: const Text(
            'Add Step',
            style: TextStyle(color: AppColor.primary),
          ),
        ),
      ],
    );
  }
}
