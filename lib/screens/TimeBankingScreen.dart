import 'package:flutter/material.dart';
import 'formulaire_client_screen.dart'; // crée ce fichier si pas encore fait

class TimeBankingScreen extends StatefulWidget {
  const TimeBankingScreen({super.key});

  @override
  State<TimeBankingScreen> createState() => _TimeBankingScreenState();
}

class _TimeBankingScreenState extends State<TimeBankingScreen> {
  String selectedOption = 'offre'; // 'offre' ou 'demande'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Image.asset(
                    'assets/images/Logo_Orange.png',
                    height: 60,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "TimeBanking",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Choisissez un type d’offre",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 32),

                  Row(
                    children: [
                      _buildOptionCard(
                        icon: Icons.work_outline,
                        title: "Offrir un service",
                        subtitle: "Je propose des services",
                        isSelected: selectedOption == 'offre',
                        onTap: () {
                          setState(() {
                            selectedOption = 'offre';
                          });
                        },
                      ),
                      const SizedBox(width: 16),
                      _buildOptionCard(
                        icon: Icons.person_outline,
                        title: "Trouver un service",
                        subtitle: "Je veux trouver quelqu’un pour m’aider",
                        isSelected: selectedOption == 'demande',
                        onTap: () {
                          setState(() {
                            selectedOption = 'demande';
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (selectedOption == 'demande') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const FormulaireClientScreen(),
                            ),
                          );
                        } else {
                          // Tu peux ajouter un autre écran pour "offre" si besoin
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Page pour l’offre à venir..."),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF15E00),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text("Continuer", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF15E00).withOpacity(0.1) : Colors.white,
            border: Border.all(
              color: isSelected ? const Color(0xFFF15E00) : Colors.black12,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: isSelected ? const Color(0xFFF15E00) : Colors.grey.shade200,
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
