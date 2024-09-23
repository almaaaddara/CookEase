import 'package:flutter/material.dart';
import 'package:mama_recipe/models/food.dart';

class LastAdded extends StatelessWidget {
  const LastAdded({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Last Added",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {}, // Fungsi "View all" kosong
              child: const Text("View all"),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 260, // Tinggi total widget grid
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 1.3,
              mainAxisSpacing: 10,
            ),
            itemCount: foods.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {}, // Tidak diarahkan ke halaman lain
                child: Container(
                  width: 200, // Lebar tiap item
                  margin: const EdgeInsets.only(right: 10),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage(
                                    foods[index].image ?? 'assets/default.jpg'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            foods[index].title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.restaurant,
                                size: 18,
                                color: Colors.grey,
                              ),
                              Text(
                                "${foods[index].servings} Portion",
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
                                Icons.timer,
                                size: 18,
                                color: Colors.grey,
                              ),
                              Text(
                                "${foods[index].cookTime} Min",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        top: 1,
                        right: 1,
                        child: IconButton(
                          onPressed: () {},
                          iconSize: 20,
                          icon: const Icon(Icons.favorite),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
