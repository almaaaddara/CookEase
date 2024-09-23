import 'package:flutter/material.dart';

class Steps extends StatelessWidget {
  final List<String> steps;
  final Function() addStep;
  final Function(int index, String value) onStepChanged;

  const Steps({
    Key? key,
    required this.steps,
    required this.addStep,
    required this.onStepChanged,
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
          itemCount: steps.length,
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
                      decoration: const InputDecoration(
                        labelText: 'Step Description',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => onStepChanged(index, value),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the step description';
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
          onPressed: addStep,
          child: const Text('Add Step'),
        ),
      ],
    );
  }
}
