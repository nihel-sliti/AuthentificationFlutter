import 'package:aiforgood/components/CustomInputField.dart';
import 'package:aiforgood/components/PasswordInputField.dart';
import 'package:aiforgood/components/PrimaryButton.dart';
import 'package:aiforgood/components/header.dart';
import 'package:aiforgood/components/socialLoginButtons.dart';
import 'package:aiforgood/screens/forgot_password_screen.dart';
import 'package:aiforgood/screens/inscri_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _showError = false;
  bool _showPasswordField = false;
  bool _stayConnected = false;


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 500, 
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.1),
                        const Header(
                          imagePath: 'assets/images/Logo_Orange.png',
                          title: 'Identifiez-vous',
                        ),
                        const SizedBox(height: 50),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomInputField(
                                controller: _emailController,
                                labelText: 'Adresse Mail',
                                showError: _showError,
                                errorMessage: 'Adresse e-mail incorrecte',
                                errorIconPath: 'assets/images/errorIcon.png',
                              ),
                              if (_showPasswordField) ...[
                                const SizedBox(height: 20),
                                PasswordField(
                                  controller: _passwordController,
                                  labelText: 'Mot de passe',
                                ),
              
  Padding(
    padding: const EdgeInsets.only(top: 12.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _stayConnected = !_stayConnected;
                });
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _stayConnected ? const Color(0xFFF15E00) : Colors.transparent,
                  border: Border.all(color: const Color(0xFFF15E00), width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: _stayConnected
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : null,
              ),
            ),
            const SizedBox(width: 8),
            const Text("Rester identifié"),
          ],
        ),
        GestureDetector(
          onTap: () {
             Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
            );
          },
          child: Row(
            children: const [
              Text(
                "Mot de passe oublié ?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.arrow_forward, color: Color(0xFFF15E00), size: 18),
            ],
          ),
        ),
      ],
    ),
  ),

                              ],
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),
                        PrimaryButton(
                          text: 'Continuer',
                          color: const Color(0xFFF15E00),
                          onPressed: () {
                            final isValidEmail = _emailController.text.contains('@');

                            setState(() {
                              _showError = !isValidEmail;
                              _showPasswordField = isValidEmail;
                            });

                            if (isValidEmail) {
                              print('Email OK – affichage du champ mot de passe');
                            } else {
                              print('Email invalide');
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: "Vous n'avez pas de compte ? ",
                              style: const TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: 'Inscrivez-vous',
                                  style: const TextStyle(
                                    color: Color(0xFFF15E00),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => const RegisterScreen()),
                                            );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),
                        const SocialLoginButtons(
                          googleIconPath: 'assets/images/GoogleIcon.png',
                          facebookIconPath: 'assets/images/FacebookIcon.png',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
