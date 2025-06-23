import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class SocialLoginButtons extends StatelessWidget {
  final String googleIconPath;
  final String facebookIconPath;

  const SocialLoginButtons({
    super.key,
    required this.googleIconPath,
    required this.facebookIconPath,
  });

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // utilisateur a annulé

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      debugPrint("Erreur Google : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur Google : $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(result.accessToken!.token);

        await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Échec de la connexion Facebook: ${result.status}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint("Erreur Facebook : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur Facebook : $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        Row(
          children: [
            const Expanded(
              child: Divider(thickness: 1, color: Colors.grey),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text("Ou connectez-vous avec", style: TextStyle(color: Colors.black)),
            ),
            const Expanded(
              child: Divider(thickness: 1, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _signInWithGoogle(context),
              child: Image.asset(
                googleIconPath,
                width: 40,
                height: 40,
              ),
            ),
            const SizedBox(width: 24),
            GestureDetector(
              onTap: () => _signInWithFacebook(context),
              child: Image.asset(
                facebookIconPath,
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
