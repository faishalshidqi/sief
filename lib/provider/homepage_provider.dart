import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sief_firebase/data/model/homepage_item.dart';
import 'package:sief_firebase/data/model/user_account.dart';
import 'package:sief_firebase/ui/inventory_report_page.dart';
import 'package:sief_firebase/ui/stocks_list_page.dart';
import 'package:sief_firebase/ui/suppliers_list_page.dart';
import 'package:sief_firebase/ui/users_list_page.dart';

class HomepageProvider extends ChangeNotifier {
  HomepageProvider();

  UserAccount? account;
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;
  List<HomepageItem> itemList = [
    HomepageItem(
      title: 'Kelola Supplier',
      icon: Icons.assistant,
      routeName: SuppliersListPage.routeName,
    ),
    HomepageItem(
      title: 'Kelola Stok',
      icon: Icons.storage,
      routeName: StocksListPage.routeName,
    ),
    HomepageItem(
      title: 'Laporan',
      icon: Icons.book_rounded,
      routeName: InventoryReportPage.routeName,
    ),
  ];

  void getAccount() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('accounts')
          .where('uid', isEqualTo: _auth.currentUser!.uid)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        if (userData['role'] == 'admin') {
          itemList = [
            HomepageItem(
              title: 'Kelola Pengguna',
              icon: Icons.person,
              routeName: UsersListPage.routeName,
            ),
            HomepageItem(
              title: 'Kelola Supplier',
              icon: Icons.assistant,
              routeName: SuppliersListPage.routeName,
            ),
            HomepageItem(
              title: 'Kelola Stok',
              icon: Icons.storage,
              routeName: StocksListPage.routeName,
            ),
            HomepageItem(
              title: 'Laporan',
              icon: Icons.book_rounded,
              routeName: InventoryReportPage.routeName,
            ),
          ];
          notifyListeners();
        }
        account = UserAccount(
          uid: userData['uid'],
          docId: userData['docId'],
          name: userData['name'],
          email: userData['email'],
          role: userData['role'],
          addedAt: userData['added_at'].toDate(),
          updatedAt: userData['updated_at'].toDate(),
        );
      } else {
        _auth.currentUser!.delete();
        _auth.signOut();
      }
    } catch (error) {
      rethrow;
    }
  }
}
