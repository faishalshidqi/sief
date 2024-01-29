import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sief_firebase/common/navigation.dart';
import 'package:sief_firebase/common/styles.dart';
import 'package:sief_firebase/common/validators.dart';
import 'package:sief_firebase/components/custom_appbar.dart';
import 'package:sief_firebase/components/custom_coming_soon_dialog.dart';
import 'package:sief_firebase/components/input_layout.dart';
import 'package:sief_firebase/provider/stocks_provider.dart';

class StockFormPage extends StatelessWidget {
  static const routeName = '/stock_form';
  static final _formKey = GlobalKey<FormState>();
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;
  const StockFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Form Stok'),
      body: SafeArea(
        child: Consumer<StocksProvider>(
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
                                  customInputDecoration('Nama Furnitur'),
                              onChanged: (String value) {
                                state.updateName(value);
                              },
                              keyboardType: TextInputType.text,
                              validator: validateNotEmpty,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: state.imagePreview(),
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor100,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.photo_camera),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Tambah Foto Pendukung',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  customInfoDialog(
                                    context: context,
                                    title: 'Pilih Sumber Gambar',
                                    content:
                                        'Ikon kamera untuk mengambil gambar dari kamera.\nIkon gambar untuk mengambil dari galeri',
                                    actions: [
                                      IconButton(
                                        onPressed: () async {
                                          try {
                                            XFile? upload = await state
                                                .imagePicker
                                                .pickImage(
                                              source: ImageSource.camera,
                                            );
                                            state.updateImage(upload);
                                            if (!context.mounted) return;
                                            Navigation.back();
                                          } catch (error) {
                                            customInfoDialog(
                                              context: context,
                                              title: 'Error!',
                                              content: error.toString(),
                                            );
                                          }
                                        },
                                        icon: const Icon(Icons.camera_alt),
                                        color: primaryColor,
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          try {
                                            XFile? upload = await state
                                                .imagePicker
                                                .pickImage(
                                              source: ImageSource.gallery,
                                            );
                                            state.updateImage(upload);
                                            if (!context.mounted) return;
                                            Navigation.back();
                                          } catch (error) {
                                            customInfoDialog(
                                              context: context,
                                              title: 'Error!',
                                              content: error.toString(),
                                            );
                                          }
                                        },
                                        icon: const Icon(Icons.photo_library),
                                        color: primaryColor,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          InputLayout(
                            'Jumlah Stok',
                            TextFormField(
                              decoration: customInputDecoration('Jumlah'),
                              onChanged: (String value) {
                                state.updateAmount(value);
                              },
                              keyboardType: TextInputType.number,
                              validator: validateNotEmpty,
                              inputFormatters: [
                                FilteringTextInputFormatter.singleLineFormatter,
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                          InputLayout(
                            'Harga Furnitur',
                            TextFormField(
                              decoration: customInputDecoration('Harga'),
                              onChanged: (String value) {
                                state.updatePrice(value);
                              },
                              keyboardType: TextInputType.number,
                              validator: validateNotEmpty,
                              inputFormatters: [
                                FilteringTextInputFormatter.singleLineFormatter,
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                          InputLayout(
                            'Supplier',
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              stream: _firestore
                                  .collection('suppliers')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator(
                                    color: primaryColor,
                                  );
                                }
                                return DropdownButtonFormField(
                                  decoration: customInputDecoration(
                                    'Supplier Furnitur',
                                  ),
                                  items: snapshot.data!.docs.map((document) {
                                    final String name = document.data()['name'];
                                    final String docId =
                                        document.data()['docId'];

                                    return DropdownMenuItem(
                                      value: '$name,$docId',
                                      child: Text(name),
                                    );
                                  }).toList(),
                                  onChanged: (selected) =>
                                      state.updateSupplier(selected ?? ''),
                                );
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
                                    CollectionReference stocksCollection =
                                        _firestore.collection('stocks');
                                    CollectionReference reportsCollection =
                                        _firestore.collection('reports');
                                    Timestamp timestamp =
                                        Timestamp.fromDate(DateTime.now());

                                    final id = _firestore
                                        .collection('stocks')
                                        .doc()
                                        .id;
                                    String url =
                                        await state.uploadImage(id: id);
                                    state.updateImageUrl(url);

                                    await stocksCollection.doc(id).set({
                                      'uid': _auth.currentUser!.uid,
                                      'docId': id,
                                      'name': state.name,
                                      'amount': state.amount,
                                      'price': state.price,
                                      'supplier': state.supplier,
                                      'imageUrl': state.imageUrl,
                                      'added_at': timestamp,
                                      'updated_at': timestamp,
                                    }).catchError((error) {
                                      customInfoDialog(
                                        context: context,
                                        title: 'Error!',
                                        content: error.toString(),
                                      );
                                    });

                                    await reportsCollection
                                        .doc(
                                          DateFormat('MMMM yyyy')
                                              .format(timestamp.toDate()),
                                        )
                                        .collection(id)
                                        .doc()
                                        .set({
                                      'docId': id,
                                      'type': 'STOCK MASUK',
                                      'name': state.name,
                                      'amount': state.amount,
                                      'delta_stock': state.amount,
                                      'price': state.price,
                                      'added_at': timestamp,
                                    });
                                    if (!context.mounted) return;
                                    customInfoDialog(
                                      context: context,
                                      title: 'Berhasil!',
                                      content: 'Data Stok Berhasil Ditambahkan',
                                    );
                                  } catch (error) {
                                    customInfoDialog(
                                      context: context,
                                      title: 'Error!',
                                      content: error.toString(),
                                    );
                                  } finally {
                                    state.file = null;
                                  }
                                  _formKey.currentState!.reset();
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
