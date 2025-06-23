import 'package:aiforgood/components/custom_bottom_nav_bar.dart';
import 'package:aiforgood/screens/UpdateProfileScreen.dart';
import 'package:aiforgood/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileClientScreen extends StatefulWidget {
  const ProfileClientScreen({super.key});

  @override
  State<ProfileClientScreen> createState() => _ProfileClientScreenState();
}

class _ProfileClientScreenState extends State<ProfileClientScreen> {
  final user = FirebaseAuth.instance.currentUser;
  bool _showHistorique = false;
  List<Map<String, dynamic>> _userServices = [];

  Future<void> _loadUserServices() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('services')
        .where('vendeuseId', isEqualTo: user!.uid)
        .get();

    setState(() {
      _userServices = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      _showHistorique = true;
    });
  }
   int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        /*leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFF15E00)),
          onPressed: () => Navigator.pop(context),
        ),*/
        title: const Text(
          'Profil',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFFF15E00)),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.all(24),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.logout, size: 40, color: Color(0xFFF15E00)),
                      const SizedBox(height: 16),
                      const Text(
                        'Vous allez vous déconnecter pour changer de compte ?',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF15E00)),
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Annuler'),
                          ),
                          OutlinedButton(
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => const LoginScreen()),
                                (route) => false,
                              );
                            },
                            child: const Text('Confirmer'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(user!.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Aucun profil trouvé."));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const UpdateProfileScreen()),
                    );
                  },
                  child: const Text('Modifier mon profil'),
                ),
                const SizedBox(height: 12),
                Text(
                  "${data['prenom']} ${data['nom']}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 4),
                Text(
                  data['profession'] ?? '',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFFF15E00),
                  child: Icon(Icons.person_outline, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.email, color: Color(0xFFF15E00)),
                    const SizedBox(width: 8),
                    Text(data['email'] ?? user!.email ?? ''),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.phone_android, color: Color(0xFFF15E00)),
                    const SizedBox(width: 8),
                    Text(data['whatsapp'] ?? ''),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on_outlined, color: Color(0xFFF15E00)),
                    const SizedBox(width: 8),
                    Text(data['ville'] ?? ''),
                  ],
                ),
                const SizedBox(height: 32),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _showHistorique = false;
                            });
                          },
                          child: const Text('Description', style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: _loadUserServices,
                          child: const Text('Historique de Service', style: TextStyle(color: Colors.black54)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (!_showHistorique)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      data['description'] ?? 'Aucune description fournie.',
                      style: const TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ),
                if (_showHistorique)
                  Column(
                    children: _userServices.isEmpty
                        ? [const Text("Aucun service disponible.")]
                        : _userServices.map((service) {
                            return Card(
                              child: ListTile(
                                title: Text(service['titre'] ?? 'Sans titre'),
                                subtitle: Text(service['description'] ?? ''),
                              ),
                            );
                          }).toList(),
                  ),
              ],
            ),
          );
        },
      ), bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        notificationCount: 1,
      ),
    );
  }
}
