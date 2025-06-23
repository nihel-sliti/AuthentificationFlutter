// reset_password_screen.dart
import 'package:aiforgood/components/PasswordInputField.dart';
import 'package:aiforgood/components/PrimaryButton.dart';
import 'package:aiforgood/components/header.dart';
import 'package:aiforgood/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String actionCode;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.actionCode,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmVisible = false;
  bool _loading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  bool hasMinLength(String value) => value.length >= 8;
  bool hasLowerCase(String value) => value.contains(RegExp(r'[a-z]'));
  bool hasUpperCase(String value) => value.contains(RegExp(r'[A-Z]'));
  bool hasDigit(String value) => value.contains(RegExp(r'[0-9]'));
  bool hasSpecialChar(String value) => value.contains(RegExp(r'[!@#\$&*~?=+%\^\-]'));

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.confirmPasswordReset(
        code: widget.actionCode,
        newPassword: _passwordController.text,
      );
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xFFF15E00),
                child: Icon(Icons.check, color: Colors.white, size: 30),
              ),
              const SizedBox(height: 16),
              const Text('Succès', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(height: 8),
              const Text('Félicitations, votre mot de passe est bien enregistré !'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF15E00),
                ),
                child: const Text("S'identifier", style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Erreur inconnue'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final password = _passwordController.text;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Header(
                  imagePath: 'assets/images/Logo_Orange.png',
                  title: 'Créer votre mot de passe',
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.email),
                      const SizedBox(height: 12),
                      PasswordField(
                        controller: _passwordController,
                        labelText: 'Mot de passe',
                      ),
                      const SizedBox(height: 8),
                      _buildCheck("Au moins 8 caractères", hasMinLength(password)),
                      _buildCheck("Au moins 1 minuscule", hasLowerCase(password)),
                      _buildCheck("Au moins 1 majuscule", hasUpperCase(password)),
                      _buildCheck("Au moins un 1 chiffre", hasDigit(password)),
                      _buildCheck("Au moins un caractère spécial @?!\$*", hasSpecialChar(password)),
                      const SizedBox(height: 12),
                      PasswordField(
                        controller: _confirmController,
                        labelText: 'Confirmation',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  text: 'Continuer',
                  color: const Color(0xFFF15E00),
                  onPressed: () => !_loading ? _submit() : null,

                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheck(String text, bool isValid) => Row(
        children: [
          Icon(isValid ? Icons.check : Icons.close, color: isValid ? Colors.green : Colors.red, size: 16),
          const SizedBox(width: 8),
          Text(text,
              style: TextStyle(
                color: isValid ? Colors.green : Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ))
        ],
      );
}
