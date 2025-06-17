import 'package:flutter/material.dart';
class Header extends StatelessWidget {
  final String imagePath;
  final String title;

  const Header({
    super.key,
    required this.imagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Image.asset(
            imagePath,
            height: 80,
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 32,
              fontFamily: 'Helvetica Neue',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
