import 'package:carmart/core/components/custom_container.dart';
import 'package:carmart/core/components/custom_text.dart';
import 'package:carmart/features/admin/admin_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  String? selectedBrand;
  final List<String> brands = [
    'All',
    'Bmw',
    'Lamborghini',
    'Audi',
    'Shelby',
    'Dodge',
    'Mercedes'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.grey.shade300,
        // scrolledUnderElevation is the shadow of the appbar
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrxWd_qyeMG-05UoSEmiNlEcKzWnIpoXdl_A&s",
                  ),
                ),
                const CustomText(
                  text: "Boston , NewYork",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
                GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (c) => AdminPageView())),
                    child: const Icon(CupertinoIcons.circle_grid_3x3)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                CustomText(
                    text: "Hello, ", fontSize: 25, color: Colors.grey.shade500),
                const CustomText(text: "MUSTA", fontSize: 25),
              ],
            ),
            const CustomText(
              text: "Choose your Ideal Car",
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: brands.map((brand) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedBrand = brand == 'All' ? null : brand;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: CustomContainer(
                        color:
                            selectedBrand == brand ? Colors.blue : Colors.white,
                        radius: 20,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: CustomText(
                            text: brand,
                            color: selectedBrand == brand
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            //TODO: remember the list.generate and gridview.builder
            //TODO and the firebase stuff
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('cars').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No cars available"));
                  }

                  final cars = snapshot.data!.docs;

                  return GridView.builder(
                    itemCount: cars.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 1.4,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 5,
                    ),
                    itemBuilder: (context, index) {
                      final car = cars[index].data() as Map<String, dynamic>;

                      return Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                car['image'] ?? '',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 90,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.car_crash),
                              ),
                              SizedBox(height: 8),
                              CustomText(
                                text: car['model'] ?? '',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              CustomText(
                                text: car['brand'] ?? '',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text: '\$ ${car['price'] ?? ''}',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  Icon(
                                    Icons.arrow_circle_right_rounded,
                                    color: Colors.blue,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
