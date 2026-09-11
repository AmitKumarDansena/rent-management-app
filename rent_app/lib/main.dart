import 'package:flutter/material.dart';

import 'screens/landlord/landlord_home.dart';
import 'services/api_service.dart';

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
      home: const AppLoader(),
    );
  }
}

class AppLoader extends StatefulWidget {
  const AppLoader({super.key});

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> {
  late Future<Map<String, dynamic>> dashboard;

  @override
  void initState() {
    super.initState();

    dashboard =
        ApiService.getTenantDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: dashboard,
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                'Error:\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: Text(
                'No data available',
              ),
            ),
          );
        }

        return LandlordHome(
          data: snapshot.data!,
        );
      },
    );
  }
}