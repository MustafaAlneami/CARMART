import 'package:carmart/Auth/Auth_page.dart';
import 'package:carmart/core/components/custom_container.dart';
import 'package:carmart/core/components/custom_text.dart';
import 'package:carmart/features/admin/admin_page.dart';
import 'package:carmart/features/home/car_details.dart';
import 'package:carmart/features/utils/responsiveUtils';
// Import the responsive utils
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isRefreshing = false;
    });
  }

  late AdminPageView _cachedAdminPage;

  @override
  void initState() {
    super.initState();
    _cachedAdminPage = const AdminPageView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        toolbarHeight: ResponsiveUtils.getAppBarHeight(context),
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.red,
              size: ResponsiveUtils.getIconSize(context),
            ),
            onPressed: _handleLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: Container(
          constraints: ResponsiveUtils.getResponsiveConstraints(context),
          child: Padding(
            padding: ResponsiveUtils.getResponsiveLayoutPadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: ResponsiveUtils.getAvatarRadius(context),
                      backgroundImage: const NetworkImage(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrxWd_qyeMG-05UoSEmiNlEcKzWnIpoXdl_A&s",
                      ),
                    ),
                    CustomText(
                      text: "Boston, NewYork",
                      fontSize:
                          ResponsiveUtils.getResponsiveFontSize(context, 14),
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (c) => _cachedAdminPage)),
                      child: Icon(
                        CupertinoIcons.cloud_upload,
                        color: Colors.blue,
                        size:
                            ResponsiveUtils.getIconSize(context, baseSize: 28),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                    height: ResponsiveUtils.getResponsiveSpacing(context, 20)),

                // Welcome text
                Row(
                  children: [
                    CustomText(
                      text: "Hello, ",
                      fontSize:
                          ResponsiveUtils.getResponsiveFontSize(context, 25),
                      color: Colors.grey.shade500,
                    ),
                    CustomText(
                      text: "MUSTA",
                      fontSize:
                          ResponsiveUtils.getResponsiveFontSize(context, 25),
                    ),
                  ],
                ),
                CustomText(
                  text: "Choose your Ideal Car",
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
                SizedBox(
                    height: ResponsiveUtils.getResponsiveSpacing(context, 20)),

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
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                ResponsiveUtils.isMobile(context) ? 2.0 : 4.0,
                          ),
                          child: CustomContainer(
                            color: (selectedBrand == brand ||
                                    (selectedBrand == null && brand == 'All'))
                                ? Colors.blue
                                : Colors.white,
                            radius: ResponsiveUtils.getBorderRadius(context,
                                baseRadius: 20),
                            padding:
                                ResponsiveUtils.getBrandFilterPadding(context),
                            child: CustomText(
                              text: brand,
                              fontSize: ResponsiveUtils.getResponsiveFontSize(
                                  context, 14),
                              color: (selectedBrand == brand ||
                                      (selectedBrand == null && brand == 'All'))
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                    height: ResponsiveUtils.getResponsiveSpacing(context, 20)),

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
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
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
                                  size: ResponsiveUtils.getIconSize(context,
                                      baseSize: 50),
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                    height:
                                        ResponsiveUtils.getResponsiveSpacing(
                                            context, 10)),
                                Text(
                                  "No cars available",
                                  style: TextStyle(
                                    fontSize:
                                        ResponsiveUtils.getResponsiveFontSize(
                                            context, 16),
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
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                ResponsiveUtils.getGridCrossAxisCount(context),
                            childAspectRatio:
                                ResponsiveUtils.getGridChildAspectRatio(
                                    context),
                            mainAxisSpacing:
                                ResponsiveUtils.getResponsiveSpacing(
                                    context, 10),
                            crossAxisSpacing:
                                ResponsiveUtils.getResponsiveSpacing(
                                    context, 8),
                          ),
                          itemBuilder: (context, index) {
                            final car =
                                cars[index].data() as Map<String, dynamic>;

                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CarDetails(carData: car),
                                ),
                              ),
                              child: Card(
                                color: Colors.white,
                                elevation:
                                    ResponsiveUtils.getCardElevation(context),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveUtils.getBorderRadius(context),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    ResponsiveUtils.isMobile(context)
                                        ? 8.0
                                        : 12.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          ResponsiveUtils.getBorderRadius(
                                              context,
                                              baseRadius: 8),
                                        ),
                                        child: Hero(
                                          tag: car['image'] ?? '',
                                          child: Material(
                                            color: Colors.transparent,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                ResponsiveUtils.getBorderRadius(
                                                    context),
                                              ),
                                              child: FadeInImage.assetNetwork(
                                                placeholder:
                                                    'assets/carplaceholder.webp',
                                                image: car['image'] ?? '',
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: ResponsiveUtils
                                                        .isMobile(context)
                                                    ? 90
                                                    : ResponsiveUtils.isTablet(
                                                            context)
                                                        ? 100
                                                        : 110,
                                                imageErrorBuilder: (context,
                                                        error, stackTrace) =>
                                                    Container(
                                                  height: ResponsiveUtils
                                                          .isMobile(context)
                                                      ? 90
                                                      : ResponsiveUtils
                                                              .isTablet(context)
                                                          ? 100
                                                          : 110,
                                                  color: Colors.grey.shade200,
                                                  child: Icon(
                                                    Icons.car_crash,
                                                    size: ResponsiveUtils
                                                        .getIconSize(context),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height: ResponsiveUtils
                                              .getResponsiveSpacing(
                                                  context, 8)),
                                      CustomText(
                                        text: car['model'] ?? '',
                                        fontSize: ResponsiveUtils
                                            .getResponsiveFontSize(context, 14),
                                        fontWeight: FontWeight.w400,
                                      ),
                                      CustomText(
                                        text: car['brand'] ?? '',
                                        fontSize: ResponsiveUtils
                                            .getResponsiveFontSize(context, 14),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomText(
                                            text: '\$ ${car['price'] ?? ''}',
                                            fontSize: ResponsiveUtils
                                                .getResponsiveFontSize(
                                                    context, 14),
                                            fontWeight: FontWeight.w500,
                                          ),
                                          Icon(
                                            Icons.arrow_circle_right_rounded,
                                            color: Colors.blue,
                                            size: ResponsiveUtils.getIconSize(
                                                context,
                                                baseSize: 20),
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
        itemCount: ResponsiveUtils.isMobile(context) ? 6 : 9,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveUtils.getGridCrossAxisCount(context),
          childAspectRatio: ResponsiveUtils.getGridChildAspectRatio(context),
          mainAxisSpacing: ResponsiveUtils.getResponsiveSpacing(context, 10),
          crossAxisSpacing: ResponsiveUtils.getResponsiveSpacing(context, 8),
        ),
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.getBorderRadius(context),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(
                ResponsiveUtils.isMobile(context) ? 8.0 : 12.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image placeholder
                  Container(
                    height: ResponsiveUtils.isMobile(context)
                        ? 90
                        : ResponsiveUtils.isTablet(context)
                            ? 100
                            : 110,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.getBorderRadius(context, baseRadius: 8),
                      ),
                    ),
                  ),
                  SizedBox(
                      height:
                          ResponsiveUtils.getResponsiveSpacing(context, 10)),
                  // Model text placeholder
                  Container(
                    height: 12,
                    width: 120,
                    color: Colors.white,
                  ),
                  SizedBox(
                      height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
                  // Brand text placeholder
                  Container(
                    height: 12,
                    width: 80,
                    color: Colors.white,
                  ),
                  SizedBox(
                      height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
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
