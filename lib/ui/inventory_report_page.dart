import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sief_firebase/common/styles.dart';
import 'package:sief_firebase/components/custom_appbar.dart';
import 'package:sief_firebase/components/input_layout.dart';
import 'package:sief_firebase/provider/report_provider.dart';

class InventoryReportPage extends StatelessWidget {
  static const routeName = '/reports';
  static final _firestore = FirebaseFirestore.instance;
  const InventoryReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportProvider>(
      builder: (context, state, _) {
        return Scaffold(
          appBar: customAppBar(
            title: 'Laporan Inventaris',
            actions: state.isSortInc
                ? [
                    IconButton(
                      onPressed: () {
                        state.updateSortInc(false);
                      },
                      icon: const Icon(Icons.arrow_downward),
                    ),
                  ]
                : [
                    IconButton(
                      onPressed: () {
                        state.updateSortInc(true);
                      },
                      icon: const Icon(Icons.arrow_upward),
                    ),
                  ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      DropdownDatePicker(
                        inputDecoration: customInputDecoration(''),
                        selectedDay: state.day,
                        selectedMonth: state.month,
                        selectedYear: state.year,
                        startYear: 2024,
                        onChangedDay: (value) {
                          state.updateDay(
                            int.parse(
                              value ?? DateTime.now().day.toString(),
                            ),
                          );
                        },
                        onChangedMonth: (value) {
                          state.updateMonth(
                            int.parse(
                              value ?? DateTime.now().month.toString(),
                            ),
                          );
                        },
                        onChangedYear: (value) {
                          state.updateYear(
                            int.parse(
                              value ?? DateTime.now().year.toString(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                StreamBuilder(
                  stream: _firestore
                      .collectionGroup('reports')
                      .where(
                        'added_at',
                        isGreaterThanOrEqualTo: DateTime(
                          state.year ?? DateTime.now().year,
                          state.month ?? DateTime.now().month,
                          state.day ?? DateTime.now().day,
                        ),
                      )
                      .orderBy('added_at', descending: !state.isSortInc)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else if (snapshot.data == null ||
                        snapshot.data!.size == 0) {
                      return const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Tidak Ada Data Laporan',
                        ),
                      );
                    }
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: snapshot.data!.docs.map((document) {
                            final data = document.data();
                            final name = data['name'];
                            final date = data['added_at'].toDate();
                            final delta = data['delta_stock'];
                            return ListTile(
                              leading: delta < 0
                                  ? const Icon(
                                      Icons.remove_circle,
                                      color: secondaryColor,
                                      size: 30,
                                    )
                                  : const Icon(
                                      Icons.add_box,
                                      color: primaryColor,
                                      size: 30,
                                    ),
                              title: Text(name),
                              subtitle: Text(
                                DateFormat('dd MMMM yyyy HH:mm:ss')
                                    .format(date),
                              ),
                              trailing: Text(
                                delta.toString(),
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
