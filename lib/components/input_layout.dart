import 'package:flutter/material.dart';

class InputLayout extends StatelessWidget {
  final String label;
  final StatefulWidget inputField;
  const InputLayout(this.label, this.inputField, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 5),
        Container(child: inputField),
        const SizedBox(height: 15),
      ],
    );
  }
}

InputDecoration customInputDecoration(
  String hintText, {
  Widget? suffixIcon,
  Widget? prefixIcon,
}) {
  return InputDecoration(
    hintText: hintText,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    floatingLabelBehavior: FloatingLabelBehavior.never,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  );
}
