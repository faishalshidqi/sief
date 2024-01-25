import 'package:flutter/material.dart';
import 'package:sief_firebase/components/custom_appbar.dart';

class InventoryReportPage extends StatelessWidget {
  static const routeName = 'reports';
  const InventoryReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Laporan Inventaris'),
      body: const SafeArea(
        child: Center(
          child: Text('Halaman Laporan Inventaris'),
        ),
      ),
    );
  }
}
