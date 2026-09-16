import 'package:flutter/material.dart';

import '../../services/session_service.dart';
import '../auth/login_screen.dart';

class TenantHome extends StatefulWidget {
  final Map<String, dynamic> data;

  const TenantHome({
    super.key,
    required this.data,
  });

  @override
  State<TenantHome> createState() => _TenantHomeState();
}

class _TenantHomeState extends State<TenantHome> {
  bool paymentExpanded = false;
  bool reportExpanded = true;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    final payments = List<Map<String, dynamic>>.from(
      data['payments'] ?? [],
    );

    final appliances = List<Map<String, dynamic>>.from(
      data['appliances'] ?? [],
    );

    final water = Map<String, dynamic>.from(
      data['water'] ?? {},
    );

    final latestPayment =
        payments.isNotEmpty ? payments.first : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 700,
            ),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    24,
                    30,
                    24,
                    40,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        // Header
                        _buildHeader(data),

                        const SizedBox(height: 28),

                        // Payment
                        _buildPaymentSection(
                          latestPayment,
                          payments,
                        ),

                        const SizedBox(height: 16),

                        // Home report
                        _buildHomeReport(
                          appliances,
                          water,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: Text(
                'Hello,',
                style: TextStyle(
                  fontSize: 17,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),

            IconButton(
              tooltip: 'Logout',
              onPressed: _logout,
              icon: const Icon(
                Icons.logout_outlined,
              ),
            ),
          ],
        ),

        const SizedBox(height: 2),

        Text(
          '${data['name']} 👋',
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),

        const SizedBox(height: 8),

        Row(
          children: [
            const Icon(
              Icons.home_outlined,
              size: 18,
              color: Color(0xFF6B7280),
            ),

            const SizedBox(width: 6),

            Text(
              '${data['property']} • ${data['unit']}',
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentSection(
    Map<String, dynamic>? latestPayment,
    List<Map<String, dynamic>> payments,
  ) {
    return _buildSectionCard(
      title: 'PAYMENT',
      icon: Icons.account_balance_wallet_outlined,
      expanded: paymentExpanded,
      onTap: () {
        setState(() {
          paymentExpanded = !paymentExpanded;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (latestPayment != null) ...[
            Text(
              '${latestPayment['month']} ${latestPayment['year']}',
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF6B7280),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              '₹${_formatAmount(latestPayment['total'])}',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                _statusBadge(
                  latestPayment['status'] ?? 'Unknown',
                ),

                const SizedBox(width: 10),

                Text(
                  latestPayment['paymentDate'] ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ] else
            const Text(
              'No payment information available.',
              style: TextStyle(
                color: Color(0xFF6B7280),
              ),
            ),

          if (paymentExpanded && payments.isNotEmpty) ...[
            const SizedBox(height: 28),

            const Divider(
              height: 1,
              color: Color(0xFFE5E7EB),
            ),

            const SizedBox(height: 20),

            const Text(
              'Payment History',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 12),

            ...payments.map(
              (payment) =>
                  _buildPaymentHistoryItem(payment),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentHistoryItem(
    Map<String, dynamic> payment,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              color: Color(0xFF4B5563),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  '${payment['month']} ${payment['year']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'Rent ₹${_formatAmount(payment['rent'])}  •  '
                  'Electricity ₹${_formatAmount(payment['electricity'])}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Text(
                '₹${_formatAmount(payment['total'])}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 3),

              _statusBadge(
                payment['status'] ?? 'Unknown',
                small: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHomeReport(
    List<Map<String, dynamic>> appliances,
    Map<String, dynamic> water,
  ) {
    return _buildSectionCard(
      title: 'HOME REPORT',
      icon: Icons.home_outlined,
      expanded: reportExpanded,
      onTap: () {
        setState(() {
          reportExpanded = !reportExpanded;
        });
      },
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            '⚡  ELECTRICITY',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),

          const SizedBox(height: 14),

          if (appliances.isEmpty)
            const Text(
              'No electrical information available.',
              style: TextStyle(
                color: Color(0xFF6B7280),
              ),
            )
          else
            ...appliances.map(
              (appliance) =>
                  _buildApplianceItem(appliance),
            ),

          const SizedBox(height: 24),

          const Divider(
            height: 1,
            color: Color(0xFFE5E7EB),
          ),

          const SizedBox(height: 22),

          const Text(
            '💧  WATER SUPPLY',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),

          const SizedBox(height: 14),

          _buildWaterStatus(water),
        ],
      ),
    );
  }

  Widget _buildApplianceItem(
    Map<String, dynamic> appliance,
  ) {
    final status =
        appliance['status'] ?? 'Unknown';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              appliance['name'] ?? 'Unknown',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          _statusBadge(status),
        ],
      ),
    );
  }

  Widget _buildWaterStatus(
    Map<String, dynamic> water,
  ) {
    final status =
        water['status'] ?? 'Unknown';

    final note = water['note'] ?? '';

    final updatedAt =
        water['updatedAt'] ?? '';

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _statusBadge(status),

            const SizedBox(width: 10),

            if (updatedAt.isNotEmpty)
              Expanded(
                child: Text(
                  'Updated $updatedAt',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
          ],
        ),

        if (note.isNotEmpty) ...[
          const SizedBox(height: 10),

          Text(
            note,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4B5563),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required bool expanded,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            blurRadius: 18,
            offset: Offset(0, 6),
            color: Color(0x12000000),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius:
                BorderRadius.circular(20),
            child: Padding(
              padding:
                  const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration:
                        BoxDecoration(
                      color:
                          const Color(0xFFF3F4F6),
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),
                    child: Icon(
                      icon,
                      color:
                          const Color(0xFF374151),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),

                  Icon(
                    expanded
                        ? Icons
                            .keyboard_arrow_up
                        : Icons
                            .keyboard_arrow_down,
                    color:
                        const Color(0xFF6B7280),
                  ),
                ],
              ),
            ),
          ),

          if (expanded)
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                20,
                0,
                20,
                20,
              ),
              child: child,
            ),
        ],
      ),
    );
  }

  Widget _statusBadge(
    String status, {
    bool small = false,
  }) {
    String label;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'paid':
      case 'working':
      case 'normal':
        label = status;
        icon = Icons.check_circle_outline;
        break;

      case 'under repair':
      case 'limited':
        label = status;
        icon = Icons.build_outlined;
        break;

      case 'problem':
        label = status;
        icon = Icons.error_outline;
        break;

      default:
        label = status;
        icon = Icons.info_outline;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8 : 10,
        vertical: small ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: _statusBackground(status),
        borderRadius:
            BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: small ? 13 : 15,
            color: _statusColor(status),
          ),

          const SizedBox(width: 4),

          Text(
            label,
            style: TextStyle(
              fontSize: small ? 11 : 12,
              fontWeight: FontWeight.w700,
              color: _statusColor(status),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
      case 'working':
      case 'normal':
        return const Color(0xFF15803D);

      case 'under repair':
      case 'limited':
        return const Color(0xFFB45309);

      case 'problem':
        return const Color(0xFFDC2626);

      default:
        return const Color(0xFF4B5563);
    }
  }

  Color _statusBackground(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
      case 'working':
      case 'normal':
        return const Color(0xFFDCFCE7);

      case 'under repair':
      case 'limited':
        return const Color(0xFFFEF3C7);

      case 'problem':
        return const Color(0xFFFEE2E2);

      default:
        return const Color(0xFFF3F4F6);
    }
  }

  String _formatAmount(dynamic amount) {
    if (amount == null) {
      return '0';
    }

    final value =
        double.tryParse(amount.toString()) ?? 0;

    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(2);
  }

  // -------------------------
  // LOGOUT
  // -------------------------

  Future<void> _logout() async {
    final shouldLogout =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text(
            'Are you sure you want to logout?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('CANCEL'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text('LOGOUT'),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) {
      return;
    }

    await SessionService.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const LoginScreen(),
      ),
      (route) => false,
    );
  }
}