import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/price_formatter.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/product.dart';
import '../controllers/shop_controller.dart';
import '../widgets/shop_widgets.dart';

class ShopShell extends StatefulWidget {
  const ShopShell({super.key, required this.controller});

  final ShopController controller;

  @override
  State<ShopShell> createState() => _ShopShellState();
}

class _ShopShellState extends State<ShopShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final screens = [
          HomeScreen(controller: widget.controller),
          WishlistScreen(controller: widget.controller),
          CartScreen(controller: widget.controller),
          OrdersScreen(controller: widget.controller),
          ProfileScreen(onOrders: () => setState(() => index = 3)),
        ];

        return Scaffold(
          body: screens[index],
          bottomNavigationBar: NavigationBar(
            selectedIndex: index,
            onDestinationSelected: (value) => setState(() => index = value),
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              const NavigationDestination(
                icon: Icon(Icons.favorite_border),
                selectedIcon: Icon(Icons.favorite),
                label: 'Wishlist',
              ),
              NavigationDestination(
                icon: Badge.count(
                  count: widget.controller.cart.length,
                  isLabelVisible: widget.controller.cart.isNotEmpty,
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
                selectedIcon: const Icon(Icons.shopping_cart),
                label: 'Cart',
              ),
              const NavigationDestination(
                icon: Icon(Icons.receipt_long_outlined),
                selectedIcon: Icon(Icons.receipt_long),
                label: 'Orders',
              ),
              const NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.controller});

  final ShopController controller;

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'ShopEase',
      actions: [
        IconButton(
          tooltip: 'Notifications',
          onPressed: () {},
          icon: const Icon(Icons.notifications_none),
        ),
      ],
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          const AppTextField(label: 'Search products', icon: Icons.search),
          const SizedBox(height: 18),
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, index) {
                final category = controller.categories[index];
                return CategoryPill(
                  label: category,
                  selected: index == 0,
                  onTap: () => openListing(context, category),
                );
              },
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Student Sale',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Get 25% off selected essentials this week.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.local_offer, color: Colors.white, size: 42),
                ),
              ],
            ),
          ),
          SectionHeader(title: 'Featured Products', onViewAll: () => openListing(context, 'All')),
          shopGrid(context, controller.products.take(4).toList()),
          SectionHeader(title: 'Popular Products', onViewAll: () => openListing(context, 'All')),
          shopGrid(context, controller.products.skip(4).toList()),
        ],
      ),
    );
  }

  Widget shopGrid(BuildContext context, List<Product> products) {
    return ProductGrid(
      products: products,
      isWishlisted: controller.isWishlisted,
      onWishlist: controller.toggleWishlist,
      onAddToCart: controller.addToCart,
      onOpenProduct: (product) => openDetails(context, product),
    );
  }

  void openListing(BuildContext context, String category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductListingScreen(
          controller: controller,
          initialCategory: category,
        ),
      ),
    );
  }

  void openDetails(BuildContext context, Product product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductDetailsScreen(controller: controller, product: product),
      ),
    );
  }
}

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({
    super.key,
    required this.controller,
    required this.initialCategory,
  });

  final ShopController controller;
  final String initialCategory;

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  late String selectedCategory = widget.initialCategory;
  bool lowToHigh = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final visible = widget.controller.products
            .where((p) => selectedCategory == 'All' || p.category == selectedCategory)
            .toList()
          ..sort((a, b) => lowToHigh ? a.price.compareTo(b.price) : b.price.compareTo(a.price));

        return AppPage(
          title: 'Products',
          showBack: true,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() {
                        final current = widget.controller.categories.indexOf(selectedCategory);
                        selectedCategory = widget.controller.categories[(current + 1) % widget.controller.categories.length];
                      }),
                      icon: const Icon(Icons.filter_list),
                      label: Text(selectedCategory),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() => lowToHigh = !lowToHigh),
                      icon: const Icon(Icons.sort),
                      label: Text(lowToHigh ? 'Low to High' : 'High to Low'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ProductGrid(
                products: visible,
                isWishlisted: widget.controller.isWishlisted,
                onWishlist: widget.controller.toggleWishlist,
                onAddToCart: widget.controller.addToCart,
                onOpenProduct: (product) => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ProductDetailsScreen(
                      controller: widget.controller,
                      product: product,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({
    super.key,
    required this.controller,
    required this.product,
  });

  final ShopController controller;
  final Product product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        return AppPage(
          title: 'Product Details',
          showBack: true,
          actions: [
            IconButton(
              tooltip: 'Wishlist',
              onPressed: () => widget.controller.toggleWishlist(product),
              icon: Icon(
                widget.controller.isWishlisted(product) ? Icons.favorite : Icons.favorite_border,
                color: widget.controller.isWishlisted(product) ? Colors.red : null,
              ),
            ),
          ],
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ProductImage(product: product, height: 260),
              const SizedBox(height: 20),
              Text(product.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    formatPrice(product.price),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.star, color: AppColors.warning, size: 20),
                  Text(' ${product.rating} (124 reviews)'),
                ],
              ),
              const SizedBox(height: 18),
              const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(product.description, style: const TextStyle(color: AppColors.muted, height: 1.5)),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Quantity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  QuantityControl(
                    quantity: quantity,
                    onMinus: () => setState(() {
                      if (quantity > 1) quantity--;
                    }),
                    onPlus: () => setState(() => quantity++),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Add to Cart',
                icon: Icons.shopping_cart_outlined,
                onPressed: () {
                  widget.controller.addToCart(product, quantity);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product.name} added to cart')),
                  );
                },
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {
                  widget.controller.addToCart(product, quantity);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CheckoutScreen(
                        controller: widget.controller,
                        items: [CartItem(product: product, quantity: quantity)],
                        clearCartOnSuccess: false,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.flash_on),
                label: const Text('Buy Now'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key, required this.controller});

  final ShopController controller;

  @override
  Widget build(BuildContext context) {
    final saved = controller.products.where(controller.isWishlisted).toList();
    return AppPage(
      title: 'Wishlist',
      child: saved.isEmpty
          ? const EmptyState(
              icon: Icons.favorite_border,
              title: 'No saved products',
              text: 'Tap the heart icon on products you want to keep.',
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ProductGrid(
                  products: saved,
                  isWishlisted: controller.isWishlisted,
                  onWishlist: controller.toggleWishlist,
                  onAddToCart: controller.addToCart,
                  onOpenProduct: (product) => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProductDetailsScreen(controller: controller, product: product),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key, required this.controller});

  final ShopController controller;

  @override
  Widget build(BuildContext context) {
    final items = controller.cartItems;
    return AppPage(
      title: 'Cart',
      child: items.isEmpty
          ? const EmptyState(
              icon: Icons.shopping_cart_outlined,
              title: 'Your cart is empty',
              text: 'Add products to your cart and they will appear here.',
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...items.map(
                  (item) => CartItemCard(
                    item: item,
                    onUpdate: (quantity) => controller.updateCart(item.product, quantity),
                  ),
                ),
                const SizedBox(height: 12),
                OrderSummary(
                  subtotal: controller.subtotal,
                  delivery: controller.deliveryFee,
                  discount: controller.discount,
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  label: 'Checkout',
                  icon: Icons.lock_outline,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CheckoutScreen(
                        controller: controller,
                        items: items,
                        clearCartOnSuccess: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({
    super.key,
    required this.controller,
    required this.items,
    required this.clearCartOnSuccess,
  });

  final ShopController controller;
  final List<CartItem> items;
  final bool clearCartOnSuccess;

  @override
  Widget build(BuildContext context) {
    final subtotal = items.fold<double>(0, (sum, item) => sum + item.product.price * item.quantity);
    const delivery = 4.99;
    final discount = subtotal > 80 ? 10.0 : 0.0;

    return AppPage(
      title: 'Checkout',
      showBack: true,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const InfoPanel(
            title: 'Delivery Address',
            icon: Icons.location_on_outlined,
            child: Text('123 Campus Road, Student Hostel, City Center', style: TextStyle(color: AppColors.muted)),
          ),
          const SizedBox(height: 12),
          const InfoPanel(
            title: 'Payment Method',
            icon: Icons.credit_card,
            child: Text('Cash on Delivery - UI only', style: TextStyle(color: AppColors.muted)),
          ),
          const SizedBox(height: 12),
          InfoPanel(
            title: 'Order Items',
            icon: Icons.shopping_bag_outlined,
            child: Column(
              children: items
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(child: Text(item.product.name)),
                          Text('x${item.quantity}'),
                          const SizedBox(width: 12),
                          Text(formatPrice(item.product.price * item.quantity)),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          OrderSummary(subtotal: subtotal, delivery: delivery, discount: discount),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'Place Order',
            icon: Icons.check_circle_outline,
            onPressed: () {
              if (clearCartOnSuccess) controller.clearCart();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const OrderSuccessScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 70,
                backgroundColor: Color(0xFFDCFCE7),
                child: Icon(Icons.check_circle, color: AppColors.success, size: 86),
              ),
              const SizedBox(height: 28),
              const Text('Order Placed!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              const Text(
                'Your order #SE-2026-001 has been placed successfully.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.muted, height: 1.5),
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                label: 'Continue Shopping',
                icon: Icons.storefront,
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key, required this.controller});

  final ShopController controller;

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'My Orders',
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: controller.orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, index) => OrderCard(order: controller.orders[index]),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.onOrders});

  final VoidCallback onOrders;

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Profile',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: cardDecoration(),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, color: Colors.white, size: 38),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Demo Student', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                      SizedBox(height: 4),
                      Text('student@shopease.com', style: TextStyle(color: AppColors.muted)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ProfileTile(
            icon: Icons.edit_outlined,
            title: 'Edit Profile',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const EditProfileScreen()),
            ),
          ),
          ProfileTile(icon: Icons.receipt_long_outlined, title: 'My Orders', onTap: onOrders),
          ProfileTile(icon: Icons.location_on_outlined, title: 'Shipping Address', onTap: () {}),
          ProfileTile(icon: Icons.credit_card, title: 'Payment Methods', onTap: () {}),
          ProfileTile(
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
          ProfileTile(icon: Icons.logout, title: 'Logout', onTap: () {}),
        ],
      ),
    );
  }
}

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Edit Profile',
      showBack: true,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const AppTextField(label: 'Full name', icon: Icons.person_outline),
          const SizedBox(height: 12),
          const AppTextField(label: 'Email', icon: Icons.email_outlined),
          const SizedBox(height: 12),
          const AppTextField(label: 'Phone number', icon: Icons.phone_outlined),
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'Save',
            icon: Icons.save_outlined,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notifications = true;
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Settings',
      showBack: true,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            value: notifications,
            onChanged: (value) => setState(() => notifications = value),
            title: const Text('Notifications'),
            secondary: const Icon(Icons.notifications_none),
          ),
          SwitchListTile(
            value: darkMode,
            onChanged: (value) => setState(() => darkMode = value),
            title: const Text('Dark mode UI'),
            secondary: const Icon(Icons.dark_mode_outlined),
          ),
          const ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            subtitle: Text('English'),
          ),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About app'),
            subtitle: Text('ShopEase FYP UI prototype v1.0'),
          ),
        ],
      ),
    );
  }
}
