import 'package:flutter/material.dart';

class TeamsListRedirect extends StatelessWidget {
  const TeamsListRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // Logo "Teams List" avec une icône de liste avec des cases cochées
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.checklist_rounded, // Icône représentant une liste avec des cases cochées
                color: Colors.black,
                size: 25, // Taille de l'icône
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Teams List', // Titre
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ],
        ),
        // IconButton pour rediriger vers la page TeamsPage
        const Icon(
          Icons.arrow_forward_ios_rounded, // Icône de flèche de redirection
          color: Colors.grey, // Couleur de l'icône
          size: 20, // Taille de l'icône
        ),
      ],
    );
  }
}
