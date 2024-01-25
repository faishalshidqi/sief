import 'package:flutter/material.dart';
import 'package:sief_firebase/common/navigation.dart';

customInfoDialog({required BuildContext context, String? title, String? content, List<Widget>? actions}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: title == null ? const Text('Segera Hadir!') : Text(title),
        content: content == null ? const Text('Fitur ini akan segera hadir!') : Text(content),
        actions: actions ?? [
          TextButton(
            onPressed: () => Navigation.back(),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
