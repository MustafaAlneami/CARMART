import 'package:carmart/Auth/Auth_page.dart';
import 'package:carmart/core/components/custom_container.dart';
import 'package:carmart/core/components/custom_text.dart';
import 'package:carmart/features/admin/admin_page.dart';

import 'package:carmart/features/home/car_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
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
  bool isRefreshing = false;
  final List<String> brands = [
    'All',
    'Bmw',
    'Lamborghini',
    'Audi',
    'Shelby',
    'Dodge',
    'Mercedes'
  ];

  // Function to handle Firebase logout
  Future<void> _handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to auth page and remove all previous routes
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthPage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  // Function to refresh data
  Future<void> _refreshData() async {
    setState(() {
      isRefreshing = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isRefreshing = false;
    });
  }

//how to load admin page faster
  late AdminPageView _cachedAdminPage;

  @override
  void initState() {
    super.initState();
    _cachedAdminPage = const AdminPageView(); // Prebuild only once
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        toolbarHeight: 60,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          // Logout button in AppBar
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: _handleLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                        MaterialPageRoute(builder: (c) => _cachedAdminPage)),
                    child: const Icon(CupertinoIcons.cloud_upload)),
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
            // Car grid with pull-to-refresh
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshData,
                child: StreamBuilder<QuerySnapshot>(
                  stream: selectedBrand == null
                      ? FirebaseFirestore.instance
                          .collection('cars')
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection('cars')
                          .where('brand', isEqualTo: selectedBrand)
                          .snapshots(),
                  builder: (context, snapshot) {
                    // Show shimmer loading effect while waiting for data
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        isRefreshing) {
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
                            const SizedBox(height: 10),
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
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: cars.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                                    child: Hero(
                                      tag: car['image'] ?? '',
                                      child: Material(
                                        color: Colors.transparent,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: FadeInImage.assetNetwork(
                                            placeholder:
                                                'assets/placeholder.png', // Add a small local placeholder image
                                            image: car['image'] ?? '',
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 90,
                                            imageErrorBuilder:
                                                (context, error, stackTrace) =>
                                                    Container(
                                              height: 90,
                                              color: Colors.grey.shade200,
                                              child:
                                                  const Icon(Icons.car_crash),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
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
                                      const Icon(
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
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: 6, // Show 6 shimmer items
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                  const SizedBox(height: 10),
                  // Model text placeholder
                  Container(
                    height: 12,
                    width: 120,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  // Brand text placeholder
                  Container(
                    height: 12,
                    width: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
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
                        decoration: const BoxDecoration(
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
