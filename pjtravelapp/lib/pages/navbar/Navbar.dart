// import 'package:flutter/material.dart';
// import 'package:pjtravelapp/service/ApiService.dart';
// import 'package:pjtravelapp/entities/region.dart';
// import 'package:pjtravelapp/entities/account.dart';
//
// class Navbar extends StatefulWidget {
//   final Account? account;
//   final Function() onLogout;
//
//   const Navbar({super.key, this.account, required this.onLogout});
//
//   @override
//   State<Navbar> createState() => _NavbarState();
// }
//
// class _NavbarState extends State<Navbar> {
//   List<Region> regions = [];
//   bool showLocationDropdown = false;
//   bool showUserDropdown = false;
//   bool showConfirmLogout = false;
//
//   @override
//   void initState() {
//     super.initState();
//     loadRegions();
//   }
//
//   Future<void> loadRegions() async {
//     try {
//       List<Region> fetchedRegions = await ApiService.getRegions();
//       for (var region in fetchedRegions) {
//         region.locations!= await ApiService.getLocationsByRegion(region.regionId!);
//       }
//       setState(() {
//         regions = fetchedRegions;
//       });
//     } catch (e) {
//       print("Error loading regions: $e");
//     }
//   }
//
//   void handleLogout() {
//     setState(() {
//       showConfirmLogout = true;
//     });
//   }
//
//   void confirmLogout() {
//     widget.onLogout();
//     setState(() => showConfirmLogout = false);
//   }
//
//   void cancelLogout() {
//     setState(() => showConfirmLogout = false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         AppBar(
//           title: const Text('GlobleTrip'),
//           actions: [
//             // Locations Dropdown
//             MouseRegion(
//               onEnter: (_) => setState(() => showLocationDropdown = true),
//               onExit: (_) => setState(() => showLocationDropdown = false),
//               child: PopupMenuButton<String>(
//                 onSelected: (_) {},
//                 child: const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 12),
//                   child: Text('Location'),
//                 ),
//                 itemBuilder: (_) => regions
//                     .map((region) => PopupMenuItem<String>(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(region.name ?? "", style: const TextStyle(fontWeight: FontWeight.bold)),
//                       ...region.locations.map((loc) => Padding(
//                         padding: const EdgeInsets.only(left: 8.0),
//                         child: Text(loc.name ?? ""),
//                       )),
//                     ],
//                   ),
//                 ))
//                     .toList(),
//               ),
//             ),
//
//             // User Login
//             widget.account != null
//                 ? PopupMenuButton(
//               icon: const Icon(Icons.person),
//               itemBuilder: (_) => [
//                 PopupMenuItem(
//                   child: ListTile(
//                     leading: const Icon(Icons.account_circle),
//                     title: Text(widget.account!.username ?? ""),
//                     onTap: () {
//                       // Navigator.push(
//                         // context,
//                          // MaterialPageRoute(builder: (_) => ProfilePage(account: widget.account!)),
//                       // );
//                     },
//                   ),
//                 ),
//                 PopupMenuItem(
//                   child: ListTile(
//                     leading: const Icon(Icons.logout),
//                     title: const Text("Logout"),
//                     onTap: handleLogout,
//                   ),
//                 )
//               ],
//             )
//                 : TextButton(
//               onPressed: () {
//                 // Navigator.push(
//                 //   context,
//                 //   MaterialPageRoute(builder: (_) => const LoginPage()),
//                 // );
//               },
//               child: const Text("Login", style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         ),
//
//         // Confirm Logout Dialog
//         if (showConfirmLogout)
//           AlertDialog(
//             title: const Text("Confirm Logout"),
//             content: const Text("Are you sure you want to log out?"),
//             actions: [
//               TextButton(onPressed: cancelLogout, child: const Text("No")),
//               ElevatedButton(onPressed: confirmLogout, child: const Text("Yes")),
//             ],
//           ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:pjtravelapp/entities/region.dart';
import 'package:pjtravelapp/entities/location.dart';
import 'package:pjtravelapp/service/ApiService.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  List<Region> regions = [];
  bool isDropdownOpen = false;
  bool showUserDropdown = false;
  bool showLogoutConfirm = false;
  String? username = "testUser"; // mock login

  @override
  void initState() {
    super.initState();
    loadRegions();
  }

  Future<void> loadRegions() async {
    try {
      List<Region> fetched = (await ApiService.getAllAccounts()).cast<Region>();
      setState(() {
        regions = fetched;
      });
    } catch (e) {
      print("Error loading regions: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PJTravel"),
        actions: [
          // 👉 Dropdown Region
          MouseRegion(
            onEnter: (_) => setState(() => isDropdownOpen = true),
            onExit: (_) => setState(() => isDropdownOpen = false),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Location"),
                  if (isDropdownOpen)
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: regions.map((region) {
                          return ExpansionTile(
                            title: Text(region.name ?? "Unknown Region"),
                            children: region.locations.map((loc) {
                              return ListTile(
                                title: Text(loc.name ?? "Unknown Location"),
                                onTap: () {
                                  print("Go to location: ${loc.locationId}");
                                },
                              );
                            }).toList(),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 20),

          // 👉 User icon
          username != null
              ? GestureDetector(
            onTap: () => setState(() => showUserDropdown = !showUserDropdown),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.person),
            ),
          )
              : TextButton(
            onPressed: () {
              // TODO: Navigate to login
            },
            child: const Text("Login"),
          ),

          // 👉 User dropdown
          if (showUserDropdown)
            Positioned(
              top: 60,
              right: 20,
              child: Material(
                child: Container(
                  width: 160,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black12),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(username ?? "Unknown"),
                        onTap: () {
                          // TODO: Navigate to profile/dashboard
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text("Logout"),
                        onTap: () {
                          setState(() {
                            showLogoutConfirm = true;
                            showUserDropdown = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),

      // 👉 Logout Confirm Dialog
      body: Stack(
        children: [
          const Center(child: Text("Welcome to PJTravel")),
          if (showLogoutConfirm)
            Center(
              child: AlertDialog(
                title: const Text("Confirm Logout"),
                content: const Text("Are you sure you want to logout?"),
                actions: [
                  TextButton(
                    onPressed: () => setState(() => showLogoutConfirm = false),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        username = null;
                        showLogoutConfirm = false;
                      });
                    },
                    child: const Text("Logout"),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
