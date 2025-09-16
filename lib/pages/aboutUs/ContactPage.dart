// import 'package:flutter/material.dart';
// import 'package:pjtravelapp/pages/navbar/Navbar.dart';
//
// class ContactPage extends StatelessWidget {
//   const ContactPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Contact Us"),
//       ),
//       drawer: NavbarDrawer(
//         account: null,
//         onLogout: () => debugPrint("Logout"),
//         onLogin: () => debugPrint("Login pressed"),
//       ),
//
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           // Breadcrumb
//           // const Text(
//           //   "Home > Contact us",
//           //   style: TextStyle(color: Colors.grey),
//           // ),
//           const SizedBox(height: 16),
//           // Heading
//           const Text(
//             "Please contact and learn about us !!",
//             style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             "GlobalTrip is always with you and ready to support all your questions, please contact us.",
//             style: TextStyle(fontSize: 16),
//           ),
//           const SizedBox(height: 30),
//           // Contact Cards (scroll ngang nếu màn hình nhỏ)
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: [
//                 ContactCard(
//                   icon: Icons.headset,
//                   iconBgColor: Colors.lightBlue.shade100,
//                   title: "Call Us",
//                   description:
//                   "GlobalTrip is always with you and ready to support all your questions, please contact us.",
//                   buttonText: "+0354 446 188",
//                   onPressed: () {},
//                 ),
//                 const SizedBox(width: 16),
//                 ContactCard(
//                   icon: Icons.email,
//                   iconBgColor: Colors.red.shade100,
//                   title: "Email Us",
//                   description:
//                   "GlobalTrip is always with you and ready to support all your questions, please contact us.",
//                   buttonText: "lmbaongoc2004@gmail.com",
//                   onPressed: () {},
//                 ),
//                 const SizedBox(width: 16),
//                 ContactCard(
//                   icon: Icons.public,
//                   iconBgColor: Colors.yellow.shade100,
//                   title: "Social Media",
//                   description:
//                   "GlobalTrip is always with you and ready to support all your questions, please contact us.",
//                   socialIcons: const [
//                     Icons.youtube_searched_for,
//                     // Icons.instagram,
//                     // Icons.twitter,
//                     Icons.youtube_searched_for,
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 30),
//           // Image + Form
//           LayoutBuilder(
//             builder: (context, constraints) {
//               bool isWide = constraints.maxWidth > 600;
//               return Flex(
//                 direction: isWide ? Axis.horizontal : Axis.vertical,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     width: isWide ? constraints.maxWidth * 0.5 : double.infinity,
//                     child: Image.asset(
//                       "assets/images/about/contact-us.png",
//                       fit: BoxFit.cover,
//                       height: 250,
//                     ),
//                   ),
//                   SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 16),
//                   SizedBox(
//                     width: isWide ? constraints.maxWidth * 0.5 : double.infinity,
//                     child: Card(
//                       elevation: 3,
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           children: const [
//                             Text(
//                               "Send us a message",
//                               style: TextStyle(
//                                   fontSize: 20, fontWeight: FontWeight.bold),
//                             ),
//                             SizedBox(height: 16),
//                             // Thêm FormField ở đây
//                             Text("Form fields here..."),
//                           ],
//                         ),
//                       ),
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
// class ContactCard extends StatelessWidget {
//   final IconData icon;
//   final Color iconBgColor;
//   final String title;
//   final String description;
//   final String? buttonText;
//   final List<IconData>? socialIcons;
//   final VoidCallback? onPressed;
//
//   const ContactCard({
//     super.key,
//     required this.icon,
//     required this.iconBgColor,
//     required this.title,
//     required this.description,
//     this.buttonText,
//     this.socialIcons,
//     this.onPressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 250,
//       child: Card(
//         elevation: 3,
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               CircleAvatar(
//                 backgroundColor: iconBgColor,
//                 radius: 30,
//                 child: Icon(icon, size: 30, color: Colors.black54),
//               ),
//               const SizedBox(height: 10),
//               Text(title,
//                   style: const TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 8),
//               Text(description, textAlign: TextAlign.center),
//               const SizedBox(height: 12),
//               if (buttonText != null)
//                 ElevatedButton.icon(
//                   onPressed: onPressed,
//                   icon: const Icon(Icons.phone),
//                   label: Text(buttonText!),
//                   style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.grey.shade200,
//                       foregroundColor: Colors.black),
//                 ),
//               if (socialIcons != null)
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: socialIcons!
//                       .map((icon) => Padding(
//                     padding:
//                     const EdgeInsets.symmetric(horizontal: 4.0),
//                     child: Icon(icon),
//                   ))
//                       .toList(),
//                 ),
//             ],
//           ),
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

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
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
      final res = await http.get(Uri.parse("http://192.168.2.7:9999/api/regions"));
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
              Navigator.pop(ctx);
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
      appBar: AppBar(title: const Text("Contact Us")),
      // drawer: Drawer(
      //   child: ListView(
      //     children: [
      //       UserAccountsDrawerHeader(
      //         accountName: Text(account?.profile?.fullName ?? account?.username ?? "Guest"),
      //         accountEmail: Text(account?.email ?? "Not logged in"),
      //         currentAccountPicture: CircleAvatar(
      //           backgroundImage: (account?.profile?.avatarUrl != null && account!.profile!.avatarUrl!.isNotEmpty)
      //               ? NetworkImage(account!.profile!.avatarUrl!)
      //               : null,
      //           child: (account?.profile?.avatarUrl == null || account!.profile!.avatarUrl!.isEmpty)
      //               ? const Icon(Icons.person, size: 40)
      //               : null,
      //         ),
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.home),
      //         title: const Text("Home"),
      //         onTap: () => Navigator.pushReplacementNamed(context, '/'),
      //       ),
      //       ExpansionTile(
      //         leading: const Icon(Icons.location_on),
      //         title: const Text("Location"),
      //         children: regions.map((region) {
      //           return ExpansionTile(
      //             title: Text(region.name ?? ""),
      //             children: region.locations?.map((loc) {
      //               return ListTile(
      //                 title: Text(loc.name ?? ""),
      //                 onTap: () => Navigator.pushNamed(context, "/locations/${loc.locationId}"),
      //               );
      //             }).toList() ??
      //                 [],
      //           );
      //         }).toList(),
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.tour),
      //         title: const Text("Tour"),
      //         onTap: () => Navigator.pushReplacementNamed(context, '/tours'),
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.info),
      //         title: const Text('About Us'),
      //         onTap: () => Navigator.pushReplacementNamed(context, '/aboutus'),
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.contact_mail),
      //         title: const Text('Contact'),
      //         onTap: () => Navigator.pushReplacementNamed(context, '/contact'),
      //       ),
      //       const Divider(),
      //       if (account != null) ...[
      //         ListTile(
      //           leading: const Icon(Icons.person),
      //           title: const Text("Profile"),
      //           onTap: () => Navigator.pushNamed(context, '/profile'),
      //         ),
      //         ListTile(
      //           leading: const Icon(Icons.logout),
      //           title: const Text("Logout"),
      //           onTap: _handleLogout,
      //         ),
      //       ] else ...[
      //         ListTile(
      //           leading: const Icon(Icons.login),
      //           title: const Text("Login"),
      //           onTap: () async {
      //             Navigator.pop(context);
      //             final result = await Navigator.pushNamed(context, '/login');
      //             if (result != null && result is Account) {
      //               setState(() => account = result);
      //             }
      //           },
      //         ),
      //       ],
      //     ],
      //   ),
      // ),

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
          const Text(
            "Please contact and learn about us !!",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "GlobalTrip is always with you and ready to support all your questions, please contact us.",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 30),

          // Contact Cards
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: const [
                ContactCard(
                  icon: Icons.headset,
                  iconBgColor: Colors.lightBlueAccent,
                  title: "Call Us",
                  description: "GlobalTrip is always ready to support your questions.",
                  buttonText: "+0354 446 188",
                ),
                SizedBox(width: 16),
                ContactCard(
                  icon: Icons.email,
                  iconBgColor: Colors.redAccent,
                  title: "Email Us",
                  description: "Send us your questions via email.",
                  buttonText: "lmbaongoc2004@gmail.com",
                ),
                SizedBox(width: 16),
                ContactCard(
                  icon: Icons.public,
                  iconBgColor: Colors.yellowAccent,
                  title: "Social Media",
                  description: "Connect with us via social media.",
                  socialIcons: [Icons.facebook, Icons.youtube_searched_for],
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Image + Form
          LayoutBuilder(
            builder: (context, constraints) {
              bool isWide = constraints.maxWidth > 600;
              return Flex(
                direction: isWide ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: isWide ? constraints.maxWidth * 0.5 : double.infinity,
                    child: Image.asset(
                      "assets/images/about/contact-us.png",
                      fit: BoxFit.cover,
                      height: 250,
                    ),
                  ),
                  SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 16),
                  SizedBox(
                    width: isWide ? constraints.maxWidth * 0.5 : double.infinity,
                    child: Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: const [
                            Text(
                              "Send us a message",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 16),
                            Text("Form fields here..."),
                          ],
                        ),
                      ),
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

class ContactCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String description;
  final String? buttonText;
  final List<IconData>? socialIcons;

  const ContactCard({
    super.key,
    required this.icon,
    required this.iconBgColor,
    required this.title,
    required this.description,
    this.buttonText,
    this.socialIcons,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: iconBgColor,
                radius: 30,
                child: Icon(icon, size: 30, color: Colors.black54),
              ),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(description, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              if (buttonText != null)
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade200, foregroundColor: Colors.black),
                  child: Text(buttonText!),
                ),
              if (socialIcons != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: socialIcons!
                      .map((icon) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Icon(icon),
                  ))
                      .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
