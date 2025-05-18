import 'package:carmart/core/components/custom_container.dart';
import 'package:carmart/core/components/custom_text_field.dart';
import 'package:carmart/features/admin/widgets/custom_dropdown_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminPageView extends StatefulWidget {
  const AdminPageView({super.key});

  @override
  State<AdminPageView> createState() => _AdminPageViewState();
}

class _AdminPageViewState extends State<AdminPageView> {
  List<String> availableCars = ['Red', 'Blue', 'Black'];
  List<String> brands = ['Toyota', 'Honda', 'Ford'];
  String? selectedBrand;
  TextEditingController _modal = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _engine = TextEditingController();
  TextEditingController _speed = TextEditingController();
  TextEditingController _seats = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text('Admin Page  bro'),
        backgroundColor: Colors.grey.shade200,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomContainer(
                    width: 40,
                    height: 40,
                    radius: 60,
                    color: Colors.pink,
                  ),
                  Icon(CupertinoIcons.share_up)
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            //car details
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                      controller: _engine,
                      hint: 'Car Engine',
                      type: TextInputType.text),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: CustomTextField(
                      controller: _speed,
                      hint: 'Car Speed',
                      type: TextInputType.number),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: CustomTextField(
                      controller: _seats,
                      hint: 'Seats Number',
                      type: TextInputType.number),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            CustomTextField(
                controller: _modal,
                hint: 'Car Model',
                type: TextInputType.text),
            SizedBox(
              height: 20,
            ),
            CustomTextField(
                controller: _price,
                hint: 'Car Price',
                type: TextInputType.number),
            SizedBox(
              height: 20,
            ),
            CustomDropdownItem(
              value: selectedBrand ?? brands.first,
              valid: 'Please select at least one item',
              hint: 'Car Brand',
              items: brands
                  .map((brand) =>
                      DropdownMenuItem(value: brand, child: Text(brand)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedBrand = value as String;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
