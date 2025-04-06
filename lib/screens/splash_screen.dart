import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 150,
              height: 150,
              // إذا لم يكن لديك شعار، يمكنك استخدام أيقونة بدلاً من ذلك
              errorBuilder:
                  (ctx, error, _) => const Icon(
                    Icons.shopping_bag,
                    size: 150,
                    color: Colors.blue,
                  ),
            ),
            const SizedBox(height: 20),
            const Text(
              'متجرنا الإلكتروني',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
