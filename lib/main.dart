import 'package:flutter/material.dart';
import 'package:eseo_flutter_project/utils/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      title: 'Buni',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
