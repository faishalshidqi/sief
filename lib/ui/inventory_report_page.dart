import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sief_firebase/common/styles.dart';
import 'package:sief_firebase/components/custom_appbar.dart';
import 'package:sief_firebase/provider/report_provider.dart';

class InventoryReportPage extends StatelessWidget {
  static const routeName = '/reports';
  static final _firestore = FirebaseFirestore.instance;
  const InventoryReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Laporan Inventaris'),
      body: SafeArea(
        child: StreamBuilder(
          stream: _firestore.collectionGroup('reports').snapshots(),
          builder: (context, snapshot) {
            return Consumer<ReportProvider>(
              builder: (context, state, _) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  );
                }
                else if (snapshot.data == null || snapshot.data!.size == 0) {
                  return const Center(
                    child: Text(
                      'Tidak Ada Data Laporan',
                    ),
                  );
                }
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: snapshot.data!.docs.map((document) {
                        final data = document.data();
                        final name = data['name'];
                        return ListTile(
                          title: Text(name),
                        );
                      }).toList(),
                      /*[
                        DropdownButton(
                          items: snapshot.data!.docs.map((document) {
                            final data = document
                                .data();
                            print('data: ${data.entries}');
                            return DropdownMenuItem(child: Text(data.entries.toString()));
                          }).toList(),
                          onChanged: (selected) {
                            state.updatePeriod(selected ?? '');
                          },
                        ),
                      ],*/
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
