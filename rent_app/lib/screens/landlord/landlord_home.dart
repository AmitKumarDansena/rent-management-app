import 'package:flutter/material.dart';

import '../../services/api_service.dart';

class LandlordHome extends StatefulWidget {
  final Map<String, dynamic> data;

  const LandlordHome({
    super.key,
    required this.data,
  });

  @override
  State<LandlordHome> createState() => _LandlordHomeState();
}

class _LandlordHomeState extends State<LandlordHome> {
  late Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    data = Map<String, dynamic>.from(widget.data);
  }

  @override
  Widget build(BuildContext context) {
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
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                24,
                30,
                24,
                40,
              ),
              children: [
                _header(),

                const SizedBox(height: 28),

                _paymentCard(latestPayment),

                const SizedBox(height: 16),

                _electricityCard(appliances),

                const SizedBox(height: 16),

                _waterCard(water),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Landlord Dashboard',
          style: TextStyle(
            fontSize: 29,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          '${data['property']} • ${data['unit']}',
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF6B7280),
          ),
        ),

        const SizedBox(height: 4),

        Text(
          'Tenant: ${data['name']}',
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _paymentCard(
    Map<String, dynamic>? payment,
  ) {
    return _card(
      title: 'PAYMENT',
      icon: Icons.account_balance_wallet_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (payment != null) ...[
            Text(
              '${payment['month']} ${payment['year']}',
              style: const TextStyle(
                color: Color(0xFF6B7280),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              '₹${payment['total']}',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Rent'),
                Text('₹${payment['rent']}'),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Electricity'),
                Text('₹${payment['electricity']}'),
              ],
            ),
          ],

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _showPaymentDialog,
              icon: const Icon(
                Icons.edit_outlined,
              ),
              label: const Text(
                'UPDATE PAYMENT',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _electricityCard(
    List<Map<String, dynamic>> appliances,
  ) {
    return _card(
      title: 'ELECTRICITY',
      icon: Icons.bolt_outlined,
      child: Column(
        children: [
          ...appliances.map(
            (appliance) => _applianceRow(appliance),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                _showElectricityDialog(appliances);
              },
              icon: const Icon(
                Icons.edit_outlined,
              ),
              label: const Text(
                'UPDATE STATUS',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _applianceRow(
    Map<String, dynamic> appliance,
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
          Expanded(
            child: Text(
              appliance['name'],
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _statusBadge(
            appliance['status'],
          ),
        ],
      ),
    );
  }

  Widget _waterCard(
    Map<String, dynamic> water,
  ) {
    return _card(
      title: 'WATER SUPPLY',
      icon: Icons.water_drop_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _statusBadge(
            water['status'] ?? 'Unknown',
          ),

          if ((water['note'] ?? '').toString().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              water['note'],
              style: const TextStyle(
                color: Color(0xFF6B7280),
              ),
            ),
          ],

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                _showWaterDialog(water);
              },
              icon: const Icon(
                Icons.edit_outlined,
              ),
              label: const Text(
                'UPDATE STATUS',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            blurRadius: 18,
            offset: Offset(0, 6),
            color: Color(0x12000000),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          child,
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color background;
    Color foreground;

    switch (status.toLowerCase()) {
      case 'working':
      case 'normal':
      case 'paid':
        background = const Color(0xFFDCFCE7);
        foreground = const Color(0xFF15803D);
        break;

      case 'under repair':
      case 'limited':
        background = const Color(0xFFFEF3C7);
        foreground = const Color(0xFFB45309);
        break;

      case 'problem':
        background = const Color(0xFFFEE2E2);
        foreground = const Color(0xFFDC2626);
        break;

      default:
        background = const Color(0xFFF3F4F6);
        foreground = const Color(0xFF4B5563);
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: foreground,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // -------------------------
  // PAYMENT DIALOG
  // -------------------------

  void _showPaymentDialog() {
    final rentController = TextEditingController();
    final electricityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Payment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: rentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Rent',
                  prefixText: '₹ ',
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: electricityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Electricity',
                  prefixText: '₹ ',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),

            ElevatedButton(
              onPressed: () async {
                final rent =
                    double.tryParse(rentController.text) ?? 0;

                final electricity =
                    double.tryParse(
                          electricityController.text,
                        ) ??
                        0;

                await ApiService.updatePayment(
                  month: 'September',
                  year: 2026,
                  rent: rent,
                  electricity: electricity,
                  paymentDate: '10 September 2026',
                  status: 'Paid',
                );

                if (!mounted) return;

                Navigator.pop(context);

                await _reloadData();
              },
              child: const Text('SAVE'),
            ),
          ],
        );
      },
    );
  }

  // -------------------------
  // ELECTRICITY DIALOG
  // -------------------------

  void _showElectricityDialog(
    List<Map<String, dynamic>> appliances,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            'Select Appliance',
          ),
          children: appliances.map(
            (appliance) {
              return SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);

                  _editAppliance(
                    appliance,
                  );
                },
                child: Text(
                  appliance['name'],
                ),
              );
            },
          ).toList(),
        );
      },
    );
  }

  void _editAppliance(
    Map<String, dynamic> appliance,
  ) {
    String selectedStatus =
        appliance['status'];

    final noteController = TextEditingController(
      text: appliance['note'] ?? '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                'Update ${appliance['name']}',
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Working',
                        child: Text('Working'),
                      ),
                      DropdownMenuItem(
                        value: 'Under Repair',
                        child: Text('Under Repair'),
                      ),
                      DropdownMenuItem(
                        value: 'Problem',
                        child: Text('Problem'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() {
                          selectedStatus = value;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: noteController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Note',
                      hintText: 'Optional',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('CANCEL'),
                ),

                ElevatedButton(
                  onPressed: () async {
                    await ApiService.updateElectricity(
                      name: appliance['name'],
                      status: selectedStatus,
                      note: noteController.text,
                    );

                    if (!mounted) return;

                    Navigator.pop(context);

                    await _reloadData();
                  },
                  child: const Text('SAVE'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // -------------------------
  // WATER DIALOG
  // -------------------------

  void _showWaterDialog(
    Map<String, dynamic> water,
  ) {
    String selectedStatus =
        water['status'] ?? 'Normal';

    final noteController = TextEditingController(
      text: water['note'] ?? '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'Update Water Supply',
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Normal',
                        child: Text('Normal'),
                      ),
                      DropdownMenuItem(
                        value: 'Limited',
                        child: Text('Limited'),
                      ),
                      DropdownMenuItem(
                        value: 'Problem',
                        child: Text('Problem'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() {
                          selectedStatus = value;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: noteController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Note',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('CANCEL'),
                ),

                ElevatedButton(
                  onPressed: () async {
                    await ApiService.updateWater(
                      status: selectedStatus,
                      note: noteController.text,
                    );

                    if (!mounted) return;

                    Navigator.pop(context);

                    await _reloadData();
                  },
                  child: const Text('SAVE'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // -------------------------
  // RELOAD
  // -------------------------

  Future<void> _reloadData() async {
    final newData =
        await ApiService.getTenantDashboard();

    if (!mounted) return;

    setState(() {
      data = newData;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Updated successfully',
        ),
      ),
    );
  }
}