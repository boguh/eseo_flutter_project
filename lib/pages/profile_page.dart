import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/actions_menu.dart';
import '../widgets/editable_field.dart';
import '../utils/router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Controllers pour les champs de texte
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  // Variables pour l'image de profil
  File? _profileImage; // Contient l'image sélectionnée
  final ImagePicker _picker = ImagePicker();

  // Fonction pour choisir une image
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w600,
            fontSize: 25,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            size: 35,
          ),
          onPressed: () {
            if (GoRouter.of(context).canPop()) {
              context.pop();
            } else {
              context.go(RouteNames.settings.path); // Fallback navigation
            }
          },
          tooltip: 'Go back',
        ),
        // Bouton 'Done' pour sauvegarder
        actions: [
          TextButton(
            onPressed: () {
              final firstName = _firstNameController.text;
              final lastName = _lastNameController.text;

              if (firstName.isNotEmpty && lastName.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Changes saved: $firstName $lastName')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill out all fields.')),
                );
              }
            },
            child: const Text(
              'Done',
              style: TextStyle(
                color: Colors.blueAccent,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image de profil avec bouton de sélection
              GestureDetector(
                onTap: _pickImage, // Action pour choisir une image
                child: Column(
                  children: [
                    // Afficher l'image sélectionnée ou un avatar par défaut
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : null,
                      child: _profileImage == null
                          ? const Icon(
                        Icons.person_rounded,
                        size: 50,
                        color: Colors.grey,
                      )
                          : null,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Change',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Section de formulaire via ActionsMenu
              ActionsMenu(
                children: [
                  EditableField(
                    label: 'First Name', // Champ pour le prénom
                    placeholder: 'John',
                    controller: _firstNameController,
                  ),
                  EditableField(
                    label: 'Last Name', // Champ pour le nom
                    placeholder: 'Doe',
                    controller: _lastNameController,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Libérer les ressources des contrôleurs
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
}
