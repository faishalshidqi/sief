import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sief_firebase/common/styles.dart';
import 'package:sief_firebase/common/validators.dart';
import 'package:sief_firebase/components/custom_appbar.dart';
import 'package:sief_firebase/components/custom_coming_soon_dialog.dart';
import 'package:sief_firebase/components/input_layout.dart';
import 'package:sief_firebase/provider/users_provider.dart';

class UserFormPage extends StatelessWidget {
  static const routeName = '/user_form';
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;
  static final _formKey = GlobalKey<FormState>();
  const UserFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Form Pengguna'),
      body: SafeArea(
        child: Consumer<UsersProvider>(
          builder: (context, state, _) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          InputLayout(
                            'Nama',
                            TextFormField(
                              decoration:
                                  customInputDecoration('Nama Pengguna'),
                              onChanged: (String value) {
                                state.updateUsername(value);
                              },
                              keyboardType: TextInputType.name,
                              validator: validateNotEmpty,
                            ),
                          ),
                          InputLayout(
                            'Email',
                            TextFormField(
                              decoration: customInputDecoration('Alamat Email'),
                              onChanged: (String value) {
                                state.updateEmail(value);
                              },
                              keyboardType: TextInputType.emailAddress,
                              validator: validateNotEmpty,
                            ),
                          ),
                          InputLayout(
                            'Peran',
                            DropdownButtonFormField(
                              decoration:
                                  customInputDecoration('Peran Pengguna'),
                              validator: validateNotEmpty,
                              items: state.roles.map((role) {
                                return DropdownMenuItem(
                                  value: role,
                                  child: Text(role),
                                );
                              }).toList(),
                              onChanged: (selected) =>
                                  state.updateRole(selected!),
                            ),
                          ),
                          InputLayout(
                            'Kata Sandi',
                            TextFormField(
                              decoration: customInputDecoration('Kata Sandi'),
                              onChanged: (String value) {
                                state.updatePassword(value);
                              },
                              validator: validateNotEmpty,
                            ),
                          ),
                          InputLayout(
                            'Ulangi Kata Sandi',
                            TextFormField(
                              decoration:
                                  customInputDecoration('Ulangi Kata Sandi'),
                              onChanged: (String value) {
                                state.updateRepeatPassword(value);
                              },
                              validator: (String? value) {
                                if (state.password != value) {
                                  return 'Kata Sandi Tidak Sama';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 20),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor100,
                              ),
                              child: Text(
                                'Tambah',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    CollectionReference accountCollection =
                                        _firestore.collection('accounts');

                                    await _auth.createUserWithEmailAndPassword(
                                      email: state.email!,
                                      password: state.password!,
                                    );
                                    Timestamp timestamp =
                                        Timestamp.fromDate(DateTime.now());
                                    final docId = accountCollection.doc().id;

                                    await accountCollection.doc(docId).set({
                                      'uid': _auth.currentUser!.uid,
                                      'name': state.username,
                                      'email': state.email,
                                      'docId': docId,
                                      'role': state.role,
                                      'added_at': timestamp,
                                      'updated_at': timestamp,
                                    });
                                    if (!context.mounted) return;
                                    customInfoDialog(
                                      context: context,
                                      title: 'Berhasil!',
                                      content:
                                          'Data Pengguna Berhasil Ditambahkan',
                                    );
                                  } catch (error) {
                                    customInfoDialog(
                                      context: context,
                                      title: 'Error!',
                                      content: error.toString(),
                                    );
                                  } finally {
                                    _formKey.currentState!.reset();
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
