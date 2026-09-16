import 'package:flutter/material.dart';

import 'screens/auth/login_screen.dart';
import 'screens/landlord/landlord_home.dart';
import 'screens/tenant/tenant_home.dart';
import 'services/api_service.dart';
import 'services/session_service.dart';

void main() {
  runApp(const RentApp());
}

class RentApp extends StatelessWidget {
  const RentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rent Manager',

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.light,
        ),

        scaffoldBackgroundColor:
            const Color(0xFFF6F7F9),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF111827),
          elevation: 0,
        ),

        inputDecorationTheme:
            InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFE5E7EB),
            ),
          ),
          enabledBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFE5E7EB),
            ),
          ),
          focusedBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFF2563EB),
              width: 1.5,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),

        elevatedButtonTheme:
            ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            elevation: 0,
            minimumSize:
                const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(12),
            ),
          ),
        ),

        textButtonTheme:
            TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor:
                const Color(0xFF2563EB),
          ),
        ),

        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),
        ),
      ),

      home: const StartupScreen(),
    );
  }
}

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() =>
      _StartupScreenState();
}

class _StartupScreenState
    extends State<StartupScreen> {

  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    try {
      final isLoggedIn =
          await SessionService.isLoggedIn();

      if (!isLoggedIn) {
        _goToLogin();
        return;
      }

      final role =
          await SessionService.getRole();

      final data =
          await ApiService.getTenantDashboard();

      if (!mounted) return;

      if (role == 'landlord') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                LandlordHome(
              data: data,
            ),
          ),
        );
      } else if (role == 'tenant') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                TenantHome(
              data: data,
            ),
          ),
        );
      } else {
        await SessionService.logout();
        _goToLogin();
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage =
            'Unable to restore your session.';
      });
    }
  }

  void _goToLogin() {
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding:
                const EdgeInsets.all(24),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 50,
                ),

                const SizedBox(height: 16),

                Text(
                  errorMessage!,
                  textAlign:
                      TextAlign.center,
                  style:
                      const TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      errorMessage = null;
                    });

                    _checkSession();
                  },
                  child:
                      const Text('RETRY'),
                ),

                const SizedBox(height: 8),

                TextButton(
                  onPressed: () async {
                    await SessionService
                        .logout();

                    _goToLogin();
                  },
                  child: const Text(
                    'GO TO LOGIN',
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}