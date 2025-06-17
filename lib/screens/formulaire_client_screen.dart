import 'package:flutter/material.dart';

class FormulaireClientScreen extends StatelessWidget {
  const FormulaireClientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulaire client"),
        backgroundColor: const Color(0xFFF15E00),
      ),
      body: const Center(
        child: Text("Ici le formulaire pour trouver un service"),
      ),
    );
  }
}
