import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sief_firebase/common/navigation.dart';
import 'package:sief_firebase/common/styles.dart';
import 'package:sief_firebase/components/custom_appbar.dart';
import 'package:sief_firebase/components/custom_floating_action_button.dart';
import 'package:sief_firebase/data/model/stock.dart';
import 'package:sief_firebase/ui/stock_detail_page.dart';
import 'package:sief_firebase/ui/stock_form_page.dart';

class StocksListPage extends StatelessWidget {
  static const routeName = '/stocks';
  static final _firestore = FirebaseFirestore.instance;
  const StocksListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Daftar Stok'),
      floatingActionButton: customFloatingActionButton(
        context: context,
        text: 'Tambah Stok',
        icon: Icons.add,
        routeName: StockFormPage.routeName,
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _firestore.collection('stocks').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            } else if (snapshot.data!.size == 0 || snapshot.data == null) {
              return const Center(
                child: Text('Tidak ada data stok'),
              );
            }
            return ListView(
              children: snapshot.data!.docs.map((document) {
                final data = document.data();
                final Stock stock = Stock(name: data['name'], amount: data['amount'], docId: data['docId'], price: data['price'], imageUrl: data['imageUrl'], supplier: data['supplier'], uid: data['uid'], addedAt: data['added_at'].toDate(), updatedAt: data['updated_at'].toDate(),);
                final String docId = stock.docId;
                final String name = stock.name;
                final String imageUrl = stock.imageUrl;

                return Dismissible(
                  key: Key(docId),
                  background: Container(
                    color: Colors.red,
                    child: const Icon(CupertinoIcons.trash),
                  ),
                  onDismissed: (direction) {
                    _firestore.collection('stocks').doc(docId).delete();
                  },
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: Hero(
                      tag: docId,
                      child: imageUrl == '' ? Image.asset('assets/istock-default.jpg', width: 100,) : CachedNetworkImage(imageUrl: imageUrl, width: 100,),
                    ),
                    title: Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    onTap: () {
                      Navigation.intentWithData(routeName: StockDetailPage.routeName, arguments: data);
                    },
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
