import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../services/session_service.dart';
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

class _LoginScreenState
    extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final phoneController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool loading = false;
  bool obscurePassword = true;

  String? errorMessage;

  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 8,
      ),
    )..repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    FocusScope.of(context).unfocus();

    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final result =
          await ApiService.login(
        phone:
            phoneController.text.trim(),
        password:
            passwordController.text,
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

      // Save login session
      await SessionService.saveSession(
        role: result['role'],
        name: result['name'],
      );

      final role = result['role'];

      final dashboard =
          await ApiService
              .getTenantDashboard();

      if (!mounted) return;

      if (role == 'landlord') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                LandlordHome(
              data: dashboard,
            ),
          ),
        );
      } else if (role == 'tenant') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                TenantHome(
              data: dashboard,
            ),
          ),
        );
      } else {
        await SessionService.logout();

        if (!mounted) return;

        setState(() {
          errorMessage =
              'Invalid user role.';
          loading = false;
        });
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F9FF),
      body: Stack(
        children: [
          // Animated background
          Positioned.fill(
            child: AnimatedBuilder(
              animation:
                  animationController,
              builder:
                  (context, child) {
                return CustomPaint(
                  painter:
                      LoginBackgroundPainter(
                    animationValue:
                        animationController
                            .value,
                  ),
                );
              },
            ),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder:
                  (context, constraints) {
                final isDesktop =
                    constraints.maxWidth >=
                        900;

                if (isDesktop) {
                  return _desktopLayout(
                    constraints,
                  );
                }

                return _mobileLayout(
                  constraints,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _desktopLayout(
    BoxConstraints constraints,
  ) {
    return Center(
      child: SingleChildScrollView(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 50,
          vertical: 30,
        ),
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(
            maxWidth: 1250,
          ),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 11,
                child:
                    _buildHeroSection(),
              ),

              const SizedBox(width: 60),

              Expanded(
                flex: 9,
                child:
                    _buildLoginCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mobileLayout(
    BoxConstraints constraints,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        22,
        20,
        22,
        35,
      ),
      child: Column(
        children: [
          _buildMobileBrand(),

          const SizedBox(height: 10),

          SizedBox(
            height: 260,
            child: _buildIllustration(),
          ),

          const SizedBox(height: 10),

          _buildLoginCard(),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        // Brand
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration:
                  BoxDecoration(
                color:
                    const Color(
                  0xFF2563EB,
                ),
                borderRadius:
                    BorderRadius.circular(
                  15,
                ),
              ),
              child: const Icon(
                Icons.home_rounded,
                color: Colors.white,
                size: 27,
              ),
            ),

            const SizedBox(width: 14),

            const Text(
              'Rent Manager',
              style: TextStyle(
                fontSize: 25,
                fontWeight:
                    FontWeight.w800,
                color:
                    Color(0xFF172554),
              ),
            ),
          ],
        ),

        const SizedBox(height: 65),

        const Text(
          'Rental Made\nSimple.',
          style: TextStyle(
            fontSize: 55,
            height: 1.05,
            fontWeight:
                FontWeight.w800,
            color:
                Color(0xFF172554),
          ),
        ),

        const SizedBox(height: 18),

        const Text(
          'A simple way for landlords and tenants\nto stay connected with their home.',
          style: TextStyle(
            fontSize: 18,
            height: 1.5,
            color:
                Color(0xFF64748B),
          ),
        ),

        const SizedBox(height: 35),

        _buildFeature(
          Icons.home_work_outlined,
          'Properties',
        ),

        const SizedBox(height: 14),

        _buildFeature(
          Icons.people_outline,
          'Landlords & Tenants',
        ),

        const SizedBox(height: 14),

        _buildFeature(
          Icons.payments_outlined,
          'Simple Payments',
        ),

        const SizedBox(height: 14),

        _buildFeature(
          Icons.verified_user_outlined,
          'Clear & Transparent',
        ),

        const SizedBox(height: 20),

        SizedBox(
          height: 300,
          child: _buildIllustration(),
        ),
      ],
    );
  }

  Widget _buildMobileBrand() {
    return Row(
      children: [
        Container(
          width: 43,
          height: 43,
          decoration:
              BoxDecoration(
            color:
                const Color(0xFF2563EB),
            borderRadius:
                BorderRadius.circular(13),
          ),
          child: const Icon(
            Icons.home_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),

        const SizedBox(width: 12),

        const Text(
          'Rent Manager',
          style: TextStyle(
            fontSize: 22,
            fontWeight:
                FontWeight.w800,
            color:
                Color(0xFF172554),
          ),
        ),
      ],
    );
  }

  Widget _buildFeature(
    IconData icon,
    String text,
  ) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration:
              BoxDecoration(
            color: Colors.white
                .withOpacity(0.85),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 20,
            color:
                const Color(0xFF2563EB),
          ),
        ),

        const SizedBox(width: 12),

        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight:
                FontWeight.w600,
            color:
                Color(0xFF475569),
          ),
        ),
      ],
    );
  }

  Widget _buildIllustration() {
    return LayoutBuilder(
      builder:
          (context, constraints) {
        return CustomPaint(
          size: Size(
            constraints.maxWidth,
            constraints.maxHeight,
          ),
          painter:
              HomeIllustrationPainter(),
        );
      },
    );
  }

  Widget _buildLoginCard() {
    return Container(
      width: double.infinity,
      constraints:
          const BoxConstraints(
        maxWidth: 470,
      ),
      padding:
          const EdgeInsets.all(34),
      decoration:
          BoxDecoration(
        color: Colors.white
            .withOpacity(0.96),
        borderRadius:
            BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            blurRadius: 40,
            offset: Offset(0, 18),
            color:
                Color(0x180F172A),
          ),
        ],
        border: Border.all(
          color:
              Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome Back',
            style: TextStyle(
              fontSize: 30,
              fontWeight:
                  FontWeight.w800,
              color:
                  Color(0xFF172554),
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'Login to your account',
            style: TextStyle(
              fontSize: 15,
              color:
                  Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 30),

          TextField(
            controller:
                phoneController,
            keyboardType:
                TextInputType.phone,
            maxLength: 10,
            decoration:
                const InputDecoration(
              labelText:
                  'Mobile Number',
              hintText:
                  'Enter 10 digit mobile number',
              prefixText: '+91 ',
              prefixIcon: Icon(
                Icons.phone_outlined,
              ),
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
              labelText:
                  'Password',
              prefixIcon:
                  const Icon(
                Icons.lock_outline,
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
            ),
          ),

          if (errorMessage != null) ...[
            const SizedBox(height: 14),

            Container(
              width:
                  double.infinity,
              padding:
                  const EdgeInsets.all(12),
              decoration:
                  BoxDecoration(
                color:
                    const Color(
                  0xFFFEF2F2,
                ),
                borderRadius:
                    BorderRadius.circular(
                  10,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 19,
                    color:
                        Color(0xFFDC2626),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      errorMessage!,
                      style:
                          const TextStyle(
                        color:
                            Color(
                          0xFFB91C1C,
                        ),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          SizedBox(
            width:
                double.infinity,
            height: 54,
            child:
                ElevatedButton(
              onPressed:
                  loading
                      ? null
                      : login,
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(
                  0xFF2563EB,
                ),
                foregroundColor:
                    Colors.white,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),
              ),
              child: loading
                  ? const SizedBox(
                      width: 23,
                      height: 23,
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color:
                            Colors.white,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                      children: [
                        Text(
                          'LOGIN',
                          style:
                              TextStyle(
                            fontSize: 15,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),

                        SizedBox(width: 10),

                        Icon(
                          Icons
                              .arrow_forward_rounded,
                          size: 21,
                        ),
                      ],
                    ),
            ),
          ),

          const SizedBox(height: 27),

          Row(
            children: [
              const Expanded(
                child: Divider(
                  color:
                      Color(0xFFE2E8F0),
                ),
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Text(
                  'Demo Accounts',
                  style:
                      const TextStyle(
                    fontSize: 12,
                    color:
                        Color(0xFF94A3B8),
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),

              const Expanded(
                child: Divider(
                  color:
                      Color(0xFFE2E8F0),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child:
                    _demoAccount(
                  icon:
                      Icons.person_outline,
                  title:
                      'Landlord',
                  phone:
                      '9876543210',
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child:
                    _demoAccount(
                  icon:
                      Icons.person_2_outlined,
                  title:
                      'Tenant',
                  phone:
                      '9123456789',
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          const Center(
            child: Text(
              'Password: 123456',
              style: TextStyle(
                fontSize: 12,
                color:
                    Color(0xFF94A3B8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _demoAccount({
    required IconData icon,
    required String title,
    required String phone,
  }) {
    return InkWell(
      borderRadius:
          BorderRadius.circular(14),
      onTap: () {
        setState(() {
          phoneController.text =
              phone;
          passwordController.text =
              '123456';
          errorMessage = null;
        });
      },
      child: Container(
        padding:
            const EdgeInsets.all(13),
        decoration:
            BoxDecoration(
          color:
              const Color(0xFFF8FAFC),
          borderRadius:
              BorderRadius.circular(14),
          border: Border.all(
            color:
                const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color:
                  const Color(
                0xFF2563EB,
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                        const TextStyle(
                      fontWeight:
                          FontWeight.w700,
                      fontSize: 13,
                      color:
                          Color(
                        0xFF334155,
                      ),
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    phone,
                    style:
                        const TextStyle(
                      fontSize: 11,
                      color:
                          Color(
                        0xFF64748B,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// ANIMATED BACKGROUND
// ------------------------------------------------------------

class LoginBackgroundPainter
    extends CustomPainter {
  final double animationValue;

  LoginBackgroundPainter({
    required this.animationValue,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    // Soft background
    final backgroundPaint =
        Paint()
          ..color =
              const Color(
            0xFFF5F9FF,
          );

    canvas.drawRect(
      Offset.zero &
          size,
      backgroundPaint,
    );

    _drawWave(
      canvas,
      size,
      0.80,
      55,
      0.0,
      const Color(0xFFDCEBFF),
    );

    _drawWave(
      canvas,
      size,
      0.86,
      45,
      2.0,
      const Color(0xFFBFDBFE),
    );

    _drawWave(
      canvas,
      size,
      0.93,
      65,
      4.0,
      const Color(0xFF93C5FD),
    );

    // Decorative circles
    final circlePaint =
        Paint()
          ..color =
              const Color(
            0x332563EB,
          );

    canvas.drawCircle(
      Offset(
        size.width * .08,
        size.height * .18,
      ),
      35,
      circlePaint,
    );

    canvas.drawCircle(
      Offset(
        size.width * .91,
        size.height * .25,
      ),
      25,
      circlePaint,
    );
  }

  void _drawWave(
    Canvas canvas,
    Size size,
    double yPosition,
    double amplitude,
    double phaseOffset,
    Color color,
  ) {
    final path = Path();

    final baseY =
        size.height * yPosition;

    path.moveTo(
      0,
      baseY,
    );

    for (
      double x = 0;
      x <= size.width;
      x += 8
    ) {
      final normalized =
          x / size.width;

      final y =
          baseY +
              math.sin(
                    normalized *
                            math.pi *
                            2 +
                        phaseOffset +
                        animationValue *
                            math.pi *
                            2,
                  ) *
                  amplitude;

      path.lineTo(
        x,
        y,
      );
    }

    path.lineTo(
      size.width,
      size.height,
    );

    path.lineTo(
      0,
      size.height,
    );

    path.close();

    canvas.drawPath(
      path,
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(
    covariant LoginBackgroundPainter oldDelegate,
  ) {
    return oldDelegate.animationValue !=
        animationValue;
  }
}

// ------------------------------------------------------------
// MINIMALIST HOME ILLUSTRATION
// ------------------------------------------------------------

class HomeIllustrationPainter
    extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final centerX =
        size.width / 2;

    final houseWidth =
    math.min(
      size.width * .62,
      330.0,
    ).toDouble();

final houseHeight =
    houseWidth * .62;

    final houseLeft =
        centerX -
            houseWidth / 2;

    final houseTop =
        size.height * .24;

    // Shadow
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(
          centerX,
          houseTop +
              houseHeight +
              18,
        ),
        width:
            houseWidth * .9,
        height: 25,
      ),
      Paint()
        ..color =
            const Color(
          0x180F172A,
        ),
    );

    // House body
    final housePaint =
        Paint()
          ..color =
              Colors.white;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          houseLeft,
          houseTop,
          houseWidth,
          houseHeight,
        ),
        const Radius.circular(
          8,
        ),
      ),
      housePaint,
    );

    // Roof
    final roofPath = Path();

    roofPath.moveTo(
      houseLeft - 25,
      houseTop,
    );

    roofPath.lineTo(
      centerX,
      houseTop - 75,
    );

    roofPath.lineTo(
      houseLeft +
          houseWidth +
          25,
      houseTop,
    );

    roofPath.close();

    canvas.drawPath(
      roofPath,
      Paint()
        ..color =
            const Color(
          0xFF2563EB,
        ),
    );

    // Door
    final doorRect =
        Rect.fromLTWH(
      centerX - 27,
      houseTop +
          houseHeight -
          90,
      54,
      90,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        doorRect,
        const Radius.circular(
          6,
        ),
      ),
      Paint()
        ..color =
            const Color(
          0xFF1E3A8A,
        ),
    );

    // Door knob
    canvas.drawCircle(
      Offset(
        centerX + 14,
        houseTop +
            houseHeight -
            45,
      ),
      3,
      Paint()
        ..color =
            const Color(
          0xFFBFDBFE,
        ),
    );

    // Windows
    _drawWindow(
      canvas,
      Offset(
        houseLeft + 55,
        houseTop + 50,
      ),
    );

    _drawWindow(
      canvas,
      Offset(
        houseLeft +
            houseWidth -
            55,
        houseTop + 50,
      ),
    );

    // Person 1
    _drawPerson(
      canvas,
      Offset(
        houseLeft - 20,
        houseTop +
            houseHeight -
            10,
      ),
      false,
    );

    // Person 2
    _drawPerson(
      canvas,
      Offset(
        houseLeft +
            houseWidth +
            25,
        houseTop +
            houseHeight -
            5,
      ),
      true,
    );

    // Rent notification
    _drawNotification(
      canvas,
      Offset(
        houseLeft +
            houseWidth * .65,
        houseTop + 5,
      ),
    );
  }

  void _drawWindow(
    Canvas canvas,
    Offset center,
  ) {
    final rect =
        Rect.fromCenter(
      center: center,
      width: 48,
      height: 48,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect,
        const Radius.circular(
          5,
        ),
      ),
      Paint()
        ..color =
            const Color(
          0xFFDBEAFE,
        ),
    );

    final linePaint =
        Paint()
          ..color =
              const Color(
            0xFF93C5FD,
          )
          ..strokeWidth = 2;

    canvas.drawLine(
      Offset(
        center.dx,
        rect.top,
      ),
      Offset(
        center.dx,
        rect.bottom,
      ),
      linePaint,
    );

    canvas.drawLine(
      Offset(
        rect.left,
        center.dy,
      ),
      Offset(
        rect.right,
        center.dy,
      ),
      linePaint,
    );
  }

  void _drawPerson(
    Canvas canvas,
    Offset position,
    bool female,
  ) {
    final skinPaint =
        Paint()
          ..color =
              const Color(
            0xFFF5B99A,
          );

    final clothesPaint =
        Paint()
          ..color =
              female
                  ? const Color(
                      0xFF60A5FA,
                    )
                  : const Color(
                      0xFF3B82F6,
                    );

    // Head
    canvas.drawCircle(
      Offset(
        position.dx,
        position.dy - 52,
      ),
      17,
      skinPaint,
    );

    // Hair
    canvas.drawCircle(
      Offset(
        position.dx,
        position.dy - 61,
      ),
      17,
      Paint()
        ..color =
            const Color(
          0xFF1E293B,
        ),
    );

    // Body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(
            position.dx,
            position.dy - 20,
          ),
          width: 45,
          height: 60,
        ),
        const Radius.circular(
          12,
        ),
      ),
      clothesPaint,
    );

    // Legs
    final legPaint =
        Paint()
          ..color =
              const Color(
            0xFF334155,
          )
          ..strokeWidth = 7
          ..strokeCap =
              StrokeCap.round;

    canvas.drawLine(
      Offset(
        position.dx - 10,
        position.dy + 5,
      ),
      Offset(
        position.dx - 14,
        position.dy + 35,
      ),
      legPaint,
    );

    canvas.drawLine(
      Offset(
        position.dx + 10,
        position.dy + 5,
      ),
      Offset(
        position.dx + 14,
        position.dy + 35,
      ),
      legPaint,
    );
  }

  void _drawNotification(
    Canvas canvas,
    Offset position,
  ) {
    final rect =
        RRect.fromRectAndRadius(
      Rect.fromLTWH(
        position.dx,
        position.dy,
        125,
        45,
      ),
      const Radius.circular(
        14,
      ),
    );

    canvas.drawRRect(
      rect,
      Paint()
        ..color =
            Colors.white,
    );

    canvas.drawCircle(
      Offset(
        position.dx + 23,
        position.dy + 22,
      ),
      10,
      Paint()
        ..color =
            const Color(
          0xFF22C55E,
        ),
    );

    final checkPaint =
        Paint()
          ..color =
              Colors.white
          ..strokeWidth = 2
          ..style =
              PaintingStyle.stroke
          ..strokeCap =
              StrokeCap.round;

    final check =
        Path();

    check.moveTo(
      position.dx + 18,
      position.dy + 22,
    );

    check.lineTo(
      position.dx + 22,
      position.dy + 26,
    );

    check.lineTo(
      position.dx + 29,
      position.dy + 18,
    );

    canvas.drawPath(
      check,
      checkPaint,
    );

    const textStyle =
        TextStyle(
      fontSize: 12,
      fontWeight:
          FontWeight.w700,
      color:
          Color(0xFF334155),
    );

    final textPainter =
        TextPainter(
      text:
          const TextSpan(
        text: 'Rent Paid',
        style: textStyle,
      ),
      textDirection:
          TextDirection.ltr,
    );

    textPainter.layout();

    textPainter.paint(
      canvas,
      Offset(
        position.dx + 40,
        position.dy + 15,
      ),
    );
  }

  @override
  bool shouldRepaint(
    covariant HomeIllustrationPainter
        oldDelegate,
  ) {
    return false;
  }
}