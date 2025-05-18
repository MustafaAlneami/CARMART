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
    return SizedBox(
      height: 45,
      child: DropdownButtonFormField2(
        items: items,
        validator: (value) => value == null ? valid : null,
        onChanged: onChanged,
        hint: Text(
          hint,
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        iconStyleData: IconStyleData(icon: Icon(Icons.arrow_drop_down)),
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.grey),
          contentPadding: EdgeInsets.all(15),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 0)),
        ),
      ),
    );
  }
}
