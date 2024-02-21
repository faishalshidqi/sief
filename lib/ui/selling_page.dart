import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sief_firebase/common/styles.dart';
import 'package:sief_firebase/components/custom_appbar.dart';
import 'package:sief_firebase/components/custom_floating_action_button.dart';
import 'package:sief_firebase/data/model/sale.dart';
import 'package:sief_firebase/data/model/stock.dart';
import 'package:sief_firebase/provider/selling_provider.dart';
import 'package:sief_firebase/ui/cart_page.dart';
import 'package:sief_firebase/ui/search_page.dart';

class SellingPage extends StatelessWidget {
  static const routeName = '/selling';
  static final _firestore = FirebaseFirestore.instance;
  final String? query;
  const SellingPage({super.key, this.query});

  @override
  Widget build(BuildContext context) {
    return Consumer<SellingProvider>(
      builder: (context, state, _) {
        return Scaffold(
          appBar: customAppBar(
            title: 'Penjualan',
            actions: [
              IconButton(
                onPressed: () async {
                  Navigator.pushNamed(
                    context,
                    SearchPage.routeName,
                    arguments: routeName,
                  );
                },
                icon: const Icon(Icons.search),
              ),
            ],
          ),
          floatingActionButton: customFloatingActionButton(
            context: context,
            text: 'Keranjang',
            icon: CupertinoIcons.cart,
            routeName: CartPage.routeName,
          ),
          body: SafeArea(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: query == null
                  ? _firestore.collection('stocks').snapshots()
                  : _firestore
                      .collection('stocks')
                      .where('name', isEqualTo: query)
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
                    child: Text('Tidak ada data furnitur'),
                  );
                }
                return ListView.builder(
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
                    final int amount = stock.amount;
                    final String imageUrl = stock.imageUrl;
                    final int price = stock.price;
                    final String supplier = stock.supplier;

                    return ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      leading: imageUrl == ''
                          ? Image.asset(
                              'assets/istock-default.jpg',
                              width: 100,
                            )
                          : CachedNetworkImage(
                              imageUrl: imageUrl,
                              width: 100,
                            ),
                      title: Text(
                        name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Text(
                        'Stok:\t $amount',
                      ),
                      onTap: () {
                        state.updateSale(
                          Sale(
                            name: name,
                            currentAmount: amount,
                            outingAmount: 1,
                            docId: docId,
                            price: price,
                            supplier: supplier,
                          ),
                        );
                        state.addToCart();
                      },
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
