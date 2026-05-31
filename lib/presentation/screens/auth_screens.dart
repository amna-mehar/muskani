import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../widgets/shop_widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, required this.onLogin});

  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Welcome back',
      subtitle: 'Login to continue shopping with ShopEase.',
      children: [
        const AppTextField(label: 'Email', icon: Icons.email_outlined),
        const SizedBox(height: 12),
        const AppTextField(label: 'Password', icon: Icons.lock_outline, obscure: true),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(onPressed: () {}, child: const Text('Forgot password?')),
        ),
        PrimaryButton(label: 'Login', icon: Icons.login, onPressed: onLogin),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.g_mobiledata),
          label: const Text('Continue with Google'),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('New to ShopEase?'),
            TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SignUpScreen(onCreateAccount: onLogin),
                ),
              ),
              child: const Text('Sign up'),
            ),
          ],
        ),
      ],
    );
  }
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key, required this.onCreateAccount});

  final VoidCallback onCreateAccount;

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Create account',
      subtitle: 'Start your simple ecommerce journey.',
      children: [
        const AppTextField(label: 'Full name', icon: Icons.person_outline),
        const SizedBox(height: 12),
        const AppTextField(label: 'Email', icon: Icons.email_outlined),
        const SizedBox(height: 12),
        const AppTextField(label: 'Password', icon: Icons.lock_outline, obscure: true),
        const SizedBox(height: 12),
        const AppTextField(
          label: 'Confirm password',
          icon: Icons.verified_user_outlined,
          obscure: true,
        ),
        const SizedBox(height: 20),
        PrimaryButton(
          label: 'Create Account',
          icon: Icons.person_add_alt,
          onPressed: onCreateAccount,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Already have an account?'),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Login'),
            ),
          ],
        ),
      ],
    );
  }
}

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.shopping_bag_rounded, color: AppColors.primary, size: 48),
                  const SizedBox(height: 24),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text(subtitle, style: const TextStyle(color: AppColors.muted)),
                  const SizedBox(height: 28),
                  ...children,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
