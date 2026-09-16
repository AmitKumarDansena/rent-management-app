import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../landlord/landlord_home.dart';
import '../tenant/tenant_home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool loading = false;
  bool obscurePassword = true;

  String? errorMessage;

  Future<void> login() async {
    FocusScope.of(context).unfocus();

    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final result = await ApiService.login(
        phone: phoneController.text.trim(),
        password: passwordController.text,
      );

      if (!mounted) return;

      if (result['success'] != true) {
        setState(() {
          errorMessage =
              result['message'] ??
                  'Invalid login details';

          loading = false;
        });

        return;
      }

      final role = result['role'];

      if (role == 'landlord') {
        final dashboard =
            await ApiService.getTenantDashboard();

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LandlordHome(
              data: dashboard,
            ),
          ),
        );
      } else if (role == 'tenant') {
        final dashboard =
            await ApiService.getTenantDashboard();

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => TenantHome(
              data: dashboard,
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage =
            'Unable to connect to server.';
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF6F7F9),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 430,
            ),
            child: Container(
              padding:
                  const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 25,
                    offset: Offset(0, 8),
                    color: Color(0x12000000),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Icon(
                      Icons.home_work_outlined,
                      size: 54,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Center(
                    child: Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Center(
                    child: Text(
                      'Login to your rent management account',
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        color:
                            Color(0xFF6B7280),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: const InputDecoration(
                        labelText: 'Mobile Number',
                        hintText: 'Enter 10 digit mobile number',
                        prefixText: '+91 ',
                        prefixIcon: Icon(
                            Icons.phone_outlined,
                            ),
                        border: OutlineInputBorder(),
                        counterText: '',
                    ),
                ),

                  const SizedBox(height: 16),

                  TextField(
                    controller:
                        passwordController,
                    obscureText:
                        obscurePassword,
                    decoration:
                        InputDecoration(
                      labelText: 'Password',
                      prefixIcon:
                          const Icon(
                        Icons
                            .lock_outline,
                      ),
                      suffixIcon:
                          IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons
                                  .visibility_outlined
                              : Icons
                                  .visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword =
                                !obscurePassword;
                          });
                        },
                      ),
                      border:
                          const OutlineInputBorder(),
                    ),
                  ),

                  if (errorMessage != null) ...[
                    const SizedBox(height: 14),

                    Text(
                      errorMessage!,
                      style:
                          const TextStyle(
                        color:
                            Color(0xFFDC2626),
                        fontSize: 14,
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          loading
                              ? null
                              : login,
                      child: loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth:
                                    2,
                              ),
                            )
                          : const Text(
                              'LOGIN',
                            ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Container(
                    padding:
                        const EdgeInsets.all(
                      14,
                    ),
                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                        0xFFF9FAFB,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),
                    child: const Column(
  crossAxisAlignment:
      CrossAxisAlignment.start,
  children: [
    Text(
      'Demo accounts',
      style: TextStyle(
        fontWeight: FontWeight.w700,
      ),
    ),
    SizedBox(height: 8),
    Text(
      'Landlord: 9876543210',
    ),
    Text(
      'Tenant: 9123456789',
    ),
    Text(
      'Password: 123456',
    ),
  ],
),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}