import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nanoid2/nanoid2.dart';

class StockDetailProvider extends ChangeNotifier {
  final _storage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;
  StockDetailProvider();

  bool isEditMode = false;
  String? name;
  int? amount;
  double? price;
  String? supplier;
  String? imageUrl;
  String? docId;
  XFile? file;
  ImagePicker imagePicker = ImagePicker();

  void updateEditMode(bool value) {
    isEditMode = value;
    notifyListeners();
  }

  void updateName(String value) {
    name = value;
    notifyListeners();
  }

  void updateAmount(int value) {
    amount = value;
    notifyListeners();
  }

  void updatePrice(double value) {
    price = value;
    notifyListeners();
  }

  void updateSupplier(String value) {
    supplier = value;
    notifyListeners();
  }

  void updateDocId(String value) {
    docId = value;
    notifyListeners();
  }

  void updateImage(XFile value) {
    file = value;
    notifyListeners();
  }

  void updateImageUrl(String url) {
    imageUrl = url;
    notifyListeners();
  }

  void updateStockRecord() async {
    try {
      CollectionReference stocksCollection = _firestore.collection('stocks');
      Timestamp timestamp = Timestamp.fromDate(DateTime.now());

      String url = await uploadImage(
        id: docId!,
      );
      updateImageUrl(url);

      await stocksCollection.doc(docId!).update({
        'name': name,
        'amount': amount,
        'supplier': supplier,
        'imageUrl': imageUrl,
        'price': price,
        'added_at': timestamp,
      });
    } catch (error) {
      rethrow;
    } finally {
      name = null;
      amount = null;
      supplier = null;
      imageUrl = null;
    }
  }

  Future<String> uploadImage({required String id}) async {
    if (file == null) return imageUrl!;

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

  Widget imagePreview() {
    if (imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        width: 180,
        height: 180,
      );
    }
    if (file == null) {
      return Image.asset(
        'assets/istock-default.jpg',
        width: 180,
        height: 180,
      );
    }
    else {
      return Image.file(
        File(file!.path),
        width: 180,
        height: 180,
      );
    }
  }
}
