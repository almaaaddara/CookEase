import 'ingredients.dart';
import 'step.dart';

class Recipe {
  String? id;
  String title;
  String description;
  int cookTime;
  int servings;
  String? image;
  String category;
  // int favorites;
  String userId;
  String username;
  // String profileUser;
  String createdAt;
  List<Ingredient> ingredients;
  List<foodStep> steps;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.cookTime,
    required this.servings,
    this.image,
    required this.category,
    // required this.favorites,
    required this.userId,
    required this.username,
    // required this.profileUser,
    required this.createdAt,
    required this.ingredients,
    required this.steps,
  });

  factory Recipe.fromJson(String id, Map<String, dynamic> json) {
    return Recipe(
      id: id,
      title: json['title'] as String,
      description: json['description'] as String,
      cookTime: json['cookTime'] as int,
      servings: json['servings'] as int,
      image: json['image'] as String?,
      category: json['category'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      createdAt: json['createdAt'] as String,
      ingredients: (json['ingredients'] as List)
          .map((ingredient) => Ingredient.fromJson(ingredient))
          .toList(),
      steps: (json['steps'] as List)
          .map((step) => foodStep.fromJson(step))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'cookTime': cookTime,
      'servings': servings,
      'image': image,
      'category': category,
      'userId': userId,
      'username': username,
      'createdAt': createdAt,
      // 'favorites': favorites,
      'ingredients':
          ingredients.map((ingredient) => ingredient.toJson()).toList(),
      'steps': steps.map((step) => step.toJson()).toList(),
    };
  }
}

