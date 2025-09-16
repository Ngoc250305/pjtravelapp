
import 'package:flutter/material.dart';
import 'package:pjtravelapp/entities/region.dart';
import 'package:pjtravelapp/pages/Home/HomePage.dart';
import 'package:pjtravelapp/entities/account.dart';
import 'package:http/http.dart' as http;
import 'package:pjtravelapp/pages/Home/MainPage.dart';
import 'package:pjtravelapp/pages/aboutUs/AboutPage.dart';
import 'package:pjtravelapp/pages/aboutUs/ContactPage.dart';
import 'package:pjtravelapp/pages/account/AuthProvider.dart';
import 'package:pjtravelapp/pages/account/LoginPage.dart';
import 'package:pjtravelapp/pages/account/RegisterPage.dart';
import 'package:pjtravelapp/pages/account/ResetPasswordPage.dart';
import 'package:pjtravelapp/pages/account/VerifyOTPPage.dart';
import 'package:pjtravelapp/pages/location/LocationDetailPage.dart';
import 'package:pjtravelapp/pages/navbar/Navbar.dart';
import 'package:pjtravelapp/pages/userprofile/ProfilePage.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pjtravelapp/pages/tour/tour_list_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Account? currentAccount;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  int _currentIndex = 0;
  List<Region> regions = [];
  bool showConfirmLogout = false;

  Future<void> _login() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.2.7:9999/api/accounts/login'));
      if (response.statusCode == 200) {
        setState(() {
          currentAccount = Account.fromJson(jsonDecode(response.body));
        });
      }
    } catch (e) {
      debugPrint('Login error: $e');
    }
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

  Future<Map<String, dynamic>> _searchKeyword(String keyword) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.2.7:9999/api/search?keyword=$keyword'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      return {};
    } catch (e) {
      debugPrint('Search error: $e');
      return {};
    }
  }

  void _handleLogout() {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (dialogCtx) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => navigatorKey.currentState?.pop(), // ✅ dùng navigatorKey
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                currentAccount = null;
              });
              navigatorKey.currentState?.pop(); // đóng dialog
              navigatorKey.currentState?.pushReplacementNamed('/');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  void _confirmLogout() {
    setState(() {
      currentAccount = null;
      showConfirmLogout = false;
    });
    navigatorKey.currentState?.pushReplacementNamed('/');
  }

  void _cancelLogout() {
    setState(() => showConfirmLogout = false);
  }

  @override
  void initState() {
    super.initState();
    fetchRegions();
  }

  void onLoginSuccess(Account account, dynamic token) {
    // xử lý khi đăng nhập thành công
    if (mounted) {
      setState(() {
        currentAccount = account; // 👉 gán user vừa login
      });
    }
    // Điều hướng về Home
    navigatorKey.currentState?.pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PJTravel App',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.blue,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Scaffold(
          appBar: AppBar(
            title: const Row(
              children: [
                Icon(Icons.travel_explore, size: 28),
                SizedBox(width: 8),
                Text('GlobleTrip'),
              ],
            ),
            actions: [
              if (currentAccount != null)
                IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: _navigateToProfile,
                ),
            ],
          ),
          // drawer: _buildDrawer(),

          // drawer: NavbarDrawer(
          //   account: currentAccount,
          //   onLogout: () => debugPrint("Logout"),
          //   onLogin: () => debugPrint("Login pressed"),
          // ),
          drawer: NavbarDrawer(
            account: currentAccount,
            onLogout: () {
              debugPrint("Logout");
              setState(() {
                currentAccount = null; 
              });
            },
            onLogin: (account) {
              debugPrint("Login success: ${account.username}");
              setState(() {
                currentAccount = account; // 👉 cập nhật state
              });
            },
          ),

          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomePage(
                  onSearch: (keyword) async {
                    final results = await _searchKeyword(keyword);
                    navigatorKey.currentState?.pushNamed(
                      '/search-results',
                      arguments: results,
                    );
                  },
                ),
                const SizedBox(height: 16),
                MainPage(),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomNavBar(),
        ),
        '/tours': (context) => const TourListPage(),
        '/aboutus': (context) => const AboutPage(),
        '/contact': (context) => const ContactPage(),
        '/login': (context) => LoginPage(onLoginSuccess: onLoginSuccess),
        '/profile': (context) => const ProfilePage(),
        '/register': (context) => const RegisterPage(),
        '/verify-otp': (context) {
          final email = ModalRoute.of(context)!.settings.arguments as String;
          return VerifyOtpPage(email: email);
        },
        // '/location': (context) => const LocationDetailPage(),
        '/reset-password': (context) => const ResetPasswordPage(),
        '/search-results': (context) {
          final results = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(title: const Text('Search Results')),
            body: _buildSearchResults(results),
            bottomNavigationBar: _buildBottomNavBar(),
          );
        },
      },
    );
  }

  // Drawer _buildDrawer() {
  //   return Drawer(
  //     child: ListView(
  //       padding: EdgeInsets.zero,
  //       children: [
  //         UserAccountsDrawerHeader(
  //           accountName: Text(
  //             currentAccount?.profile?.fullName ?? currentAccount?.username ?? 'Guest',
  //           ),
  //           accountEmail: Text(currentAccount?.email ?? 'Not logged in'),
  //           currentAccountPicture: CircleAvatar(
  //             backgroundImage: currentAccount?.profile?.avatarUrl != null
  //                 ? NetworkImage(currentAccount!.profile!.avatarUrl!)
  //                 : null,
  //             child: currentAccount?.profile?.avatarUrl == null
  //                 ? const Icon(Icons.person)
  //                 : null,
  //           ),
  //           decoration: const BoxDecoration(color: Colors.blue),
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.home),
  //           title: const Text('Home'),
  //           onTap: () {
  //             navigatorKey.currentState?.pop();
  //             navigatorKey.currentState?.pushReplacementNamed('/');
  //           },
  //         ),
  //         ExpansionTile(
  //           leading: const Icon(Icons.location_on),
  //           title: const Text("Location"),
  //           children: regions.map((region) {
  //             return ExpansionTile(
  //               title: Text(region.name ?? ""),
  //               children: (region.locations ?? []).map((loc) {
  //                 return ListTile(
  //                   title: Text(loc.name ?? ""),
  //                   onTap: () {
  //                     navigatorKey.currentState?.pop();
  //                     navigatorKey.currentState?.pushNamed("/locations/${loc.locationId}");
  //                   },
  //                 );
  //               }).toList(),
  //             );
  //           }).toList(),
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.tour),
  //           title: const Text('Tour'),
  //           onTap: () {
  //             navigatorKey.currentState?.pop();
  //             navigatorKey.currentState?.pushReplacementNamed('/tours');
  //           },
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.account_circle_sharp),
  //           title: const Text('Contact'),
  //           onTap: () {
  //             navigatorKey.currentState?.pop();
  //             navigatorKey.currentState?.pushReplacementNamed('/aboutus');
  //           },
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.account_circle_sharp),
  //           title: const Text('About Us'),
  //           onTap: () {
  //             navigatorKey.currentState?.pop();
  //             navigatorKey.currentState?.pushReplacementNamed('/contac');
  //           },
  //         ),
  //         if (currentAccount != null) ...[
  //           ListTile(
  //             leading: const Icon(Icons.favorite),
  //             title: const Text('My Favorites'),
  //             onTap: () => navigatorKey.currentState?.pushNamed('/favorites'),
  //           ),
  //           ListTile(
  //             leading: const Icon(Icons.logout),
  //             title: const Text('Logout'),
  //             onTap: _handleLogout,
  //           ),
  //         ],
  //         const Divider(),
  //         if (currentAccount == null)
  //           ListTile(
  //             leading: const Icon(Icons.login),
  //             title: const Text('Login'),
  //             // onTap: _login,
  //             onTap: () {
  //               navigatorKey.currentState?.pop();
  //               navigatorKey.currentState?.pushReplacementNamed('/login');
  //             },
  //           ),
  //       ],
  //     ),
  //   );
  // }

  BottomNavigationBar _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        setState(() => _currentIndex = index);
        switch (index) {
          case 0:
            navigatorKey.currentState?.pushReplacementNamed('/');
            break;
          case 1:
            navigatorKey.currentState?.pushReplacementNamed('/search');
            break;
          case 2:
            navigatorKey.currentState?.pushReplacementNamed('/favorites');
            break;
          case 3:
            if (currentAccount != null) {
              _navigateToProfile();
            } else {
              _login();
            }
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }

  Widget _buildSearchResults(Map<String, dynamic> results) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: results.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.key.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            ...List<Widget>.from(entry.value.map<Widget>((item) {
              return ListTile(
                title: Text(item['name'] ?? ''),
                subtitle: item['description'] != null
                    ? Text(item['description'])
                    : null,
                onTap: () {},
              );
            })),
            const Divider(),
          ],
        );
      }).toList(),
    );
  }

  void _navigateToProfile() {
    if (currentAccount?.role == "admin") {
      navigatorKey.currentState?.pushNamed('/admin/dashboard');
    } else {
      navigatorKey.currentState?.pushNamed('/profile/${currentAccount?.accountId}');
    }
  }

  void _navigateToRegion(String? regionId) {
    if (regionId != null) {
      navigatorKey.currentState?.pushNamed('/region/$regionId');
    }
  }
}
