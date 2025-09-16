import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pjtravelapp/entities/account.dart';
import 'package:pjtravelapp/entities/Region.dart';
import 'package:pjtravelapp/service/AuthService.dart';

class NavbarDrawer extends StatefulWidget {
  final Account? account;
  final Function onLogout;
  final Function onLogin;

  // final void Function(Account) onLogin;
  // final VoidCallback onLogout;
  const NavbarDrawer({
    super.key,
    required this.account,
    required this.onLogout,
    required this.onLogin,
  });

  @override
  State<NavbarDrawer> createState() => _NavbarDrawerState();
}

class _NavbarDrawerState extends State<NavbarDrawer> {
  List<Region> regions = [];
  bool showConfirmLogout = false;

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

  // void _handleLogout() => setState(() => showConfirmLogout = true);

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
              widget.onLogout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  void _confirmLogout() {
    widget.onLogout();
    setState(() => showConfirmLogout = false);
  }

  void _cancelLogout() => setState(() => showConfirmLogout = false);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(widget.account?.profile?.fullName ?? widget.account?.username ?? "Guest"),
                accountEmail: Text(widget.account?.email ?? "Not logged in"),
                currentAccountPicture:
                // CircleAvatar(
                //   backgroundImage: widget.account?.profile?.avatarUrl != null
                //       ? NetworkImage(widget.account!.profile!.avatarUrl!)
                //       : null,
                //   child: widget.account?.profile?.avatarUrl == null
                //       ? const Icon(Icons.person)
                //       : null,
                // ),
                CircleAvatar(
                  radius: 40,
                  backgroundImage: (widget.account?.profile?.avatarUrl != null &&
                      widget.account!.profile!.avatarUrl!.isNotEmpty)
                      ? AssetImage('assets/images/account/${widget.account!.profile!.avatarUrl!}')
                  as ImageProvider
                      : null,
                  child: (widget.account?.profile?.avatarUrl == null ||
                      widget.account!.profile!.avatarUrl!.isEmpty)
                      ? const Icon(Icons.person, size: 40)
                      : null,
                ),

        decoration: const BoxDecoration(color: Colors.blue),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text("Home"),
                onTap: () => Navigator.pushReplacementNamed(context, '/'),
              ),
              ExpansionTile(
                leading: const Icon(Icons.location_on),
                title: const Text("Location"),
                children: regions.map((region) {
                  return ExpansionTile(
                    title: Text(region.name ?? ""),
                    children: region.locations?.map((loc) {
                      return ListTile(
                        title: Text(loc.name ?? ""),
                        onTap: () => Navigator.pushNamed(context, "/locations/${loc.locationId}"),
                      );
                    }).toList() ?? [],
                  );
                }).toList(),
              ),
              ListTile(
                leading: const Icon(Icons.tour),
                title: const Text("Tour"),
                onTap: () => Navigator.pushReplacementNamed(context, '/tours'),
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('About Us'),
                onTap: () =>
                    Navigator.pushReplacementNamed(context, '/aboutus'),
              ),
              ListTile(
                leading: const Icon(Icons.contact_mail),
                title: const Text('Contact'),
                onTap: () =>
                    Navigator.pushReplacementNamed(context, '/contact'),
              ),
              const Divider(),
              if (widget.account != null) ...[
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text("Profile"),
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Logout"),
                  onTap: _handleLogout,
                ),
              ] else ...[
                // ListTile(
                //   leading: const Icon(Icons.login),
                //   title: const Text("Login"),
                //   // onTap: () => widget.onLogin(),
                //   onTap: () {
                //     Navigator.pop(context); // đóng Drawer
                //     Navigator.pushNamed(context, '/login');
                //   },
                // ),
                ListTile(
                  leading: const Icon(Icons.login),
                  title: const Text("Login"),
                  onTap: () async {
                    Navigator.pop(context); // đóng Drawer

                    // Chờ kết quả từ màn hình login
                    final result = await Navigator.pushNamed(context, '/login');

                    // Nếu login thành công thì result sẽ trả về Account
                    if (result != null && result is Account) {
                      AuthService.currentAccount = result;
                      setState(() {
                        // Cập nhật lại account ngay trong Drawer
                        // để đổi Login -> Profile + Logout
                        // (nếu bạn muốn callback ra ngoài, gọi luôn widget.onLogin(result))
                      });
                      widget.onLogin(result);
                    }
                  },
                ),

              ],

            ],
          ),
          if (showConfirmLogout)
            Positioned.fill(
              child: AlertDialog(
                title: const Text("Confirm Logout"),
                content: const Text("Are you sure you want to log out?"),
                actions: [
                  TextButton(onPressed: _cancelLogout, child: const Text("Cancel")),
                  ElevatedButton(
                    onPressed: _confirmLogout,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
