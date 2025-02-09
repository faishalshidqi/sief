import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nanoid2/nanoid2.dart';

class StocksProvider extends ChangeNotifier {
  StocksProvider();

  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;

  bool isGridView = false;
  int outingStockAmount = 0;
  ImagePicker imagePicker = ImagePicker();
  XFile? file;
  String? name;
  int? amount;
  String? supplier;
  String? imageUrl;
  int? price;

  updateOutingStockAmount(int value) {
    outingStockAmount = value;
    notifyListeners();
  }

  updateIsGridView(bool value) {
    isGridView = value;
    notifyListeners();
  }

  void addStockRecord() async {
    CollectionReference stocksCollection = _firestore.collection('stocks');
    Timestamp timestamp = Timestamp.fromDate(DateTime.now());

    final id = _firestore.collection('stocks').doc().id;
    String url = await uploadImage(id: id);
    updateImageUrl(url);

    await stocksCollection.doc(id).set({
      'uid': _auth.currentUser!.uid,
      'docId': id,
      'name': name,
      'amount': amount,
      'supplier': supplier,
      'imageUrl': imageUrl,
      'price': price,
      'added_at': timestamp,
      'updated_at': timestamp,
    });
    file = null;
  }

  Future<String> uploadImage({required String id}) async {
    if (file == null) return '';

    String uniqueFilename = nanoid();
    try {
      Reference dirUpload = _storage.ref().child('/furnitures/$id}');
      Reference storedDir = dirUpload.child(uniqueFilename);

      await storedDir.putFile(File(file!.path));

      return await storedDir.getDownloadURL();
    } catch (error) {
      rethrow;
    }
  }

  Image imagePreview() {
    if (file == null) {
      return Image.asset(
        'assets/istock-default.jpg',
        width: 180,
        height: 180,
      );
    } else {
      return Image.file(
        File(file!.path),
        width: 180,
        height: 180,
      );
    }
  }

  void updateImage(XFile? value) {
    file = value;
    notifyListeners();
  }

  void updateName(String value) {
    name = value;
    notifyListeners();
  }

  void updateAmount(String value) {
    if (value == '') {
      value = '0';
    }
    amount = int.parse(value);
    notifyListeners();
  }

  void updateSupplier(String value) {
    supplier = value;
    notifyListeners();
  }

  void updateImageUrl(String value) {
    imageUrl = value;
    notifyListeners();
  }

  void updatePrice(String value) {
    if (value.toString() == '') {
      value = '0';
    }
    price = int.parse(value);
    notifyListeners();
  }
}
