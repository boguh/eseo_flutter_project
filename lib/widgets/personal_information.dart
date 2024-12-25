import 'package:flutter/material.dart';
import '../utils/router.dart';
import 'package:go_router/go_router.dart';

class PersonalInfoRedirect extends StatelessWidget {
  const PersonalInfoRedirect({super.key});

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
                Icons.person_rounded,
                color: Colors.black,
                size: 25,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Personal Information', // Titre
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
          Icons.arrow_forward_ios_rounded,
          color: Colors.grey,
          size: 20,
        ),
      ],
    );
  }
}
