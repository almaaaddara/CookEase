import 'package:flutter/material.dart';
import 'package:mama_recipe/screen/detail_recipe.dart';
import 'package:mama_recipe/utils/color_theme.dart';
import 'package:mama_recipe/services/history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final HistoryService historyService = HistoryService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your History'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: historyService.getHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No history available'));
          }

          final historyList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: historyList.length,
            itemBuilder: (context, index) {
              final historyItem = historyList[index];
              final recipeId = historyItem['recipeId'];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('recipes')
                    .doc(recipeId)
                    .get(),
                builder: (context, recipeSnapshot) {
                  if (recipeSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const SizedBox();
                  }

                  if (recipeSnapshot.hasError || !recipeSnapshot.hasData) {
                    return const SizedBox();
                  }

                  final recipeData =
                      recipeSnapshot.data!.data() as Map<String, dynamic>;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RecipeDetailPage(recipeId: recipeId),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Gambar resep
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(recipeData['image'] ??
                                      'assets/default.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Detail resep
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    recipeData['title'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  Row(
                                    children: [
                                      // CircleAvatar(
                                      //   radius: 13,
                                      //   backgroundImage: NetworkImage(
                                      //       recipeData['author']
                                      //               ['profileImage'] ??
                                      //           'assets/default_avatar.jpg'),
                                      // ),
                                      // const SizedBox(width: 10),
                                      Text(
                                        recipeData['username'],
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColor.textSecondary),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 7),
                                  Row(
                                    children: [
                                      const Icon(Icons.restaurant,
                                          size: 14, color: Colors.black),
                                      Text(
                                        " ${recipeData['servings']} Portion",
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColor.textSecondary),
                                      ),
                                      const SizedBox(width: 10),
                                      const Icon(Icons.timer,
                                          size: 14, color: Colors.black),
                                      Text(
                                        " ${recipeData['cook_time']} Min",
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColor.textSecondary),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
