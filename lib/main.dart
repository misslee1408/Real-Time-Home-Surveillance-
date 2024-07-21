// lib/main.dart modified page with authentication part handling
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'HomePage.dart';
import 'LoginScreen.dart';
import 'providers/auth_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        home: Consumer<AuthProvider>(
          builder: (ctx, auth, _) => auth.isAuthenticated ? HomePage() : LoginScreen(),
        ),
      ),
    );
  }
}
