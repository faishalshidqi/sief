import 'package:flutter/material.dart';
import 'package:sief_firebase/common/styles.dart';

customAppBar({required String title}) {
  return AppBar(
    title: Text(title),
    backgroundColor: primaryColor100,
  );
}