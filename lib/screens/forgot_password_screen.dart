import 'dart:async';
import 'package:aiforgood/components/PrimaryButton.dart';
import 'package:aiforgood/components/header.dart';
import 'package:aiforgood/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String email;
  const ForgotPasswordScreen({super.key, required this.email});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  int _secondsRemaining = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _sendResetEmail();
    _startResendTimer();
  }

  void _sendResetEmail() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: widget.email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lien envoyé avec succès. Vérifiez votre boîte mail."),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur : ${e.message}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _startResendTimer() {
    _secondsRemaining = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
                const SizedBox(height: 20),

                Center(
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.04),
                      const Header(
                        imagePath: 'assets/images/Logo_Orange.png',
                        title: 'Mot de passe oublié',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.person_outline, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Un lien de réinitialisation a été envoyé à ${_maskEmail(widget.email)}.',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                const Text(
                  "* Vérifiez aussi votre dossier Spam si vous ne trouvez pas l'e-mail.",
                  style: TextStyle(fontSize: 13, color: Colors.red),
                ),

                const SizedBox(height: 32),
                if (_secondsRemaining > 0)
                  Text(
                    'Vous pouvez renvoyer le lien dans $_secondsRemaining secondes.',
                    style: const TextStyle(color: Colors.black87),
                  ),

                const SizedBox(height: 20),

                PrimaryButton(
                  text: 'Renvoyer le lien',
                  color: const Color(0xFFF15E00),
                  onPressed: _secondsRemaining == 0 ? () => _sendResetEmail() : null,
                ),

                const SizedBox(height: 24),

                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.deepOrangeAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('⬅ Retour à la connexion'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final domain = parts[1];
    final maskedName = name.length <= 2
        ? '${name[0]}*'
        : name.substring(0, 2) + '*' * (name.length - 2);
    return '$maskedName@$domain';
  }
}
