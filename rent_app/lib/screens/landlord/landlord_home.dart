import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../services/session_service.dart';
import '../../widgets/wave_background.dart';
import '../auth/login_screen.dart';

class LandlordHome extends StatefulWidget {
  final Map<String, dynamic> data;

  const LandlordHome({
    super.key,
    required this.data,
  });

  @override
  State<LandlordHome> createState() =>
      _LandlordHomeState();
}

class _LandlordHomeState
    extends State<LandlordHome> {
  late Map<String, dynamic> data;

  bool reloading = false;

  @override
  void initState() {
    super.initState();

    data = Map<String, dynamic>.from(
      widget.data,
    );
  }

  @override
  Widget build(BuildContext context) {
    final payments =
        List<Map<String, dynamic>>.from(
      data['payments'] ?? [],
    );

    final appliances =
        List<Map<String, dynamic>>.from(
      data['appliances'] ?? [],
    );

    final water =
        Map<String, dynamic>.from(
      data['water'] ?? {},
    );

    final latestPayment =
        payments.isNotEmpty
            ? payments.first
            : null;

    return Scaffold(
      body: WaveBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (
              context,
              constraints,
            ) {
              final isWide =
                  constraints.maxWidth >= 850;

              return Center(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(
                    maxWidth: 1100,
                  ),
                  child: ListView(
                    padding:
                        const EdgeInsets.fromLTRB(
                      24,
                      28,
                      24,
                      50,
                    ),
                    children: [
                      _header(),

                      const SizedBox(height: 20),

                      _overviewCard(
                        latestPayment,
                      ),

                      const SizedBox(height: 18),

                      if (isWide)
                        Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child:
                                  _paymentCard(
                                latestPayment,
                              ),
                            ),

                            const SizedBox(
                              width: 18,
                            ),

                            Expanded(
                              child:
                                  _electricityCard(
                                appliances,
                              ),
                            ),
                          ],
                        )
                      else ...[
                        _paymentCard(
                          latestPayment,
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        _electricityCard(
                          appliances,
                        ),
                      ],

                      const SizedBox(height: 18),

                      _waterCard(water),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // HEADER
  // ==========================================================

  Widget _header() {
    final property =
        data['property']?.toString() ??
            'Property';

    final unit =
        data['unit']?.toString() ??
            'Unit';

    final tenant =
        data['name']?.toString() ??
            'Tenant';

    final hour =
        DateTime.now().hour;

    String greeting;

    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'RENT MANAGER',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight:
                          FontWeight.w800,
                      letterSpacing: 1.4,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    greeting,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 3),

                  const Text(
                    'Landlord Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              decoration: BoxDecoration(
                color: Colors.white
                    .withOpacity(0.16),
                borderRadius:
                    BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white
                      .withOpacity(0.22),
                ),
              ),
              child: IconButton(
                tooltip: 'Logout',
                onPressed: _logout,
                icon: const Icon(
                  Icons.logout_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Property information
        Container(
          width: double.infinity,
          padding:
              const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                blurRadius: 25,
                offset: Offset(0, 10),
                color: Color(0x25000000),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color:
                      const Color(0xFFEFF6FF),
                  borderRadius:
                      BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.home_work_rounded,
                  color:
                      Color(0xFF2563EB),
                  size: 27,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      property,
                      style:
                          const TextStyle(
                        fontSize: 17,
                        fontWeight:
                            FontWeight.w800,
                        color:
                            Color(0xFF172554),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '$unit • Tenant: $tenant',
                      style:
                          const TextStyle(
                        fontSize: 13,
                        color:
                            Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // OVERVIEW
  // ==========================================================

  Widget _overviewCard(
    Map<String, dynamic>? payment,
  ) {
    final rent =
        payment?['rent'] ?? 0;

    final electricity =
        payment?['electricity'] ?? 0;

    final total =
        payment?['total'] ?? 0;

    return Container(
      padding:
          const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            blurRadius: 25,
            offset: Offset(0, 10),
            color: Color(0x25000000),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration:
                    BoxDecoration(
                  color:
                      const Color(0xFFFFF7ED),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.analytics_outlined,
                  color:
                      Color(0xFFFF8A00),
                  size: 21,
                ),
              ),

              const SizedBox(width: 11),

              const Text(
                'PROPERTY OVERVIEW',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      FontWeight.w800,
                  letterSpacing: 0.5,
                  color:
                      Color(0xFF334155),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          LayoutBuilder(
            builder: (
              context,
              constraints,
            ) {
              return Row(
                children: [
                  Expanded(
                    child: _overviewItem(
                      icon:
                          Icons.home_outlined,
                      title: 'Rent',
                      value:
                          '₹${_formatAmount(rent)}',
                    ),
                  ),

                  _divider(),

                  Expanded(
                    child: _overviewItem(
                      icon:
                          Icons.bolt_outlined,
                      title: 'Electricity',
                      value:
                          '₹${_formatAmount(electricity)}',
                    ),
                  ),

                  _divider(),

                  Expanded(
                    child: _overviewItem(
                      icon:
                          Icons.payments_outlined,
                      title: 'Total',
                      value:
                          '₹${_formatAmount(total)}',
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _overviewItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 21,
          color:
              const Color(0xFF64748B),
        ),

        const SizedBox(height: 7),

        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color:
                Color(0xFF64748B),
          ),
        ),

        const SizedBox(height: 4),

        Text(
          value,
          style: const TextStyle(
            fontSize: 17,
            fontWeight:
                FontWeight.w800,
            color:
                Color(0xFF172554),
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 55,
      margin:
          const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      color:
          const Color(0xFFE2E8F0),
    );
  }

  // ==========================================================
  // PAYMENT
  // ==========================================================

  Widget _paymentCard(
    Map<String, dynamic>? payment,
  ) {
    return _card(
      title: 'PAYMENT',
      icon:
          Icons.account_balance_wallet_outlined,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          if (payment != null) ...[
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${payment['month']} ${payment['year']}',
                        style:
                            const TextStyle(
                          fontSize: 14,
                          color:
                              Color(0xFF64748B),
                        ),
                      ),

                      const SizedBox(
                        height: 7,
                      ),

                      Text(
                        '₹${_formatAmount(payment['total'])}',
                        style:
                            const TextStyle(
                          fontSize: 32,
                          fontWeight:
                              FontWeight.w800,
                          color:
                              Color(0xFF172554),
                        ),
                      ),
                    ],
                  ),
                ),

                _statusBadge(
                  payment['status'] ??
                      'Unknown',
                ),
              ],
            ),

            const SizedBox(height: 20),

            _paymentRow(
              'Rent',
              '₹${_formatAmount(payment['rent'])}',
            ),

            const SizedBox(height: 10),

            _paymentRow(
              'Electricity',
              '₹${_formatAmount(payment['electricity'])}',
            ),

            if ((payment['paymentDate'] ??
                    '')
                .toString()
                .isNotEmpty) ...[
              const SizedBox(height: 10),

              _paymentRow(
                'Payment date',
                payment['paymentDate']
                    .toString(),
              ),
            ],
          ] else
            const Text(
              'No payment information available.',
              style: TextStyle(
                color:
                    Color(0xFF64748B),
              ),
            ),

          const SizedBox(height: 22),

          _orangeButton(
            label: 'UPDATE PAYMENT',
            icon: Icons.edit_outlined,
            onPressed:
                _showPaymentDialog,
          ),
        ],
      ),
    );
  }

  Widget _paymentRow(
    String title,
    String value,
  ) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color:
                Color(0xFF64748B),
          ),
        ),

        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight:
                FontWeight.w700,
            color:
                Color(0xFF334155),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // ELECTRICITY
  // ==========================================================

  Widget _electricityCard(
    List<Map<String, dynamic>>
        appliances,
  ) {
    return _card(
      title: 'ELECTRICITY',
      icon: Icons.bolt_outlined,
      child: Column(
        children: [
          if (appliances.isEmpty)
            const Align(
              alignment:
                  Alignment.centerLeft,
              child: Text(
                'No appliance information available.',
                style: TextStyle(
                  color:
                      Color(0xFF64748B),
                ),
              ),
            )
          else
            ...appliances.map(
              (appliance) =>
                  _applianceRow(
                appliance,
              ),
            ),

          const SizedBox(height: 12),

          _orangeButton(
            label: 'UPDATE STATUS',
            icon: Icons.edit_outlined,
            onPressed: () {
              _showElectricityDialog(
                appliances,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _applianceRow(
    Map<String, dynamic> appliance,
  ) {
    final name =
        appliance['name']
                ?.toString() ??
            'Unknown';

    final status =
        appliance['status']
                ?.toString() ??
            'Unknown';

    final note =
        appliance['note']
                ?.toString() ??
            '';

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 10,
      ),
      padding:
          const EdgeInsets.all(14),
      decoration: BoxDecoration(
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
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration:
                BoxDecoration(
              color:
                  const Color(0xFFEFF6FF),
              borderRadius:
                  BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.power_outlined,
              size: 20,
              color:
                  Color(0xFF2563EB),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style:
                      const TextStyle(
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w700,
                    color:
                        Color(0xFF334155),
                  ),
                ),

                if (note.isNotEmpty) ...[
                  const SizedBox(height: 4),

                  Text(
                    note,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style:
                        const TextStyle(
                      fontSize: 12,
                      color:
                          Color(0xFF64748B),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 8),

          _statusBadge(status),
        ],
      ),
    );
  }

  // ==========================================================
  // WATER
  // ==========================================================

  Widget _waterCard(
    Map<String, dynamic> water,
  ) {
    final status =
        water['status']
                ?.toString() ??
            'Unknown';

    final note =
        water['note']
                ?.toString() ??
            '';

    final updatedAt =
        water['updatedAt']
                ?.toString() ??
            '';

    return _card(
      title: 'WATER SUPPLY',
      icon:
          Icons.water_drop_outlined,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    _statusBadge(status),

                    if (updatedAt.isNotEmpty) ...[
                      const SizedBox(
                        height: 8,
                      ),

                      Text(
                        'Last updated: $updatedAt',
                        style:
                            const TextStyle(
                          fontSize: 12,
                          color:
                              Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          if (note.isNotEmpty) ...[
            const SizedBox(height: 14),

            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color:
                    const Color(0xFFF8FAFC),
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Text(
                note,
                style:
                    const TextStyle(
                  fontSize: 13,
                  color:
                      Color(0xFF475569),
                ),
              ),
            ),
          ],

          const SizedBox(height: 18),

          _orangeButton(
            label: 'UPDATE STATUS',
            icon: Icons.edit_outlined,
            onPressed: () {
              _showWaterDialog(water);
            },
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // COMMON CARD
  // ==========================================================

  Widget _card({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding:
          const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            blurRadius: 25,
            offset: Offset(0, 10),
            color: Color(0x25000000),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration:
                    BoxDecoration(
                  color:
                      const Color(0xFFF1F5F9),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 21,
                  color:
                      const Color(0xFF334155),
                ),
              ),

              const SizedBox(width: 11),

              Text(
                title,
                style:
                    const TextStyle(
                  fontSize: 15,
                  fontWeight:
                      FontWeight.w800,
                  letterSpacing: 0.4,
                  color:
                      Color(0xFF334155),
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

  // ==========================================================
  // ORANGE BUTTON
  // ==========================================================

  Widget _orangeButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 19,
        ),
        label: Text(
          label,
          style: const TextStyle(
            fontWeight:
                FontWeight.w800,
            letterSpacing: 0.2,
          ),
        ),
        style:
            ElevatedButton.styleFrom(
          backgroundColor:
              const Color(0xFFFF8A00),
          foregroundColor:
              Colors.white,
          elevation: 0,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // STATUS BADGE
  // ==========================================================

  Widget _statusBadge(
    String status,
  ) {
    Color background;
    Color foreground;
    IconData icon;

    switch (
        status.toLowerCase()) {
      case 'working':
      case 'normal':
      case 'paid':
        background =
            const Color(0xFFDCFCE7);
        foreground =
            const Color(0xFF15803D);
        icon =
            Icons.check_circle_outline;
        break;

      case 'under repair':
      case 'limited':
        background =
            const Color(0xFFFEF3C7);
        foreground =
            const Color(0xFFB45309);
        icon =
            Icons.build_outlined;
        break;

      case 'problem':
        background =
            const Color(0xFFFEE2E2);
        foreground =
            const Color(0xFFDC2626);
        icon =
            Icons.error_outline;
        break;

      default:
        background =
            const Color(0xFFF1F5F9);
        foreground =
            const Color(0xFF475569);
        icon =
            Icons.info_outline;
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius:
            BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: foreground,
          ),

          const SizedBox(width: 5),

          Text(
            status,
            style: TextStyle(
              color: foreground,
              fontSize: 11,
              fontWeight:
                  FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // PAYMENT DIALOG
  // ==========================================================

  void _showPaymentDialog() {
    final rentController =
        TextEditingController();

    final electricityController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title:
              const Text('Update Payment'),
          content: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              TextField(
                controller:
                    rentController,
                keyboardType:
                    TextInputType.number,
                decoration:
                    const InputDecoration(
                  labelText: 'Rent',
                  prefixText: '₹ ',
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller:
                    electricityController,
                keyboardType:
                    TextInputType.number,
                decoration:
                    const InputDecoration(
                  labelText:
                      'Electricity',
                  prefixText: '₹ ',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child:
                  const Text('CANCEL'),
            ),

            ElevatedButton(
              onPressed: () async {
                final rent =
                    double.tryParse(
                          rentController
                              .text,
                        ) ??
                        0;

                final electricity =
                    double.tryParse(
                          electricityController
                              .text,
                        ) ??
                        0;

                try {
                  await ApiService
                      .updatePayment(
                    month:
                        'September',
                    year: 2026,
                    rent: rent,
                    electricity:
                        electricity,
                    paymentDate:
                        '10 September 2026',
                    status: 'Paid',
                  );

                  if (!mounted) return;

                  Navigator.pop(
                    dialogContext,
                  );

                  await _reloadData();
                } catch (e) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Failed to update payment.',
                      ),
                    ),
                  );
                }
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(
                  0xFFFF8A00,
                ),
                foregroundColor:
                    Colors.white,
              ),
              child:
                  const Text('SAVE'),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // ELECTRICITY DIALOG
  // ==========================================================

  void _showElectricityDialog(
    List<Map<String, dynamic>>
        appliances,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return SimpleDialog(
          title: const Text(
            'Select Appliance',
          ),
          children: appliances.map(
            (appliance) {
              return SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(
                    dialogContext,
                  );

                  _editAppliance(
                    appliance,
                  );
                },
                child: Text(
                  appliance['name']
                          ?.toString() ??
                      'Unknown',
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
        appliance['status']
                ?.toString() ??
            'Working';

    final noteController =
        TextEditingController(
      text:
          appliance['note']?.toString() ??
              '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
            context,
            setDialogState,
          ) {
            return AlertDialog(
              title: Text(
                'Update ${appliance['name']}',
              ),
              content: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  DropdownButtonFormField<
                      String>(
                    value: selectedStatus,
                    decoration:
                        const InputDecoration(
                      labelText:
                          'Status',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Working',
                        child:
                            Text('Working'),
                      ),
                      DropdownMenuItem(
                        value:
                            'Under Repair',
                        child: Text(
                          'Under Repair',
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Problem',
                        child:
                            Text('Problem'),
                      ),
                    ],
                    onChanged:
                        (value) {
                      if (value !=
                          null) {
                        setDialogState(
                          () {
                            selectedStatus =
                                value;
                          },
                        );
                      }
                    },
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  TextField(
                    controller:
                        noteController,
                    maxLines: 3,
                    decoration:
                        const InputDecoration(
                      labelText: 'Note',
                      hintText:
                          'Optional',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child:
                      const Text('CANCEL'),
                ),

                ElevatedButton(
                  onPressed: () async {
                    try {
                      await ApiService
                          .updateElectricity(
                        name: appliance[
                            'name'],
                        status:
                            selectedStatus,
                        note:
                            noteController
                                .text,
                      );

                      if (!mounted)
                        return;

                      Navigator.pop(
                        dialogContext,
                      );

                      await _reloadData();
                    } catch (e) {
                      if (!mounted)
                        return;

                      ScaffoldMessenger
                          .of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Failed to update electricity status.',
                          ),
                        ),
                      );
                    }
                  },
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(
                      0xFFFF8A00,
                    ),
                    foregroundColor:
                        Colors.white,
                  ),
                  child:
                      const Text('SAVE'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ==========================================================
  // WATER DIALOG
  // ==========================================================

  void _showWaterDialog(
    Map<String, dynamic> water,
  ) {
    String selectedStatus =
        water['status']
                ?.toString() ??
            'Normal';

    final noteController =
        TextEditingController(
      text:
          water['note']?.toString() ??
              '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
            context,
            setDialogState,
          ) {
            return AlertDialog(
              title: const Text(
                'Update Water Supply',
              ),
              content: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  DropdownButtonFormField<
                      String>(
                    value: selectedStatus,
                    decoration:
                        const InputDecoration(
                      labelText:
                          'Status',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Normal',
                        child:
                            Text('Normal'),
                      ),
                      DropdownMenuItem(
                        value: 'Limited',
                        child:
                            Text('Limited'),
                      ),
                      DropdownMenuItem(
                        value: 'Problem',
                        child:
                            Text('Problem'),
                      ),
                    ],
                    onChanged:
                        (value) {
                      if (value !=
                          null) {
                        setDialogState(
                          () {
                            selectedStatus =
                                value;
                          },
                        );
                      }
                    },
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  TextField(
                    controller:
                        noteController,
                    maxLines: 3,
                    decoration:
                        const InputDecoration(
                      labelText: 'Note',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child:
                      const Text('CANCEL'),
                ),

                ElevatedButton(
                  onPressed: () async {
                    try {
                      await ApiService
                          .updateWater(
                        status:
                            selectedStatus,
                        note:
                            noteController
                                .text,
                      );

                      if (!mounted)
                        return;

                      Navigator.pop(
                        dialogContext,
                      );

                      await _reloadData();
                    } catch (e) {
                      if (!mounted)
                        return;

                      ScaffoldMessenger
                          .of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Failed to update water status.',
                          ),
                        ),
                      );
                    }
                  },
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(
                      0xFFFF8A00,
                    ),
                    foregroundColor:
                        Colors.white,
                  ),
                  child:
                      const Text('SAVE'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ==========================================================
  // RELOAD DATA
  // ==========================================================

  Future<void> _reloadData() async {
    if (reloading) return;

    setState(() {
      reloading = true;
    });

    try {
      final newData =
          await ApiService
              .getTenantDashboard();

      if (!mounted) return;

      setState(() {
        data = newData;
        reloading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Updated successfully',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        reloading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to refresh data.',
          ),
        ),
      );
    }
  }

  // ==========================================================
  // LOGOUT
  // ==========================================================

  Future<void> _logout() async {
    final shouldLogout =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title:
              const Text('Logout'),
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
              child:
                  const Text('CANCEL'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(
                  0xFFFF8A00,
                ),
                foregroundColor:
                    Colors.white,
              ),
              child:
                  const Text('LOGOUT'),
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

  // ==========================================================
  // HELPERS
  // ==========================================================

  String _formatAmount(
    dynamic amount,
  ) {
    if (amount == null) {
      return '0';
    }

    final value =
        double.tryParse(
              amount.toString(),
            ) ??
            0;

    if (value ==
        value.roundToDouble()) {
      return value
          .toInt()
          .toString();
    }

    return value.toStringAsFixed(2);
  }
}