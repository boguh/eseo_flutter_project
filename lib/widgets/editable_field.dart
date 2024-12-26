import 'package:flutter/material.dart';

class EditableField extends StatelessWidget {
  final String label; // Le label affiché au-dessus du champ
  final String placeholder; // Placeholder du champ
  final TextEditingController controller; // Contrôleur du champ

  const EditableField({
    super.key,
    this.placeholder = '',
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Row pour afficher le label et le champ de texte
    return Row(
      children: [
        // Label
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: 'Roboto',
          ),
        ),
        const SizedBox(width: 10),
        // Champ de texte
        Expanded(
          // texte de champ de taille 16
          child: TextField(
            controller: controller,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              fontFamily: 'Roboto',
            ),
            decoration: InputDecoration(
              // Placeholder
              hintText: placeholder,
              border:
              // On enlève la bordure par défaut
              const OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ),
      ],
    );
  }
}
