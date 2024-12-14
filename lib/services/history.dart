import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Memperbarui atau menambah history
  Future<void> updateHistory(String recipeId) async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        final historyRef = db
            .collection('users')
            .doc(user.uid)
            .collection('history')
            .doc(recipeId);

        // Cek apakah history sudah ada untuk resep ini
        final docSnapshot = await historyRef.get();

        if (docSnapshot.exists) {
          // Jika sudah ada, update hanya field 'viewedAt'
          await historyRef.update({
            'viewedAt': Timestamp.now(),
          });
          print('History updated for recipe $recipeId');
        } else {
          // Jika belum ada, buat entri baru
          await historyRef.set({
            'recipeId': recipeId,
            'viewedAt': Timestamp.now(),
          });
          print('History added for recipe $recipeId');
        }
      }
    } catch (e) {
      print("Error updating or adding history: $e");
    }
  }

  // Mengambil history resep berdasarkan userId
  Stream<QuerySnapshot> getHistory() {
    final user = auth.currentUser;
    if (user != null) {
      return db
          .collection('users')
          .doc(user.uid)
          .collection('history')
          .orderBy('viewedAt', descending: true) // Menampilkan history terbaru
          .snapshots();
    } else {
      throw Exception('User is not logged in');
    }
  }
}
