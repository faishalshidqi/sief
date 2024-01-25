import 'package:flutter/material.dart';
import 'package:sief_firebase/common/styles.dart';

customFloatingActionButton({required BuildContext context, required String text, required IconData icon, required String routeName}) {
  return FloatingActionButton.extended(
    onPressed: () {
      Navigator.pushNamed(context, routeName);
    },
    backgroundColor: primaryColor100,
    label: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    ),
    icon: Icon(icon),
  );
}
