import 'package:flutter/foundation.dart';

import '../../data/repositories/shop_repository.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/order_info.dart';
import '../../domain/entities/product.dart';

class ShopController extends ChangeNotifier {
  ShopController({this.repository = const ShopRepository()});

  final ShopRepository repository;
  final Set<int> _wishlist = {};
  final Map<int, CartItem> _cart = {};

  List<Product> get products => repository.getProducts();
  List<String> get categories => repository.getCategories();
  List<OrderInfo> get orders => repository.getOrders();
  Set<int> get wishlist => _wishlist;
  Map<int, CartItem> get cart => _cart;
  List<CartItem> get cartItems => _cart.values.toList();

  double get subtotal => cartItems.fold(
        0,
        (sum, item) => sum + item.product.price * item.quantity,
      );

  double get deliveryFee => subtotal > 0 ? 4.99 : 0;
  double get discount => subtotal > 80 ? 10 : 0;
  double get total => subtotal + deliveryFee - discount;

  bool isWishlisted(Product product) => _wishlist.contains(product.id);

  void toggleWishlist(Product product) {
    _wishlist.contains(product.id)
        ? _wishlist.remove(product.id)
        : _wishlist.add(product.id);
    notifyListeners();
  }

  void addToCart(Product product, [int quantity = 1]) {
    final current = _cart[product.id]?.quantity ?? 0;
    _cart[product.id] = CartItem(product: product, quantity: current + quantity);
    notifyListeners();
  }

  void updateCart(Product product, int quantity) {
    if (quantity <= 0) {
      _cart.remove(product.id);
    } else {
      _cart[product.id] = CartItem(product: product, quantity: quantity);
    }
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}
