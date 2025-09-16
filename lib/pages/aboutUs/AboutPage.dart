// import 'package:flutter/material.dart';
// import 'package:pjtravelapp/pages/navbar/Navbar.dart';
//
// class AboutPage extends StatelessWidget {
//   const AboutPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("About us")),
//       drawer: NavbarDrawer(
//         account: null,
//         onLogout: () => debugPrint("Logout"),
//         onLogin: () => debugPrint("Login pressed"),
//       ),
//
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           // Breadcrumb (giống React)
//           // const Text(
//           //   "Home > About us",
//           //   style: TextStyle(color: Colors.grey),
//           // ),
//           const SizedBox(height: 16),
//           LayoutBuilder(
//             builder: (context, constraints) {
//               bool isWide = constraints.maxWidth > 800;
//
//               return Flex(
//                 direction: isWide ? Axis.horizontal : Axis.vertical,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Left: Image + Text content
//                   SizedBox(
//                     width: isWide ? constraints.maxWidth * 0.6 : double.infinity,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Stack(
//                           children: [
//                             // ClipRRect(
//                             //   borderRadius: BorderRadius.circular(20),
//                             //   child: Image.asset(
//                             //     "assets/images/icons/aboutimg.png",
//                             //     fit: BoxFit.cover,
//                             //     height: 250,
//                             //     width: double.infinity,
//                             //   ),
//                             // ),
//                             Positioned(
//                               top: 50,
//                               right: 20,
//                               child: Container(
//                                 padding: const EdgeInsets.all(16),
//                                 decoration: BoxDecoration(
//                                   color: Colors.black.withOpacity(0.5),
//                                   borderRadius: BorderRadius.circular(20),
//                                   boxShadow: const [
//                                     BoxShadow(
//                                       color: Colors.black26,
//                                       blurRadius: 6,
//                                       offset: Offset(0, 3),
//                                     )
//                                   ],
//                                 ),
//                                 child: const Text(
//                                   "HOW WE ARE BEST FOR TRAVEL !",
//                                   style: TextStyle(
//                                       fontSize: 22,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         const Text(
//                           "HOW WE ARE BEST FOR TRAVEL !",
//                           style: TextStyle(
//                               fontSize: 24, fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 8),
//                         const Text(
//                           "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
//                         ),
//                         const SizedBox(height: 8),
//                         const Text(
//                           "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
//                         ),
//                         const SizedBox(height: 8),
//                         const Text(
//                           "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 16, height: 16),
//                   // Right: 3 Cards
//                   SizedBox(
//                     width: isWide ? constraints.maxWidth * 0.35 : double.infinity,
//                     child: Column(
//                       children: const [
//                         FeatureCard(
//                           iconPath: "assets/images/icons/destination.png",
//                           title: "50+ Destination",
//                           description:
//                           "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
//                         ),
//                         SizedBox(height: 16),
//                         FeatureCard(
//                           iconPath: "assets/images/icons/best-price.png",
//                           title: "Best Price In The Industry",
//                           description:
//                           "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
//                         ),
//                         SizedBox(height: 16),
//                         FeatureCard(
//                           iconPath: "assets/images/icons/quick.png",
//                           title: "Super Fast Booking",
//                           description:
//                           "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class FeatureCard extends StatelessWidget {
//   final String iconPath;
//   final String title;
//   final String description;
//
//   const FeatureCard({
//     super.key,
//     required this.iconPath,
//     required this.title,
//     required this.description,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             CircleAvatar(
//               radius: 30,
//               backgroundColor: Colors.grey.shade100,
//               child: Image.asset(
//                 iconPath,
//                 width: 30,
//                 height: 30,
//                 fit: BoxFit.contain,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               title,
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 8),
//             Text(
//               description,
//               style: const TextStyle(fontSize: 14),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pjtravelapp/entities/account.dart';
import 'package:pjtravelapp/entities/Region.dart';
import 'package:pjtravelapp/pages/navbar/Navbar.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  Account? account;
  List<Region> regions = [];

  Account? currentAccount;
  @override
  void initState() {
    super.initState();
    fetchRegions();
  }

  Future<void> fetchRegions() async {
    try {
      final res =
      await http.get(Uri.parse("http://192.168.2.7:9999/api/regions"));
      if (res.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(res.body);
        setState(() {
          regions = jsonList.map((e) => Region.fromJson(e)).toList();
        });
      }
    } catch (e) {
      debugPrint("Error fetching regions: $e");
    }
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx); // đóng dialog
              setState(() => account = null);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About us")),

      drawer: NavbarDrawer(
        account: currentAccount,
        onLogout: () {
          debugPrint("Logout");
          setState(() {
            currentAccount = null; // clear khi logout
          });
        },
        onLogin: (account) {
          debugPrint("Login success: ${account.username}");
          setState(() {
            currentAccount = account; // 👉 cập nhật state
          });
        },
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              bool isWide = constraints.maxWidth > 800;

              return Flex(
                direction: isWide ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left: Image + Text content
                  SizedBox(
                    width:
                    isWide ? constraints.maxWidth * 0.6 : double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Positioned(
                              top: 50,
                              right: 20,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                      offset: Offset(0, 3),
                                    )
                                  ],
                                ),
                                child: const Text(
                                  "HOW WE ARE BEST FOR TRAVEL !",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "HOW WE ARE BEST FOR TRAVEL !",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s...",
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text...",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16, height: 16),
                  // Right: 3 Cards
                  SizedBox(
                    width:
                    isWide ? constraints.maxWidth * 0.35 : double.infinity,
                    child: Column(
                      children: const [
                        FeatureCard(
                          iconPath: "assets/images/icons/destination.png",
                          title: "50+ Destination",
                          description:
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                        ),
                        SizedBox(height: 16),
                        FeatureCard(
                          iconPath: "assets/images/icons/best-price.png",
                          title: "Best Price In The Industry",
                          description:
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                        ),
                        SizedBox(height: 16),
                        FeatureCard(
                          iconPath: "assets/images/icons/quick.png",
                          title: "Super Fast Booking",
                          description:
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final String description;

  const FeatureCard({
    super.key,
    required this.iconPath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey.shade100,
              child: Image.asset(
                iconPath,
                width: 30,
                height: 30,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
