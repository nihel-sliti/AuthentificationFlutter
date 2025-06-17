import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2), // coins très légers
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 6,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(2),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontFamily: 'Helvetica', // "Helvetica Neue" n’est pas dispo par défaut
                  fontWeight: FontWeight.normal, // correspond mieux à la capture
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
