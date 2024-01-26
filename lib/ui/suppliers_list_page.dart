import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sief_firebase/common/navigation.dart';
import 'package:sief_firebase/common/styles.dart';
import 'package:sief_firebase/components/custom_appbar.dart';
import 'package:sief_firebase/components/custom_floating_action_button.dart';
import 'package:sief_firebase/data/model/supplier.dart';
import 'package:sief_firebase/ui/supplier_detail_page.dart';
import 'package:sief_firebase/ui/supplier_form_page.dart';

class SuppliersListPage extends StatelessWidget {
  static const routeName = '/suppliers';
  static final _firestore = FirebaseFirestore.instance;
  const SuppliersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Daftar Supplier'),
      floatingActionButton: customFloatingActionButton(
        context: context,
        text: 'Tambah Supplier',
        icon: Icons.add,
        routeName: SupplierFormPage.routeName,
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _firestore.collection('suppliers').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            } else if (snapshot.data!.size == 0 || snapshot.data == null) {
              return const Center(
                child: Text('Tidak ada data supplier'),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index];
                final Supplier supplier = Supplier(
                  name: data['name'],
                  phone: data['phone'],
                  docId: data['docId'],
                  address: data['address'],
                  addedAt: data['added_at'].toDate(),
                  updatedAt: data['updated_at'].toDate(),
                );
                final String name = supplier.name;
                final String phone = supplier.phone;
                final String docId = supplier.docId;
                return Dismissible(
                  key: Key(docId),
                  background: Container(
                    color: Colors.red,
                    child: const Icon(CupertinoIcons.trash),
                  ),
                  onDismissed: (direction) {
                    _firestore.collection('suppliers').doc(docId).delete();
                  },
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    title: Text(
                      name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Text(
                      phone,
                    ),
                    onTap: () {
                      Navigation.intentWithData(
                        routeName: SupplierDetailPage.routeName,
                        arguments: supplier,
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
  }
}
