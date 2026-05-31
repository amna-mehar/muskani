class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.description,
    required this.iconName,
    required this.colorValue,
  });

  final int id;
  final String name;
  final String category;
  final double price;
  final double rating;
  final String description;
  final String iconName;
  final int colorValue;
}
