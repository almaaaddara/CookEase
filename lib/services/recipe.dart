import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mama_recipe/models/food.dart';

class RecipeService {
  final db = FirebaseFirestore.instance.collection('recipes');

  Future<void> addRecipe(Recipe recipe) async {
    try {
      // Tambahkan dokumen baru dengan ID otomatis
      DocumentReference docRef = await db.add(recipe.toJson());

      // Perbarui dokumen dengan ID yang dihasilkan
      await docRef.update({'id': docRef.id});

      print('Recipe added successfully with ID: ${docRef.id}');
    } catch (e) {
      print('Failed to add recipe: $e');
      throw Exception('Failed to add recipe: $e');
    }
  }

  Future<List<Recipe>> getAllRecipes() async {
    try {
      // Ambil data resep dari Firestore
      QuerySnapshot snapshot = await db.get();

      // Map data ke list of Recipe
      List<Recipe> recipes = snapshot.docs.map((doc) {
        return Recipe.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();

      return recipes;
    } catch (e) {
      print("Error getting recipes: $e");
      return [];
    }
  }

  // READ: ambil data detail recipe
  Future<Recipe> getDetail(String id) async {
    try {
      // Ambil data resep dari Firestore
      DocumentSnapshot snapshot = await db.doc(id).get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;

        // Parsing data resep dengan factory method dariJson
        final recipe = Recipe.fromJson(snapshot.id, data);

        return recipe;
      } else {
        throw Exception('Recipe not found');
      }
    } catch (e) {
      throw Exception('Failed to fetch recipe: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getUserRecipes(String userId) async {
    try {
      final querySnapshot = await db.where('userId', isEqualTo: userId).get();
      return querySnapshot.docs.map((doc) {
        return doc.data();
      }).toList();
    } catch (e) {
      print('Failed to fetch recipes for user $userId: $e');
      return [];
    }
  }

  // Ambil data resep terbaru
  Future<List<Map<String, dynamic>>> getLatestRecipes({int limit = 10}) async {
    try {
      // Query Firestore berdasarkan created_at dengan urutan descending
      final querySnapshot =
          await db.orderBy('createdAt', descending: true).limit(limit).get();

      // Konversi data ke dalam List<Map<String, dynamic>>
      final recipes = querySnapshot.docs.map((doc) {
        return {"id": doc.id, ...doc.data() as Map<String, dynamic>};
      }).toList();

      return recipes;
    } catch (e) {
      throw Exception('Failed to get latest recipes: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getRecipesCategory(String category) async {
    try {
      // Check if category is "All", and fetch all recipes
      Query query;
      if (category == 'All') {
        query = db; // Fetch all recipes
      } else {
        query = db.where('category', isEqualTo: category); // Filter by category
      }

      QuerySnapshot snapshot = await query.get();
      // Map the documents to a list of maps
      List<Map<String, dynamic>> recipes = snapshot.docs
          .map((doc) => {...doc.data() as Map<String, dynamic>, 'id': doc.id})
          .toList();

      return recipes;
    } catch (e) {
      print('Error fetching recipes: $e');
      throw Exception('Failed to fetch recipes: $e');
    }
  }

  // // Tambah Ingredients
  // Future<void> addIngredients(Map<String, dynamic> body, String recipeID) {
  //   return db.doc(recipeID).collection('ingredients').add(body);
  // }

  // // Tambah Step
  // Future<void> addSteps(Map<String, dynamic> body, String recipeID) {
  //   return db.doc(recipeID).collection('steps').add(body);
  // }
}
