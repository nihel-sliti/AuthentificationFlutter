import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final int notificationCount;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      selectedItemColor: Color(0xFFF15E00),
      unselectedItemColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Stack(
            children: [
              Icon(Icons.notifications),
              if (notificationCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$notificationCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          label: 'Notification',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_border),
          label: 'Favoris',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Message',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Compte',
        ),
      ],
    );
  }
}
