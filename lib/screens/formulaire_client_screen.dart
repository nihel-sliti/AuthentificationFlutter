import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class FormulaireClientScreen extends StatefulWidget {
  const FormulaireClientScreen({super.key});

  @override
  State<FormulaireClientScreen> createState() => _FormulaireClientScreenState();
}

class _FormulaireClientScreenState extends State<FormulaireClientScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();

  String? _selectedVille;
  bool _isLoading = false;

  final List<String> _villes = [
    'Paris',
    'Lyon',
    'Marseille',
    'Toulouse',
    'Nice'
  ];

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _professionController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'role': 'client',
        'nom': _nomController.text.trim(),
        'prenom': _prenomController.text.trim(),
        'profession': _professionController.text.trim(),
        'whatsapp': _whatsappController.text.trim(),
        'ville': _selectedVille,
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil enregistré avec succès.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'enregistrement : $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créez votre profil'),
        backgroundColor: const Color(0xFFF15E00),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nomController,
                  decoration: const InputDecoration(
                    labelText: 'Nom',
                    suffixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Champ requis' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _prenomController,
                  decoration: const InputDecoration(
                    labelText: 'Prénom',
                    suffixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Champ requis' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _professionController,
                  decoration: const InputDecoration(
                    labelText: 'Profession',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _whatsappController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'WhatsApp',
                    hintText: 'écrire un numéro valide',
                    suffixIcon: Icon(Icons.phone_android),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedVille,
                  hint: const Text('Choisir votre ville de résidence'),
                  items: _villes.map((ville) {
                    return DropdownMenuItem(
                      value: ville,
                      child: Text(ville),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedVille = value;
                    });
                  },
                  validator: (value) => value == null ? 'Sélectionnez une ville' : null,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF15E00),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() => _isLoading = true);
                        await _saveProfile();
                        setState(() => _isLoading = false);
                      }
                    },
                    child: const Text('Continuer', style: TextStyle(color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
