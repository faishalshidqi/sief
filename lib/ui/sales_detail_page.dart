import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sief_firebase/common/styles.dart';
import 'package:sief_firebase/components/custom_appbar.dart';

class SalesHistoryDetailPage extends StatelessWidget {
  static const routeName = '/sales_history';
  static final _firestore = FirebaseFirestore.instance;
  final String docId;
  const SalesHistoryDetailPage({super.key, required this.docId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Riwayat Stok'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder(
            stream: _firestore
                .collection('stocks')
                .where('docId', isEqualTo: docId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor500,
                  ),
                );
              } else if (snapshot.data!.size == 0 || snapshot.data == null) {
                return const Center(
                  child: Text('Data stok tidak ditemukan'),
                );
              }
              final data = snapshot.data!.docs.first;
              return Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Table(
                      columnWidths: const {
                        1: FractionColumnWidth(0.55),
                      },
                      children: [
                        TableRow(
                          children: [
                            Text(
                              'Nama Furnitur\n',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              data['name'],
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(
                              'Jumlah Stok\n',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              data['amount'].toString(),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(
                              'Harga Stok\n',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              data['price'].toString(),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(
                              'Disuplai oleh\n',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              data['supplier'].toString().split(',')[0],
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(
                              'Ditambahkan pada\n',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              DateFormat('dd MMM yyyy').format(
                                data['added_at'].toDate(),
                              ),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(
                              'Diperbarui pada\n',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              DateFormat('dd MMM yyyy').format(
                                data['updated_at'].toDate(),
                              ),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(
                              'Riwayat Stok',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            StreamBuilder(
                              stream: _firestore
                                  .collection('sales')
                                  .where('furnitureId', isEqualTo: docId)
                                  .orderBy('added_at')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator(
                                    color: primaryColor100,
                                  );
                                } else if (snapshot.data!.size == 0 ||
                                    snapshot.data == null) {
                                  return const ListTile(
                                    title: Text('No Data'),
                                  );
                                }
                                return Column(
                                  children: snapshot.data!.docs.map((document) {
                                    final data = document.data();
                                    final date = data['added_at'].toDate();
                                    int amount = data['amount'];
                                    return ListTile(
                                      subtitle: Text(
                                        DateFormat('dd MMMM yyyy').format(date),
                                      ),
                                      title: Row(
                                        children: [
                                          Text(
                                            'Terjual: ${amount.toString()}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
