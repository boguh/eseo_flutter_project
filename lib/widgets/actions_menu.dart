import 'package:flutter/material.dart';

class ActionsMenu extends StatelessWidget {
  final String? title;  // Le titre devient optionnel (nullable)
  final List<Widget> children;

  const ActionsMenu({super.key, this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Vérification si le titre est null avant de l'afficher
        if (title != null)
          Text(
            title!,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0x77CFCFCF), width: 2),
            borderRadius: BorderRadius.circular(10),
            color: const Color(0x77D9D9D9),
          ),
          child: Column(
            children: children.asMap().entries.map((entry) {
              int index = entry.key;
              Widget child = entry.value;
              return Column(
                children: [
                  child,
                  if (index < children.length - 1) const Divider(
                    color: Color(0x77CFCFCF),
                    thickness: 2,
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
