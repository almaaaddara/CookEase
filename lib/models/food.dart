class Food {
  String title;
  String description;
  int prepTime;
  int cookTime;
  int servings;
  String? image;
  int favorites;

  Food({
    required this.title,
    required this.description,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    this.image,
    required this.favorites,
  });
}

final List<Food> foods = [
  Food(
    title: "Spicy Ramen Noodles",
    description:
        "A delicious and spicy noodle recipe with ramen and various spices.",
    prepTime: 10,
    cookTime: 15,
    servings: 2,
    image: "assets/Chicken-Ramen.png",
    favorites: 5
  ),
  Food(
    title: "Beef Steak",
    description: "Juicy grilled beef steak with seasoning.",
    prepTime: 20,
    cookTime: 25,
    servings: 4,
    image: "assets/Steak-1.jpg",
    favorites: 3
  ),
  Food(
    title: "Butter Chicken",
    description: "Creamy butter chicken with rich spices and flavors.",
    prepTime: 15,
    cookTime: 18,
    servings: 3,
    image: "assets/Butter-Chicken.jpg",
    favorites: 2
  ),
  Food(
    title: "French Toast",
    description: "Classic French toast made with eggs, milk, and sugar.",
    prepTime: 5,
    cookTime: 16,
    servings: 2,
    image: "assets/French-Toast.jpg",
    favorites: 7
  ),
  Food(
    title: "Dumplings",
    description: "Steamed or fried dumplings filled with savory ingredients.",
    prepTime: 30,
    cookTime: 30,
    servings: 6,
    image: "assets/Dumplings.jpg",
    favorites: 6
  ),
  Food(
    title: "Mexican Pizza",
    description: "Mexican-style pizza with a variety of toppings and cheese.",
    prepTime: 20,
    cookTime: 25,
    servings: 4,
    image: "assets/Taco-Bell-Mexican-Pizza.jpg",
    favorites: 5
  ),
];