// final List<Food> foods = [
//   Food(
//     title: "Nasi Goreng",
//     description: "Nasi goreng sederhana dengan bumbu kecap.",
//     cookTime: 15,
//     servings: 2,
//     image: "assets/Nasi-Goreng.jpg",
//     favorites: 10,
//     category: "Dinner",
//     author: user[0],
//     ingredients: [
//       Ingredient(name: "Nasi Putih", quantity: "2 piring"),
//       Ingredient(name: "Bawang Putih", quantity: "2 siung, cincang halus"),
//       Ingredient(name: "Telur", quantity: "2 butir"),
//       Ingredient(name: "Kecap Manis", quantity: "2 sdm"),
//       Ingredient(name: "Garam", quantity: "1/2 sdt"),
//       Ingredient(name: "Kaldu Ayam", quantity: "1/2 sdt"),
//       Ingredient(name: "Minyak Goreng", quantity: "2 sdm"),
//     ],
//     steps: [
//       Step(
//           stepNumber: 1,
//           description: "Panaskan minyak dan tumis bawang putih hingga harum."),
//       Step(
//           stepNumber: 2,
//           description: "Masukkan telur dan orak-arik hingga matang."),
//       Step(
//           stepNumber: 3,
//           description:
//               "Tambahkan nasi putih, kecap manis, kaldu ayam dan garam. Aduk rata."),
//       Step(
//           stepNumber: 4,
//           description: "Masak hingga semua bumbu meresap. Angkat dan sajikan."),
//     ],
//   ),
//   Food(
//     title: "Tempe Goreng",
//     description: "Tempe goreng renyah dengan bumbu sederhana.",
//     cookTime: 10,
//     servings: 3,
//     image: "assets/Tempe-Goreng.jpg",
//     favorites: 8,
//     category: "Lunch",
//     author: user[0],
//     ingredients: [
//       Ingredient(name: "Tempe", quantity: "1 papan, iris tipis"),
//       Ingredient(name: "Bawang Putih", quantity: "2 siung, haluskan"),
//       Ingredient(name: "Ketumbar", quantity: "1/2 sdt"),
//       Ingredient(name: "Garam", quantity: "1/2 sdt"),
//       Ingredient(name: "Air", quantity: "100 ml"),
//       Ingredient(name: "Minyak Goreng", quantity: "secukupnya"),
//     ],
//     steps: [
//       Step(
//           stepNumber: 1,
//           description: "Campurkan bawang putih, ketumbar, garam, dan air."),
//       Step(
//           stepNumber: 2,
//           description: "Iris tempe menjadi beberapa bagian tipis"),
//       Step(
//           stepNumber: 3,
//           description: "Rendam tempe dalam campuran bumbu selama 3 menit."),
//       Step(
//           stepNumber: 4,
//           description:
//               "Panaskan minyak, lalu goreng tempe hingga kecokelatan."),
//       Step(
//           stepNumber: 5,
//           description: "Angkat dan tiriskan. Sajikan selagi hangat."),
//     ],
//   ),
//   Food(
//     title: "Sayur Asem",
//     description: "Sayur asem dengan berbagai sayuran segar.",
//     cookTime: 25,
//     servings: 4,
//     image: "assets/Sayur-Asem.jpg",
//     favorites: 12,
//     category: "Breakfast",
//     author: user[1],
//     ingredients: [
//       Ingredient(name: "Jagung Manis", quantity: "1 buah"),
//       Ingredient(name: "Kacang Panjang", quantity: "10 batang"),
//       Ingredient(name: "Melinjo", quantity: "1 genggam"),
//       Ingredient(name: "Asam Jawa", quantity: "2 sdm"),
//       Ingredient(name: "Bawang Merah", quantity: "5 butir"),
//       Ingredient(name: "Cabai Merah", quantity: "3 buah"),
//       Ingredient(name: "Gula Merah", quantity: "1 sdm"),
//       Ingredient(name: "Garam", quantity: "1 sdt"),
//     ],
//     steps: [
//       Step(
//           stepNumber: 1,
//           description:
//               "Rebus air dan masukkan bawang merah serta cabai merah yang sudah dihaluskan."),
//       Step(
//           stepNumber: 2,
//           description: "Masukkan irisan jagung, melinjo, dan kacang panjang."),
//       Step(
//           stepNumber: 3,
//           description:
//               "Tambahkan asam jawa, gula merah, dan garam. Masak hingga sayuran empuk."),
//       Step(
//           stepNumber: 4,
//           description: "Angkat dan sajikan sayur asem dalam mangkuk."),
//     ],
//   ),
//   Food(
//     title: "Gado-Gado",
//     description: "Salad khas Indonesia dengan bumbu kacang.",
//     cookTime: 20,
//     servings: 2,
//     image: "assets/Gado-Gado.jpg",
//     favorites: 9,
//     category: "Breakfast",
//     author: user[1],
//     ingredients: [
//       Ingredient(name: "Tahu", quantity: "2 potong"),
//       Ingredient(name: "Tempe", quantity: "1 potong"),
//       Ingredient(name: "Telur Rebus", quantity: "2 butir"),
//       Ingredient(name: "Kentang Rebus", quantity: "2 buah"),
//       Ingredient(name: "Kangkung", quantity: "1 ikat"),
//       Ingredient(name: "Bumbu Kacang", quantity: "100g"),
//       Ingredient(name: "Kecap Manis", quantity: "2 sdm"),
//     ],
//     steps: [
//       Step(
//           stepNumber: 1,
//           description:
//               "Goreng tahu dan tempe serta rebus kangkung, kemudian tiriskan"),
//       Step(
//           stepNumber: 2,
//           description: "Campurkan semua bahan dan tata di piring."),
//       Step(
//           stepNumber: 3,
//           description: "Campurkan bumbu kacang dengan kecap manis."),
//       Step(
//           stepNumber: 3,
//           description: "Siramkan bumbu kacang di atas sayuran dan bahan lain."),
//       Step(
//           stepNumber: 4,
//           description: "Sajikan gado-gado dengan kerupuk sebagai pelengkap."),
//     ],
//   ),
//   Food(
//     title: "Mie Kuah",
//     description: "Mie kuah instan lezat dimakan saat cuaca hujan",
//     cookTime: 10,
//     servings: 1,
//     image: "assets/Mie-Kuah.jpg",
//     favorites: 15,
//     category: "Dinner",
//     author: user[2],
//     ingredients: [
//       Ingredient(name: "Mie Instan", quantity: "1 bungkus"),
//       Ingredient(name: "Air", quantity: "400 ml"),
//       Ingredient(name: "Telur", quantity: "1 butir"),
//       Ingredient(name: "Sayuran Hijau", quantity: "secukupnya"),
//       Ingredient(name: "Cabe Rawit", quantity: "2 buah, iris"),
//     ],
//     steps: [
//       Step(
//         stepNumber: 1,
//         description: "Rebus air hingga mendidih, lalu masukkan mie instan.",
//       ),
//       Step(
//         stepNumber: 2,
//         description: "Tambahkan telur dan sayuran ke dalam rebusan mie.",
//       ),
//       Step(
//         stepNumber: 3,
//         description: "Masukkan bumbu mie instan dan cabe rawit, aduk rata.",
//       ),
//       Step(
//         stepNumber: 4,
//         description: "Masak hingga mie dan telur matang. Sajikan panas.",
//       ),
//     ],
//   ),
//   Food(
//     title: "Nasi Goreng",
//     description: "Nasi goreng sederhana dengan bumbu kecap.",
//     cookTime: 15,
//     servings: 2,
//     image: "assets/Nasi-Goreng.jpg",
//     favorites: 10,
//     category: "Dinner",
//     author: user[0],
//     ingredients: [
//       Ingredient(name: "Nasi Putih", quantity: "2 piring"),
//       Ingredient(name: "Bawang Putih", quantity: "2 siung, cincang halus"),
//       Ingredient(name: "Telur", quantity: "2 butir"),
//       Ingredient(name: "Kecap Manis", quantity: "2 sdm"),
//       Ingredient(name: "Garam", quantity: "1/2 sdt"),
//       Ingredient(name: "Kaldu Ayam", quantity: "1/2 sdt"),
//       Ingredient(name: "Minyak Goreng", quantity: "2 sdm"),
//     ],
//     steps: [
//       Step(
//           stepNumber: 1,
//           description: "Panaskan minyak dan tumis bawang putih hingga harum."),
//       Step(
//           stepNumber: 2,
//           description: "Masukkan telur dan orak-arik hingga matang."),
//       Step(
//           stepNumber: 3,
//           description:
//               "Tambahkan nasi putih, kecap manis, kaldu ayam dan garam. Aduk rata."),
//       Step(
//           stepNumber: 4,
//           description: "Masak hingga semua bumbu meresap. Angkat dan sajikan."),
//     ],
//   ),
//   Food(
//     title: "Tempe Goreng",
//     description: "Tempe goreng renyah dengan bumbu sederhana.",
//     cookTime: 10,
//     servings: 3,
//     image: "assets/Tempe-Goreng.jpg",
//     favorites: 8,
//     category: "Lunch",
//     author: user[0],
//     ingredients: [
//       Ingredient(name: "Tempe", quantity: "1 papan, iris tipis"),
//       Ingredient(name: "Bawang Putih", quantity: "2 siung, haluskan"),
//       Ingredient(name: "Ketumbar", quantity: "1/2 sdt"),
//       Ingredient(name: "Garam", quantity: "1/2 sdt"),
//       Ingredient(name: "Air", quantity: "100 ml"),
//       Ingredient(name: "Minyak Goreng", quantity: "secukupnya"),
//     ],
//     steps: [
//       Step(
//           stepNumber: 1,
//           description: "Campurkan bawang putih, ketumbar, garam, dan air."),
//       Step(
//           stepNumber: 2,
//           description: "Iris tempe menjadi beberapa bagian tipis"),
//       Step(
//           stepNumber: 3,
//           description: "Rendam tempe dalam campuran bumbu selama 3 menit."),
//       Step(
//           stepNumber: 4,
//           description:
//               "Panaskan minyak, lalu goreng tempe hingga kecokelatan."),
//       Step(
//           stepNumber: 5,
//           description: "Angkat dan tiriskan. Sajikan selagi hangat."),
//     ],
//   ),
// ];
