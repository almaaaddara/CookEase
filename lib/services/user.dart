import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Read data user yang sedang login
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final userDoc = await _userCollection.doc(currentUser.uid).get();
      return userDoc.data() as Map<String, dynamic>?;
    }
    return null;
  }

  // Read data user berdasarkan ID
  Future<Map<String, dynamic>?> getUserById(String userId) async {
    try {
      final userDoc = await _userCollection.doc(userId).get();
      return userDoc.exists ? userDoc.data() as Map<String, dynamic> : null;
    } catch (e) {
      print("Error saat mengambil data user: $e");
      return null;
    }
  }

  // Update data user berdasarkan ID
  Future<void> updateUser(
      String userId, Map<String, dynamic> updatedData) async {
    try {
      await _userCollection.doc(userId).update(updatedData);
      print("User berhasil diperbarui.");
    } catch (e) {
      print("Error saat memperbarui data user: $e");
      throw e;
    }
  }

  // Delete data user berdasarkan ID
  Future<void> deleteUser(String userId) async {
    try {
      await _userCollection.doc(userId).delete();
      print("User berhasil dihapus.");
    } catch (e) {
      print("Error saat menghapus user: $e");
    }
  }

  // Read semua data pengguna
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final snapshot = await _userCollection.get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Error saat mengambil semua data user: $e");
      return [];
    }
  }
}
