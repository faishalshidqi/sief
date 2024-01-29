import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sief_firebase/common/styles.dart';
import 'package:sief_firebase/common/validators.dart';
import 'package:sief_firebase/components/custom_appbar.dart';
import 'package:sief_firebase/components/custom_coming_soon_dialog.dart';
import 'package:sief_firebase/components/input_layout.dart';
import 'package:sief_firebase/data/model/supplier.dart';
import 'package:sief_firebase/provider/supplier_detail_provider.dart';

class SupplierDetailPage extends StatelessWidget {
  static const routeName = '/supplier_detail';
  static final _firestore = FirebaseFirestore.instance;
  static final _formKey = GlobalKey<FormState>();
  final Supplier supplier;
  const SupplierDetailPage({super.key, required this.supplier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Detail Supplier'),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _firestore
              .collection('suppliers')
              .where('docId', isEqualTo: supplier.docId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            } else if (snapshot.data == null) {
              return const Center(child: Text('Mohon Tunggu...'));
            }
            final data = snapshot.data!.docs.first;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Consumer<SupplierDetailProvider>(
                  builder: (context, state, _) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Mode Sunting',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Switch.adaptive(
                              value: state.isEditMode,
                              activeColor: primaryColor,
                              onChanged: (bool value) async {
                                state.updateEditMode(value);
                                state.updateName(data['name']);
                                state.updatePhone(data['phone']);
                                state.updateAddress(data['address']);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        state.isEditMode
                            ? Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      InputLayout(
                                        'Nama Supplier',
                                        TextFormField(
                                          decoration: customInputDecoration(
                                            'Nama',
                                          ),
                                          onChanged: (String value) {
                                            state.updateName(value);
                                          },
                                          keyboardType: TextInputType.name,
                                          validator: validateNotEmpty,
                                          initialValue: data['name'],
                                          autofocus: true,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                              50,
                                            ),
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
                                          initialValue: data['phone'],
                                          autofocus: true,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                              13,
                                            ),
                                            FilteringTextInputFormatter
                                                .singleLineFormatter,
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                        ),
                                      ),
                                      InputLayout(
                                        'Alamat Supplier',
                                        TextFormField(
                                          decoration: customInputDecoration(
                                            'Alamat',
                                          ),
                                          onChanged: (String value) {
                                            state.updateAddress(value);
                                          },
                                          keyboardType: TextInputType.multiline,
                                          validator: validateNotEmpty,
                                          initialValue: data['address'],
                                          autofocus: true,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                              50,
                                            ),
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
                                            'Perbarui',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall,
                                          ),
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              try {
                                                CollectionReference
                                                    supplierCollection =
                                                    _firestore.collection(
                                                  'suppliers',
                                                );
                                                Timestamp timestamp =
                                                    Timestamp.fromDate(
                                                  DateTime.now(),
                                                );
                                                await supplierCollection
                                                    .doc(data['docId'])
                                                    .update({
                                                  'name': state.name,
                                                  'phone': state.phone,
                                                  'address': state.address,
                                                  'updated_at': timestamp,
                                                });
                                                state.updateEditMode(false);
                                                if (!context.mounted) return;
                                                customInfoDialog(
                                                  context: context,
                                                  title: 'Berhasil!',
                                                  content:
                                                      'Data Supplier Berhasil Diperbarui',
                                                );
                                              } catch (error) {
                                                customInfoDialog(
                                                  context: context,
                                                  title: 'Error!',
                                                  content: error.toString(),
                                                );
                                              } finally {
                                                state.name = null;
                                                state.phone = null;
                                                state.address = null;
                                                state.isEditMode = false;
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Column(
                                children: [
                                  Table(
                                    columnWidths: const {
                                      1: FractionColumnWidth(0.55),
                                    },
                                    children: [
                                      TableRow(
                                        children: [
                                          Text(
                                            'Nama Supplier\n',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                          Text(
                                            data['name'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Text(
                                            'Nomor Telepon\n',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                          Text(
                                            data['phone'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Text(
                                            'Alamat\n',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                          Text(
                                            data['address'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Text(
                                            'Ditambahkan Pada\n',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                          Text(
                                            DateFormat('dd MMM yyyy').format(
                                              data['added_at'].toDate(),
                                            ),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Text(
                                            'Diperbarui Pada\n',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                          Text(
                                            DateFormat('dd MMM yyyy').format(
                                              data['updated_at'].toDate(),
                                            ),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
