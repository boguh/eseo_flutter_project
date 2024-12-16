import 'package:flutter/material.dart';

class GoogleAccountToggle extends StatefulWidget {
  const GoogleAccountToggle({super.key});

  @override
  State<GoogleAccountToggle> createState() => _GoogleAccountToggleState();
}

class _GoogleAccountToggleState extends State<GoogleAccountToggle> {
  bool _isAuthenticated = false; // Détermine si l'utilisateur est authentifié ou non

  // Méthode pour simuler l'authentification
  void _toggleAuthentication() {
    setState(() {
      _isAuthenticated = !_isAuthenticated; // Bascule l'état d'authentification
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // Logo Google
            Container(
              padding: const EdgeInsets.all(10), // Padding autour de l'icône
              decoration: BoxDecoration(
                color: Colors.white, // Fond blanc pour l'icône
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8), // Coins arrondis
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Ombre
                    blurRadius: 6, // Flou de l'ombre
                    offset: const Offset(0, 2), // Décalage de l'ombre
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/google_logo.png',
                width: 25,
                height: 25,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Google Account', // Titre
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ],
        ),
        // Bouton sous forme de logo (icône d'authentification)
        IconButton(
          icon: Icon(
            _isAuthenticated ? Icons.check_circle_outlined : Icons.cancel_outlined, // Change l'icône en fonction de l'état
            color: _isAuthenticated ? Colors.green : Colors.red, // Couleur de l'icône
            size: 30, // Taille de l'icône
          ),
          onPressed: _toggleAuthentication, // Méthode appelée au clic
        ),
      ],
    );
  }
}
