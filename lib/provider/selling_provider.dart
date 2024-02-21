import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sief_firebase/data/model/sale.dart';

class SellingProvider extends ChangeNotifier {
  static final _firestore = FirebaseFirestore.instance;
  SellingProvider();

  List<Sale> cartContent = [];
  String searchQuery = '';
  int? outingAmount;
  Map? cnt;
  Sale? sale;

  void updateSearchQuery(String value) {
    searchQuery = value;
    notifyListeners();
  }

  void addAmount(Sale value) {
    value.outingAmount++;
    notifyListeners();
  }

  void subtractAmount(Sale value) {
    value.outingAmount--;
    notifyListeners();
  }

  void updateSale(Sale value) {
    sale = value;
    notifyListeners();
  }

  void updateOutingAmount(String amount) {
    sale!.outingAmount = int.parse(amount);
    notifyListeners();
  }

  void addToCart() async {
    cartContent.add(sale!);
  }

  void clearCart() {
    cartContent.clear();
    notifyListeners();
  }

  void removeFromCart(Sale sale, String docId) {
    cartContent.removeWhere((sale) => sale.docId == docId);
    notifyListeners();
  }

  void addSales() async {
    try {
      CollectionReference salesCollection = _firestore.collection('sales');
      CollectionReference stocksCollection = _firestore.collection('stocks');
      CollectionReference reportsCollection = _firestore.collection('reports');

      Timestamp timestamp = Timestamp.fromDate(DateTime.now());

      for (final content in cartContent) {
        final id = salesCollection.doc().id;
        await salesCollection.doc(id).set({
          'name': content.name,
          'supplier': content.supplier,
          'price': content.price,
          'amount': content.outingAmount,
          'saleId': id,
          'furnitureId': content.docId,
          'added_at': timestamp,
        });

        await stocksCollection.doc(content.docId).update({
          'amount': content.currentAmount - content.outingAmount,
          'updated_at': timestamp,
        });

        await reportsCollection.doc().set({
          'docId': content.docId,
          'type': 'STOCK-TERJUAL',
          'name': content.name,
          'amount': content.currentAmount - content.outingAmount,
          'delta_stock': -1 * content.outingAmount,
          'price': content.price,
          'added_at': timestamp,
        });
      }
    } catch (error) {
      rethrow;
    } finally {
      clearCart();
    }
  }
}
