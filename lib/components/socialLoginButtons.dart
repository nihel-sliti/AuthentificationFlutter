import 'package:flutter/material.dart';

class SocialLoginButtons extends StatelessWidget {
  final String googleIconPath;
  final String facebookIconPath;

  const SocialLoginButtons({
    super.key,
    required this.googleIconPath,
    required this.facebookIconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
  children: [
    const SizedBox(height: 30),
    Row(
      children: [
        const Expanded(
          child: Divider(
            thickness: 1,
            color: Colors.grey,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "Ou connectez-vous avec",
            style: TextStyle(color: Colors.black),
          ),
        ),
        const Expanded(
          child: Divider(
            thickness: 1,
            color: Colors.grey,
          ),
        ),
      ],
    ),
    const SizedBox(height: 20),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            print("Connexion Google");
            // TODO: Implémenter Google Sign-In
          },
          child: Image.asset(
            'assets/images/GoogleIcon.png',
            width: 40,
            height: 40,
          ),
        ),
        const SizedBox(width: 24),
        GestureDetector(
          onTap: () {
            print("Connexion Facebook");
            // TODO: Implémenter Facebook Sign-In
          },
          child: Image.asset(
            'assets/images/FacebookIcon.png',
            width: 40,
            height: 40,
          ),
        ),
      ],
    ),
  ],
);

  }
}
