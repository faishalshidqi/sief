import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sief_firebase/common/styles.dart';
import 'package:sief_firebase/components/custom_appbar.dart';
import 'package:sief_firebase/data/model/sale.dart';
import 'package:sief_firebase/provider/selling_provider.dart';

class CartPage extends StatelessWidget {
  static const routeName = '/cart';
  static final _firestore = FirebaseFirestore.instance;
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SellingProvider>(
      builder: (context, state, _) {
        return Scaffold(
          appBar: customAppBar(
            title: 'Keranjang',
            actions: [
              IconButton(
                onPressed: () {
                  state.clearCart();
                },
                icon: const Icon(CupertinoIcons.trash),
              ),
            ],
          ),
          floatingActionButton: Visibility(
            visible: state.cartContent.isNotEmpty,
            child: FloatingActionButton.extended(
              onPressed: () {
                state.addSales();
              },
              backgroundColor: primaryColor100,
              label: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Tambah',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              icon: const Icon(Icons.add),
            ),
          ),
          body: SafeArea(
            child: state.cartContent.isEmpty
                ? const Center(
                    child: Text('Keranjang Kosong'),
                  )
                : ListView.builder(
                    itemCount: state.cartContent.length,
                    itemBuilder: (BuildContext context, int index) {
                      var sale = Sale(
                        name: state.cartContent[index].name,
                        currentAmount: state.cartContent[index].currentAmount,
                        outingAmount: state.cartContent[index].outingAmount,
                        docId: state.cartContent[index].docId,
                        price: state.cartContent[index].price,
                        supplier: state.cartContent[index].supplier,
                      );
                      return Dismissible(
                        key: Key(sale.docId),
                        background: Container(
                          color: Colors.red,
                          child: const Icon(CupertinoIcons.trash),
                        ),
                        onDismissed: (direction) {
                          state.removeFromCart(sale, sale.docId);
                        },
                        child: StreamBuilder(
                          stream: _firestore
                              .collection('stocks')
                              .where('docId', isEqualTo: sale.docId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              );
                            }
                            final amount =
                                snapshot.data!.docs.first.data()['amount'];
                            sale.currentAmount = amount;
                            return ListTile(
                              contentPadding: const EdgeInsets.all(10),
                              subtitle: Row(
                                children: [
                                  Text(
                                    '${sale.outingAmount.toString()} ($amount',
                                  ),
                                  const Icon(Icons.arrow_forward),
                                  Text(
                                    '${amount - sale.outingAmount})',
                                  ),
                                ],
                              ),
                              title: Text(
                                '${sale.name}, (Rp. ${sale.price})',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              leading: IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  state
                                      .subtractAmount(state.cartContent[index]);
                                },
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  state.addAmount(state.cartContent[index]);
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
