import '../../domain/entities/order_info.dart';
import '../../domain/entities/product.dart';

class ShopRepository {
  const ShopRepository();

  List<String> getCategories() {
    return const ['All', 'Electronics', 'Fashion', 'Bags', 'Home', 'Lifestyle'];
  }

  List<Product> getProducts() {
    return const [
      Product(
        id: 1,
        name: 'Wireless Headphones',
        category: 'Electronics',
        price: 59.99,
        rating: 4.8,
        iconName: 'headphones',
        colorValue: 0xFFDBEAFE,
        description:
            'Comfortable wireless headphones with clear sound and long battery life.',
      ),
      Product(
        id: 2,
        name: 'Smart Watch',
        category: 'Electronics',
        price: 89.99,
        rating: 4.7,
        iconName: 'watch',
        colorValue: 0xFFE0F2FE,
        description:
            'Track fitness, notifications, and daily activity with a sleek watch.',
      ),
      Product(
        id: 3,
        name: 'Classic Sneakers',
        category: 'Fashion',
        price: 44.50,
        rating: 4.6,
        iconName: 'sneakers',
        colorValue: 0xFFDCFCE7,
        description:
            'Everyday sneakers designed for comfort, casual style, and durability.',
      ),
      Product(
        id: 4,
        name: 'Travel Backpack',
        category: 'Bags',
        price: 39.99,
        rating: 4.5,
        iconName: 'backpack',
        colorValue: 0xFFFEF3C7,
        description:
            'Lightweight backpack with organized pockets for college or travel.',
      ),
      Product(
        id: 5,
        name: 'Cotton T-Shirt',
        category: 'Fashion',
        price: 18.99,
        rating: 4.4,
        iconName: 'shirt',
        colorValue: 0xFFFCE7F3,
        description:
            'Soft cotton t-shirt with a clean fit for daily wear and layering.',
      ),
      Product(
        id: 6,
        name: 'Desk Lamp',
        category: 'Home',
        price: 24.99,
        rating: 4.3,
        iconName: 'lamp',
        colorValue: 0xFFEDE9FE,
        description:
            'Adjustable desk lamp with warm lighting for studying and work.',
      ),
      Product(
        id: 7,
        name: 'Water Bottle',
        category: 'Lifestyle',
        price: 15.99,
        rating: 4.5,
        iconName: 'bottle',
        colorValue: 0xFFCCFBF1,
        description:
            'Reusable bottle that keeps drinks fresh through busy college days.',
      ),
      Product(
        id: 8,
        name: 'Mini Speaker',
        category: 'Electronics',
        price: 34.99,
        rating: 4.6,
        iconName: 'speaker',
        colorValue: 0xFFFFEDD5,
        description:
            'Portable speaker with rich sound for rooms, outings, and study breaks.',
      ),
    ];
  }

  List<OrderInfo> getOrders() {
    return const [
      OrderInfo(id: 'SE-2026-001', total: 94.98, status: 'Delivered'),
      OrderInfo(id: 'SE-2026-002', total: 44.50, status: 'Shipped'),
      OrderInfo(id: 'SE-2026-003', total: 24.99, status: 'Pending'),
    ];
  }
}
