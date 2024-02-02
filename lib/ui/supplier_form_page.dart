import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sief_firebase/common/styles.dart';
import 'package:sief_firebase/common/validators.dart';
import 'package:sief_firebase/components/custom_appbar.dart';
import 'package:sief_firebase/components/custom_coming_soon_dialog.dart';
import 'package:sief_firebase/components/input_layout.dart';
import 'package:sief_firebase/provider/suppliers_provider.dart';

class SupplierFormPage extends StatelessWidget {
  static const routeName = '/supplier_form';
  static final _formKey = GlobalKey<FormState>();
  static final _firestore = FirebaseFirestore.instance;
  const SupplierFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Daftar Supplier'),
      body: SafeArea(
        child: Consumer<SuppliersProvider>(
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
                            'Nama Supplier',
                            TextFormField(
                              decoration: customInputDecoration('Nama'),
                              onChanged: (String value) {
                                state.updateName(value);
                              },
                              keyboardType: TextInputType.name,
                              validator: validateNotEmpty,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50),
                              ],
                            ),
                          ),
                          InputLayout(
                            'Nomor Telepon Supplier',
                            TextFormField(
                              decoration: customInputDecoration(
                                'Nomor Telepon',
                              ),
                              onChanged: (String value) {
                                state.updatePhone(value);
                              },
                              keyboardType: TextInputType.phone,
                              validator: validateNotEmpty,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(13),
                                FilteringTextInputFormatter.singleLineFormatter,
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                          InputLayout(
                            'Alamat Supplier',
                            TextFormField(
                              decoration: customInputDecoration('Alamat'),
                              onChanged: (String value) {
                                state.updateAddress(value);
                              },
                              keyboardType: TextInputType.streetAddress,
                              validator: validateNotEmpty,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50),
                              ],
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
                                    CollectionReference supplierCollection =
                                        _firestore.collection('suppliers');

                                    final docId = supplierCollection.doc().id;

                                    Timestamp timestamp =
                                        Timestamp.fromDate(DateTime.now());
                                    await supplierCollection.doc(docId).set({
                                      'docId': docId,
                                      'name': state.name,
                                      'phone': state.phone,
                                      'address': state.address,
                                      'added_at': timestamp,
                                      'updated_at': timestamp,
                                    });
                                    if (!context.mounted) return;
                                    customInfoDialog(
                                      context: context,
                                      title: 'Berhasil!',
                                      content:
                                          'Data Supplier Berhasil Ditambahkan',
                                    );
                                  } catch (error) {
                                    customInfoDialog(
                                      context: context,
                                      title: 'Error!',
                                      content: error.toString(),
                                    );
                                  }
                                  finally {
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
