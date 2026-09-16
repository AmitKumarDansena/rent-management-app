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
      title: 'Rent App',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
      ),
      home: const StartupScreen(),
    );
  }
}

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    try {
      final isLoggedIn = await SessionService.isLoggedIn();

      if (!isLoggedIn) {
        _goToLogin();
        return;
      }

      final role = await SessionService.getRole();

      if (role == 'landlord') {
        final data = await ApiService.getTenantDashboard();

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LandlordHome(data: data),
          ),
        );
      } else if (role == 'tenant') {
        final data = await ApiService.getTenantDashboard();

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => TenantHome(data: data),
          ),
        );
      } else {
        await SessionService.logout();
        _goToLogin();
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Unable to restore your session.';
      });
    }
  }

  void _goToLogin() {
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 50,
              ),
              const SizedBox(height: 16),
              Text(
                errorMessage!,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    errorMessage = null;
                  });

                  _checkSession();
                },
                child: const Text('Retry'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () async {
                  await SessionService.logout();
                  _goToLogin();
                },
                child: const Text('Go to Login'),
              ),
            ],
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