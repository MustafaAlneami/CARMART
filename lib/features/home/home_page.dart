import 'package:carmart/core/components/custom_container.dart';
import 'package:carmart/core/components/custom_text.dart';
import 'package:carmart/features/admin/admin_page.dart';
import 'package:carmart/features/home/car_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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
            // Header section
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
                  text: "Boston, NewYork",
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
            // Welcome text
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
            // Brand filters
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
                        color: (selectedBrand == brand ||
                                (selectedBrand == null && brand == 'All'))
                            ? Colors.blue
                            : Colors.white,
                        radius: 20,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: CustomText(
                            text: brand,
                            color: (selectedBrand == brand ||
                                    (selectedBrand == null && brand == 'All'))
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            // Car grid
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: selectedBrand == null
                    ? FirebaseFirestore.instance.collection('cars').snapshots()
                    : FirebaseFirestore.instance
                        .collection('cars')
                        .where('brand', isEqualTo: selectedBrand)
                        .snapshots(),
                builder: (context, snapshot) {
                  // Show shimmer loading effect while waiting for data
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildShimmerLoading();
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.car_crash,
                            size: 50,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "No cars available",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final cars = snapshot.data!.docs;

                  return GridView.builder(
                    itemCount: cars.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 1.2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 5,
                    ),
                    itemBuilder: (context, index) {
                      final car = cars[index].data() as Map<String, dynamic>;

                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CarDetails(carData: car),
                          ),
                        ),
                        child: Card(
                          color: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    car['image'] ?? '',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 90,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      height: 90,
                                      color: Colors.grey.shade200,
                                      child: Icon(Icons.car_crash),
                                    ),
                                  ),
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

  // Shimmer loading effect for car grid
  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: GridView.builder(
        itemCount: 6, // Show 6 shimmer items
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1 / 1.2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 5,
        ),
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image placeholder
                  Container(
                    height: 90,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Model text placeholder
                  Container(
                    height: 12,
                    width: 120,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8),
                  // Brand text placeholder
                  Container(
                    height: 12,
                    width: 80,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8),
                  // Price and icon row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 12,
                        width: 50,
                        color: Colors.white,
                      ),
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
