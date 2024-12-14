class User {
  final String userId;
  final String username;
  final String email;
  final String profileImage;

  User({
    required this.userId,
    required this.username,
    required this.email,
    required this.profileImage,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'profileImage': profileImage,
    };
  }
}

final List<User> user = [
  User(
    userId: "1",
    username: "Mariane Joan",
    email: "mariane@example.com",
    profileImage: "assets/women_profile.jpeg",
  ),
  User(
    userId: "2",
    username: "Michael Jhon",
    email: "jhon@example.com",
    profileImage: "assets/male_profile.jpg",
  ),
  User(
    userId: "3",
    username: "Sarah Lyann",
    email: "lyn@example.com",
    profileImage: "assets/women_profile.jpeg",
  ),
];
