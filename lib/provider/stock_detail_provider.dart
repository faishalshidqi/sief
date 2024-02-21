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

  int newStockAmount = 0;
  dynamic outingStockAmount = 0;
  bool isEditMode = false;
  String? name;
  int? amount;
  int? price;
  String? supplier;
  String imageUrl = '';
  String? docId;
  XFile? file;
  ImagePicker imagePicker = ImagePicker();

  void updateNewStockAmount(int value) {
    newStockAmount = value;
    notifyListeners();
  }

  void updateOutingStockAmount(value) {
    outingStockAmount = value;
    notifyListeners();
  }

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

  void updatePrice(int value) {
    price = value;
    notifyListeners();
  }

  void updateSupplier(String? value) {
    supplier = value;
    notifyListeners();
  }

  void updateDocId(String value) {
    docId = value;
    notifyListeners();
  }

  void updateImage(XFile? value) {
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
      CollectionReference reportsCollection = _firestore.collection('reports');

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
        'updated_at': timestamp,
      });

      await reportsCollection.doc().set({
        'docId': docId,
        'type': 'STOCK-DIPERBARUI',
        'name': name,
        'amount': amount,
        'delta_stock': outingStockAmount,
        'price': price,
        'added_at': timestamp,
      });
    } catch (error) {
      rethrow;
    } finally {
      name = null;
      amount = null;
      supplier = null;
      file = null;
      newStockAmount = 0;
      outingStockAmount = 0;
      imageUrl = '';
    }
  }

  Future<String> uploadImage({required String id}) async {
    if (file == null) return imageUrl;

    String uniqueFilename = nanoid();
    try {
      Reference dirUpload = _storage.ref().child('/furnitures/$id}');
      Reference storedDir = dirUpload.child(uniqueFilename);

      if (imageUrl != '') {
        _storage.refFromURL(imageUrl).delete();
      }
      await storedDir.putFile(File(file!.path));

      return await storedDir.getDownloadURL();
    } catch (error) {
      rethrow;
    }
  }

  Widget imagePreview(String docId) {
    if (imageUrl != '') {
      return Hero(
        tag: docId,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: 180,
          height: 180,
        ),
      );
    } else if (file != null) {
      return Image.file(
        File(file!.path),
        width: 180,
        height: 180,
      );
    } else {
      return Image.asset(
        'assets/istock-default.jpg',
        width: 180,
        height: 180,
      );
    }
  }
}
