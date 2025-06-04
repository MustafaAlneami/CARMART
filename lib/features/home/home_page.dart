import 'package:carmart/Auth/Auth_page.dart';
import 'package:carmart/core/components/custom_container.dart';
import 'package:carmart/core/components/custom_text.dart';
import 'package:carmart/features/admin/admin_page.dart';
import 'package:carmart/features/home/car_details.dart';
import 'package:carmart/features/utils/responsiveUtils.dart';
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
  // '?' means that the variable can be null
  // This is used to store the selected brand for filtering cars
  //'!' means that the variable is not null
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
        centerTitle: ResponsiveUtils.isDesktop(context),
        title: ResponsiveUtils.isDesktop(context)
            ? const Text('CarMart',
                style: TextStyle(fontWeight: FontWeight.bold))
            : null,
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
          SizedBox(width: ResponsiveUtils.isMobile(context) ? 8 : 16),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: ResponsiveUtils.getResponsiveConstraints(context),
              child: Center(
                child: Padding(
                  padding: ResponsiveUtils.getResponsiveLayoutPadding(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header section
                      _buildHeaderSection(),

                      SizedBox(
                        height:
                            ResponsiveUtils.getResponsiveSpacing(context, 20),
                      ),

                      // Welcome text
                      _buildWelcomeSection(),

                      SizedBox(
                        height:
                            ResponsiveUtils.getResponsiveSpacing(context, 20),
                      ),

                      // Brand filters
                      _buildBrandFilters(),

                      SizedBox(
                        height:
                            ResponsiveUtils.getResponsiveSpacing(context, 20),
                      ),

                      // Car grid
                      _buildCarGrid(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          radius: ResponsiveUtils.getAvatarRadius(context),
          backgroundImage: const NetworkImage(
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrxWd_qyeMG-05UoSEmiNlEcKzWnIpoXdl_A&s",
          ),
        ),
        if (ResponsiveUtils.isDesktop(context)) const Spacer(),
        CustomText(
          text: "Boston, NewYork",
          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
        if (ResponsiveUtils.isDesktop(context)) const Spacer(),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (c) => _cachedAdminPage),
          ),
          child: Container(
            padding: EdgeInsets.all(ResponsiveUtils.isMobile(context) ? 8 : 12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.getBorderRadius(context, baseRadius: 8),
              ),
            ),
            child: Icon(
              CupertinoIcons.cloud_upload,
              color: Colors.blue,
              size: ResponsiveUtils.getIconSize(context, baseSize: 28),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomText(
              text: "Hello, ",
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 25),
              color: Colors.grey.shade500,
            ),
            CustomText(
              text: "MUSTA",
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 25),
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 4)),
        CustomText(
          text: "Choose your Ideal Car",
          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade600,
        ),
      ],
    );
  }

  Widget _buildBrandFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: brands.map((brand) {
          final isSelected = selectedBrand == brand ||
              (selectedBrand == null && brand == 'All');

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedBrand = brand == 'All' ? null : brand;
              });
            },
            child: Container(
              margin: EdgeInsets.only(
                right: ResponsiveUtils.getResponsiveSpacing(context, 8),
              ),
              child: CustomContainer(
                color: isSelected ? Colors.blue : Colors.white,
                radius:
                    ResponsiveUtils.getBorderRadius(context, baseRadius: 25),
                padding: ResponsiveUtils.getBrandFilterPadding(context),
                child: CustomText(
                  text: brand,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCarGrid() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6, // Fixed height for grid
      child: RefreshIndicator(
        onRefresh: _refreshData,
        child: StreamBuilder<QuerySnapshot>(
          stream: selectedBrand == null
              ? FirebaseFirestore.instance.collection('cars').snapshots()
              : FirebaseFirestore.instance
                  .collection('cars')
                  .where('brand', isEqualTo: selectedBrand)
                  .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                isRefreshing) {
              return _buildShimmerLoading();
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return _buildEmptyState();
            }

            final cars = snapshot.data!.docs;

            return GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: cars.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ResponsiveUtils.getGridCrossAxisCount(context),
                childAspectRatio:
                    ResponsiveUtils.getGridChildAspectRatio(context),
                mainAxisSpacing: ResponsiveUtils.getGridSpacing(context),
                crossAxisSpacing: ResponsiveUtils.getGridSpacing(context),
              ),
              itemBuilder: (context, index) {
                final car = cars[index].data() as Map<String, dynamic>;
                return _buildCarCard(car);
              },
            );
          },
        ),
      ),
    );
  }

