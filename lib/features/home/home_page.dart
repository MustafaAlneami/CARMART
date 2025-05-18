import 'package:carmart/core/components/custom_container.dart';
import 'package:carmart/core/components/custom_text.dart';
import 'package:carmart/features/admin/admin_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.grey.shade300,
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
                children: [
                  ...List.generate(
                    10,
                    (index) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: CustomContainer(
                        color: Colors.blueAccent,
                        radius: 20,
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
