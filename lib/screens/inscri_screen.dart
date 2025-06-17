import 'package:aiforgood/screens/successScreen.dart';
import 'package:flutter/material.dart';
import 'package:aiforgood/components/CustomInputField.dart';
import 'package:aiforgood/components/PasswordInputField.dart';
import 'package:aiforgood/components/PrimaryButton.dart';
import 'package:aiforgood/components/header.dart';
import 'package:aiforgood/components/socialLoginButtons.dart';
import 'package:firebase_auth/firebase_auth.dart';
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _showPasswordRules = true;
  bool _showEmailError = false;
  bool _showPasswordError = false;
  bool _showConfirmError = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool hasMinLength(String value) => value.length >= 8;
  bool hasLowercase(String value) => value.contains(RegExp(r'[a-z]'));
  bool hasUppercase(String value) => value.contains(RegExp(r'[A-Z]'));
  bool hasDigit(String value) => value.contains(RegExp(r'[0-9]'));
  bool hasSpecialChar(String value) => value.contains(RegExp(r'[!@#\$&*~?%]'));

  @override
  Widget build(BuildContext context) {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                      
                      Center(
                        child: Column(
                          children: [
                            SizedBox(height: screenHeight * 0.05),
                            const Header(
                              imagePath: 'assets/images/Logo_Orange.png',
                              title: 'Inscrivez-vous',
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
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
                              showError: _showEmailError,
                              errorMessage: 'Adresse e-mail incorrecte',
                              errorIconPath: 'assets/images/errorIcon.png',
                            ),
                            const SizedBox(height: 10),
                            PasswordField(
                              controller: _passwordController,
                              labelText: 'Mot de passe',
                            ),
                            const SizedBox(height: 12),
                            if (_showPasswordRules)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildRuleText('Au moins 8 caractères', hasMinLength(password)),
                                  _buildRuleText('Au moins 1 minuscule', hasLowercase(password)),
                                  _buildRuleText('Au moins 1 majuscule', hasUppercase(password)),
                                  _buildRuleText('Au moins un 1 chiffre', hasDigit(password)),
                                  _buildRuleText('Au moins un caractère spécial @?!\$%', hasSpecialChar(password)),
                                ],
                              ),
                            const SizedBox(height: 10),
                            PasswordField(
                              controller: _confirmPasswordController,
                              labelText: 'Confirmation',
                            ),
                            if (_showConfirmError)
                              Container(
                                margin: const EdgeInsets.only(top: 8),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFDE5E6),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/errorIcon.png',
                                      width: 18,
                                      height: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    const Expanded(
                                      child: Text(
                                        'Les mots de passe ne correspondent pas.',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      PrimaryButton(
                        text: 'Continuer',
                        color: const Color(0xFFF15E00),
                       onPressed: () async {
  final email = _emailController.text.trim();
  final password = _passwordController.text;
  final confirmPassword = _confirmPasswordController.text;

  final isValidPassword = hasMinLength(password) &&
      hasLowercase(password) &&
      hasUppercase(password) &&
      hasDigit(password) &&
      hasSpecialChar(password);

  setState(() {
    _showEmailError = email.isEmpty || !email.contains('@');
    _showPasswordError = password.isEmpty || !isValidPassword;
    _showConfirmError = password != confirmPassword;
  });

  if (_showEmailError || _showPasswordError || _showConfirmError) return;

  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

   Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (_) => const SuccessScreen()),
);

  } on FirebaseAuthException catch (e) {
    String message = '';
    if (e.code == 'weak-password') {
      message = 'Mot de passe trop faible.';
    } else if (e.code == 'email-already-in-use') {
      message = 'Un compte existe déjà avec cet e-mail.';
    } else {
      message = 'Erreur : ${e.message}';
    }

    // Affiche un message d’erreur
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  } catch (e) {
    print(e);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Erreur inconnue.'), backgroundColor: Colors.red),
    );
  }
},

                      ),
                 
                      const SocialLoginButtons(
                        googleIconPath: 'assets/images/GoogleIcon.png',
                        facebookIconPath: 'assets/images/FacebookIcon.png',
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRuleText(String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check : Icons.close,
            color: isValid ? Colors.green : Colors.red,
            size: 16,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                color: isValid ? Colors.green : Colors.red,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DividerWithText extends StatelessWidget {
  const DividerWithText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: Divider(thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text("Ou connectez-vous avec", style: TextStyle(color: Colors.black)),
        ),
        Expanded(child: Divider(thickness: 1)),
      ],
    );
  }
}
