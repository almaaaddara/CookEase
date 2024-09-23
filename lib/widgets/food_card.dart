import 'package:flutter/material.dart';
import 'package:mama_recipe/models/food.dart';

class FoodCard extends StatelessWidget {
  final Food food;
  const FoodCard({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: AssetImage(food.image ?? 'assets/default.jpg'),
                    fit: BoxFit.cover, // Menggunakan BoxFit.cover
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                food.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.flash_on, // Menggunakan Icon bawaan Flutter
                    size: 18,
                    color: Colors.grey,
                  ),
                  Text(
                    "${food.servings} Servings",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const Text(
                    " · ",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const Icon(
                    Icons.access_time, // Menggunakan Icon jam dari Flutter
                    size: 18,
                    color: Colors.grey,
                  ),
                  Text(
                    "${food.cookTime} Min",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