//lets go
  Widget _buildCarCard(Map<String, dynamic> car) {
    // Ensure car data is not null and has required fields
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CarDetails(carData: car),
        ),
      ),
      child: Card(
        color: Colors.white,
        elevation: ResponsiveUtils.getCardElevation(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.getBorderRadius(context),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(
            ResponsiveUtils.isMobile(context) ? 12.0 : 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Car Image
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    ResponsiveUtils.getBorderRadius(context, baseRadius: 8),
                  ),
                  child: Hero(
                    tag: car['image']?.toString() ?? '',
                    child: (car['image'] != null &&
                            car['image'].toString().isNotEmpty)
                        ? Image.network(
                            car['image'].toString(),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: Colors.grey.shade200,
                              child: Icon(
                                Icons.car_crash,
                                size: ResponsiveUtils.getIconSize(context,
                                    baseSize: 32),
                                color: Colors.grey.shade400,
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey.shade200,
                            child: Icon(
                              Icons.car_crash,
                              size: ResponsiveUtils.getIconSize(context,
                                  baseSize: 32),
                              color: Colors.grey.shade400,
                            ),
                          ),
                  ),
                ),
              ),

              // Car Details
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveUtils.getResponsiveSpacing(context, 8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: car['model']?.toString() ?? '',
                          fontSize: ResponsiveUtils.getResponsiveFontSize(
                              context, 14),
                          fontWeight: FontWeight.w600,
                          maxLines: 1,
                        ),
                        SizedBox(
                            height: ResponsiveUtils.getResponsiveSpacing(
                                context, 2)),
                        CustomText(
                          text: car['brand']?.toString() ?? '',
                          fontSize: ResponsiveUtils.getResponsiveFontSize(
                              context, 12),
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                          maxLines: 1,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: '\$${car['price']?.toString() ?? ''}',
                          fontSize: ResponsiveUtils.getResponsiveFontSize(
                              context, 14),
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        Icon(
                          Icons.arrow_circle_right_rounded,
                          color: Colors.blue,
                          size: ResponsiveUtils.getIconSize(context,
                              baseSize: 20),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.car_crash,
            size: ResponsiveUtils.getIconSize(context, baseSize: 64),
            color: Colors.grey.shade400,
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
          Text(
            "No cars available",
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
          Text(
            selectedBrand != null
                ? "Try selecting a different brand"
                : "Check back later",
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        //*4 means 4 rows
        //itemCount means the total number of items in the grid
        itemCount: ResponsiveUtils.getGridCrossAxisCount(context) * 4,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveUtils.getGridCrossAxisCount(context),
          childAspectRatio: ResponsiveUtils.getGridChildAspectRatio(context),
          mainAxisSpacing: ResponsiveUtils.getGridSpacing(context),
          crossAxisSpacing: ResponsiveUtils.getGridSpacing(context),
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
                ResponsiveUtils.isMobile(context) ? 12.0 : 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image placeholder
                  Expanded(
                    //flex 3 means that this widget will take 3 parts
                    //of the available space
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.getBorderRadius(context,
                              baseRadius: 8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
                  // Text placeholders
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 14,
                              width: double.infinity * 0.8,
                              color: Colors.white,
                            ),
                            SizedBox(
                                height: ResponsiveUtils.getResponsiveSpacing(
                                    context, 4)),
                            Container(
                              height: 12,
                              width: double.infinity * 0.6,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 14,
                              width: 60,
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
