import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sief_firebase/common/styles.dart';
import 'package:sief_firebase/components/custom_appbar.dart';
import 'package:sief_firebase/components/custom_floating_action_button.dart';
import 'package:sief_firebase/ui/user_form_page.dart';

class UsersListPage extends StatelessWidget {
  static const routeName = '/users';
  static final _firestore = FirebaseFirestore.instance;
  const UsersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Daftar Pengguna'),
      floatingActionButton: customFloatingActionButton(
          context: context,
          text: 'Tambah Pengguna',
          icon: Icons.add,
          routeName: UserFormPage.routeName,),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _firestore.collection('accounts').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            } else if (snapshot.data!.size == 0 || snapshot.data == null) {
              return const Center(
                child: Text('Tidak ada data pengguna'),
              );
            }
            return ListView(
              children: snapshot.data!.docs.map((document) {
                final String username = document.data()['name'];
                final String email = document.data()['email'];
                final String role = document.data()['role'];
                final String uid = document.data()['uid'];
                final String docId = document.data()['docId'];

                return Dismissible(
                  key: Key(uid),
                  background: Container(color: Colors.red, child: const Icon(CupertinoIcons.trash),),
                  onDismissed: (direction) {
                    _firestore.collection('accounts').doc(docId).delete();
                  },
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    title: Text(
                      username,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      '$email, ($role)',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
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
