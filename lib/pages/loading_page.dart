import '../utils/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(RouteNames.welcome.path),
      child: Scaffold(
        backgroundColor: const Color(0xFFD9D9D9),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Placeholder for logo - replace with your actual logo
              SvgPicture.asset(
                'assets/images/buni_logo.svg',
                width: 100,
                height: 100,
                color: Colors.black,
              ),
              Text(
                'Buni',
                style: GoogleFonts.robotoSlab(
                  fontSize: 36,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}