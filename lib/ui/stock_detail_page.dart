// ignore_for_file: require_trailing_commas

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sief_firebase/common/styles.dart';
import 'package:sief_firebase/components/custom_appbar.dart';
import 'package:sief_firebase/provider/stock_detail_provider.dart';

class StockDetailPage extends StatelessWidget {
  static const routeName = '/stock_detail';
  static final _firestore = FirebaseFirestore.instance;
  final Map<String, dynamic> stock;
  const StockDetailPage({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Detail Stok'),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _firestore.collection('stocks').where('docId', isEqualTo: stock['docId']).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }
            else if (snapshot.data == null) {
              return const Center(
                child: Text('Mohon Tunggu...'),
              );
            }
            final data = snapshot.data!.docs.first;
            return Consumer<StockDetailProvider>(
              builder: (context, state, _) {
                return SingleChildScrollView(
                  child: Hero(
                    tag: data['docId'],
                    child: const Column(
                      children: [],
                    ),
                  ),
                );
              }
            );
          },
        ),
      ),
    );
  }
}
