import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropdownItem extends StatelessWidget {
  const CustomDropdownItem(
      {super.key,
      required this.value,
      required this.valid,
      required this.hint,
      required this.items,
      this.onChanged});

  final String value;
  final String valid, hint;
  final List<DropdownMenuItem> items;
  final Function(dynamic v)? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      items: items,
      validator: (value) => value == null ? valid : null,
      onChanged: onChanged,
    );
  }
}
