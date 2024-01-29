import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sief_firebase/common/navigation.dart';
import 'package:sief_firebase/common/styles.dart';
import 'package:sief_firebase/components/custom_appbar.dart';
import 'package:sief_firebase/components/custom_coming_soon_dialog.dart';
import 'package:sief_firebase/components/custom_floating_action_button.dart';
import 'package:sief_firebase/data/model/stock.dart';
import 'package:sief_firebase/provider/stocks_provider.dart';
import 'package:sief_firebase/ui/stock_detail_page.dart';
import 'package:sief_firebase/ui/stock_form_page.dart';

class StocksListPage extends StatelessWidget {
  static const routeName = '/stocks';
  static final _firestore = FirebaseFirestore.instance;
  static final _storage = FirebaseStorage.instance;
  const StocksListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StocksProvider>(
      builder: (context, state, _) {
        return Scaffold(
          appBar: customAppBar(
            title: 'Daftar Stok',
            actions: state.isGridView
                ? [
                    IconButton(
                      onPressed: () {
                        state.updateIsGridView(false);
                      },
                      icon: const Icon(Icons.list),
                    ),
                  ]
                : [
                    IconButton(
                      onPressed: () {
                        state.updateIsGridView(true);
                      },
                      icon: const Icon(Icons.grid_view_rounded),
                    ),
                  ],
          ),
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
                      color: primaryColor500,
                    ),
                  );
                } else if (snapshot.data!.size == 0 || snapshot.data == null) {
                  return const Center(
                    child: Text('Tidak ada data stok'),
                  );
                }
                return state.isGridView
                    ? GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 5,
                        children: snapshot.data!.docs.map((document) {
                          final data = document.data();
                          final Stock stock = Stock(
                            name: data['name'],
                            amount: data['amount'],
                            docId: data['docId'],
                            price: data['price'],
                            imageUrl: data['imageUrl'],
                            supplier: data['supplier'],
                            uid: data['uid'],
                            addedAt: data['added_at'].toDate(),
                            updatedAt: data['updated_at'].toDate(),
                          );
                          final String docId = stock.docId;
                          final String name = stock.name;
                          final String amount = stock.amount.toString();
                          final String imageUrl = stock.imageUrl;

                          return InkWell(
                            key: Key(docId),
                            onTap: () {
                              Navigation.intentWithData(
                                routeName: StockDetailPage.routeName,
                                arguments: stock,
                              );
                            },
                            onLongPress: () {
                              customInfoDialog(
                                context: context,
                                title: 'Hapus Stok Ini?',
                                content: '',
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      if (imageUrl != '') {
                                        _storage.refFromURL(imageUrl).delete();
                                      }
                                      _firestore
                                          .collection('stocks')
                                          .doc(docId)
                                          .delete();
                                    },
                                    child: const Text('Ya'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigation.back(),
                                    child: const Text('Batal'),
                                  ),
                                ],
                              );
                            },
                            child: Card(
                              child: Column(
                                children: [
                                  imageUrl != ''
                                      ? CachedNetworkImage(
                                          imageUrl: imageUrl,
                                          width: 130,
                                          height: 130,
                                        )
                                      : Image.asset(
                                          'assets/istock-default.jpg',
                                          width: 130,
                                          height: 130,
                                        ),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 18,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(13),
                                            ),
                                            border: Border.all(),
                                          ),
                                          alignment: Alignment.center,
                                          child: Center(
                                            child: Text(
                                              name,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 18,
                                          ),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(13),
                                            ),
                                            border: Border(
                                              top: BorderSide(),
                                              bottom: BorderSide(),
                                              right: BorderSide(),
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Stok: $amount',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      )
                    : ListView.builder(
                        itemCount: snapshot.data!.size,
                        itemBuilder: (context, index) {
                          var data = snapshot.data!.docs[index];
                          final Stock stock = Stock(
                            name: data['name'],
                            amount: data['amount'],
                            docId: data['docId'],
                            price: data['price'],
                            imageUrl: data['imageUrl'],
                            supplier: data['supplier'],
                            uid: data['uid'],
                            addedAt: data['added_at'].toDate(),
                            updatedAt: data['updated_at'].toDate(),
                          );
                          final String docId = stock.docId;
                          final String name = stock.name;
                          final String amount = stock.amount.toString();
                          final String imageUrl = stock.imageUrl;
                          return Dismissible(
                            key: Key(docId),
                            background: Container(
                              color: Colors.red,
                              child: const Icon(CupertinoIcons.trash),
                            ),
                            onDismissed: (direction) {
                              if (imageUrl != '') {
                                _storage.refFromURL(imageUrl).delete();
                              }
                              _firestore
                                  .collection('stocks')
                                  .doc(docId)
                                  .delete();
                            },
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(10),
                              leading: Hero(
                                tag: docId,
                                child: imageUrl == ''
                                    ? Image.asset(
                                        'assets/istock-default.jpg',
                                        width: 100,
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: imageUrl,
                                        width: 100,
                                      ),
                              ),
                              title: Text(
                                name,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              subtitle: Text(
                                'Stok:\t $amount',
                              ),
                              onTap: () {
                                Navigation.intentWithData(
                                  routeName: StockDetailPage.routeName,
                                  arguments: stock,
                                );
                              },
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        );
      },
    );
  }
}
