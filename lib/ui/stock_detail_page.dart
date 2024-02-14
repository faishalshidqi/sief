import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:sief_firebase/data/model/stock.dart';
import 'package:sief_firebase/provider/stock_detail_provider.dart';

class StockDetailPage extends StatelessWidget {
  static const routeName = '/stock_detail';
  static final _formKey = GlobalKey<FormState>();
  static final _firestore = FirebaseFirestore.instance;
  final Stock stock;
  const StockDetailPage({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Detail Stok'),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _firestore
              .collection('stocks')
              .where('docId', isEqualTo: stock.docId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            } else if (snapshot.data == null) {
              return const Center(
                child: Text('Mohon Tunggu...'),
              );
            }
            final data = snapshot.data!.docs.first;
            return Consumer<StockDetailProvider>(
              builder: (context, state, _) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
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
                              onChanged: (bool value) {
                                state.updateEditMode(value);
                                state.updateDocId(data['docId']);
                                state.updateName(data['name']);
                                state.updateAmount(data['amount']);
                                state.updatePrice(data['price']);
                                state.updateSupplier(data['supplier']);
                                state.updateImageUrl(data['imageUrl']);
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
                                        'Nama Furnitur',
                                        TextFormField(
                                          decoration: customInputDecoration(
                                            'Nama',
                                          ),
                                          onChanged: (String value) =>
                                              state.updateName(value),
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
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        child: state.imagePreview(),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Center(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: primaryColor100,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.photo_camera),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  'Ganti Foto Pendukung',
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
                                                    'Ikon kamera untuk mengambil gambar dari kamera.'
                                                    '\nIkon gambar untuk mengambil dari galeri',
                                                actions: [
                                                  IconButton(
                                                    onPressed: () async {
                                                      try {
                                                        XFile? upload =
                                                            await state
                                                                .imagePicker
                                                                .pickImage(
                                                          source: ImageSource
                                                              .camera,
                                                        );
                                                        state.updateImage(
                                                          upload,
                                                        );
                                                        if (!context.mounted) {
                                                          return;
                                                        }
                                                        Navigation.back();
                                                      } catch (error) {
                                                        customInfoDialog(
                                                          context: context,
                                                          title: 'Error!',
                                                          content:
                                                              error.toString(),
                                                        );
                                                      }
                                                    },
                                                    icon: const Icon(
                                                      Icons.camera_alt,
                                                    ),
                                                    color: primaryColor,
                                                  ),
                                                  IconButton(
                                                    onPressed: () async {
                                                      try {
                                                        XFile? upload =
                                                            await state
                                                                .imagePicker
                                                                .pickImage(
                                                          source: ImageSource
                                                              .gallery,
                                                        );
                                                        state.updateImage(
                                                          upload,
                                                        );
                                                        if (!context.mounted) {
                                                          return;
                                                        }
                                                        Navigation.back();
                                                      } catch (error) {
                                                        customInfoDialog(
                                                          context: context,
                                                          title: 'Error!',
                                                          content:
                                                              error.toString(),
                                                        );
                                                      }
                                                    },
                                                    icon: const Icon(
                                                      Icons.photo_library,
                                                    ),
                                                    color: primaryColor,
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      ListTile(
                                        title: const Text('Perubahan Jumlah'),
                                        subtitle: state.newStockAmount == 0
                                            ? Text(
                                                state.newStockAmount.toString(),
                                              )
                                            : Row(
                                                children: [
                                                  Text(
                                                    (state.newStockAmount -
                                                            data['amount'])
                                                        .toString(),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    '(${data["amount"].toString()}',
                                                  ),
                                                  const Icon(
                                                    Icons.arrow_forward,
                                                  ),
                                                  Text(
                                                    '${state.newStockAmount.toString()})',
                                                  ),
                                                ],
                                              ),
                                      ),
                                      InputLayout(
                                        'Jumlah Stok',
                                        TextFormField(
                                          decoration:
                                              customInputDecoration('Jumlah'),
                                          onChanged: (String value) {
                                            state
                                                .updateAmount(int.parse(value));
                                            state.updateNewStockAmount(
                                              int.parse(value),
                                            );
                                            state.updateOutingStockAmount(
                                              (state.newStockAmount -
                                                  data['amount']),
                                            );
                                          },
                                          keyboardType: TextInputType.number,
                                          initialValue:
                                              data['amount'].toString(),
                                          validator: validateNotEmpty,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(5),
                                            FilteringTextInputFormatter
                                                .singleLineFormatter,
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                        ),
                                      ),
                                      InputLayout(
                                        'Harga Furnitur',
                                        TextFormField(
                                          decoration:
                                              customInputDecoration('Harga'),
                                          onChanged: (String value) {
                                            state.updatePrice(
                                              int.parse(value),
                                            );
                                          },
                                          keyboardType: TextInputType.number,
                                          initialValue:
                                              data['price'].toString(),
                                          validator: validateNotEmpty,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .singleLineFormatter,
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                        ),
                                      ),
                                      InputLayout(
                                        'Supplier Furnitur',
                                        StreamBuilder<
                                            QuerySnapshot<
                                                Map<String, dynamic>>>(
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
                                                'Supplier',
                                              ),
                                              validator: validateNotEmpty,
                                              items: snapshot.data!.docs
                                                  .map((document) {
                                                final String name =
                                                    document.data()['name'];
                                                final String docId =
                                                    document.data()['docId'];
                                                return DropdownMenuItem(
                                                  value: docId,
                                                  child: Text(name),
                                                );
                                              }).toList(),
                                              onChanged: (selected) {
                                                state.updateSupplier(selected);
                                              },
                                              value: data['supplier']
                                                  .toString()
                                                  .split(',')[1],
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
                                            'Perbarui',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall,
                                          ),
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              try {
                                                state.updateStockRecord();
                                                if (!context.mounted) return;
                                                customInfoDialog(
                                                  context: context,
                                                  title: 'Berhasil!',
                                                  content:
                                                      'Data Stok Berhasil Diperbarui',
                                                );
                                              } catch (error) {
                                                customInfoDialog(
                                                  context: context,
                                                  title: 'Error!',
                                                  content: error.toString(),
                                                );
                                              }
                                            }
                                            state.updateEditMode(false);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Column(
                                children: [
                                  data['imageUrl'] == ''
                                      ? Image.asset(
                                          'assets/istock-default.jpg',
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: data['imageUrl'],
                                        ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Table(
                                    columnWidths: const {
                                      1: FractionColumnWidth(0.55),
                                    },
                                    children: [
                                      TableRow(
                                        children: [
                                          Text(
                                            'Nama Furnitur\n',
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
                                            'Jumlah Stok\n',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                          Text(
                                            data['amount'].toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Text(
                                            'Harga Stok\n',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                          Text(
                                            data['price'].toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Text(
                                            'Disuplai oleh\n',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                          Text(
                                            data['supplier']
                                                .toString()
                                                .split(',')[0],
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Text(
                                            'Ditambahkan pada\n',
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
                                            'Diperbarui pada\n',
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
                    ),
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
