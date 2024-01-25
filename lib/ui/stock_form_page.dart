import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
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
                              validator: notEmptyValidator,
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
                                      TextButton(
                                        onPressed: () async {
                                          try {
                                            XFile? upload = await state
                                                .imagePicker
                                                .pickImage(
                                              source: ImageSource.camera,
                                            );
                                            state.updateImage(upload);
                                            if (!context.mounted) return;
                                            Navigator.of(context).pop();
                                          } catch (error) {
                                            customInfoDialog(
                                              context: context,
                                              title: 'Error!',
                                              content: error.toString(),
                                            );
                                          }
                                        },
                                        child: const Icon(Icons.camera_alt),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          try {
                                            XFile? upload = await state
                                                .imagePicker
                                                .pickImage(
                                              source: ImageSource.gallery,
                                            );
                                            state.updateImage(upload);
                                            if (!context.mounted) return;
                                            Navigator.of(context).pop();
                                          } catch (error) {
                                            customInfoDialog(
                                              context: context,
                                              title: 'Error!',
                                              content: error.toString(),
                                            );
                                          }
                                        },
                                        child: const Icon(Icons.photo_library),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          InputLayout(
                            'Jumlah',
                            TextFormField(
                              decoration: customInputDecoration('Jumlah Stok'),
                              onChanged: (String value) {
                                state.updateAmount(int.parse(value));
                              },
                              keyboardType: TextInputType.number,
                              validator: notEmptyValidator,
                            ),
                          ),
                          InputLayout(
                            'Harga',
                            TextFormField(
                              decoration:
                                  customInputDecoration('Harga Furnitur'),
                              onChanged: (String value) {
                                state.updatePrice(double.parse(value));
                              },
                              keyboardType: TextInputType.number,
                              validator: notEmptyValidator,
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
                                    return DropdownMenuItem(
                                      value: name,
                                      child: Text(name),
                                    );
                                  }).toList(),
                                  onChanged: (selected) =>
                                      state.updateSupplier(selected!),
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
                                try {
                                  state.addStockRecord();
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
