import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pjtravelapp/entities/Region.dart';
import 'dart:convert';

import 'package:pjtravelapp/entities/TourDetail.dart';
import 'package:pjtravelapp/pages/navbar/Navbar.dart';
import 'package:pjtravelapp/entities/account.dart';
import 'tour_detail_page.dart';

class TourListPage extends StatefulWidget {
  const TourListPage({Key? key}) : super(key: key);

  @override
  State<TourListPage> createState() => _TourListPageState();
}

class _TourListPageState extends State<TourListPage> {
  bool loading = true;
  List<TourDetail> tours = [];

  List<TourDetail> filteredTours = [];

  String searchText = "";
  String selectedLocation = "All Locations";
  double? minPrice;
  double? maxPrice;
  double? minRating;

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
  void initState() {
    super.initState();
    fetchAllTours();
  }

  Future<void> fetchAllTours() async {
    setState(() => loading = true);
    try {
      final res = await http.get(Uri.parse("http://192.168.2.7:9999/api/tour-details"));
      if (res.statusCode == 200) {
        final body = json.decode(res.body);
        final data = body is List ? body : body['content'] ?? [];
        setState(() {
          tours = List<TourDetail>.from(
            data.map((item) => TourDetail.fromJson(item)),
          );
        });
      } else {
        throw Exception("HTTP ${res.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ Error fetching tours: $e");
      setState(() => tours = []);
    } finally {
      setState(() => loading = false);
    }
  }

  void applyFilters() {
    setState(() {
      filteredTours = tours.where((tour) {
        final matchSearch = tour.title.toLowerCase().contains(searchText.toLowerCase());
        final matchLocation = selectedLocation == "All Locations" || tour.location == selectedLocation;
        final matchPrice = (minPrice == null || tour.price >= minPrice!) &&
            (maxPrice == null || tour.price <= maxPrice!);
        final matchRating = (minRating == null || tour.rating >= minRating!);
        return matchSearch && matchLocation && matchPrice && matchRating;
      }).toList();
    });
  }

  void resetFilters() {
    setState(() {
      searchText = "";
      selectedLocation = "All Locations";
      minPrice = null;
      maxPrice = null;
      minRating = null;
      filteredTours = tours;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Tours")),
      appBar: AppBar(
          title: const Text("Tours"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      const Text("Location", style: TextStyle(fontWeight: FontWeight.bold)),
                      DropdownButton<String>(
                        value: selectedLocation,
                        isExpanded: true,
                        items: ["All Locations", "Hanoi", "Danang", "HCMC"]
                            .map((loc) => DropdownMenuItem(value: loc, child: Text(loc)))
                            .toList(),
                        onChanged: (value) {
                          selectedLocation = value!;
                          applyFilters();
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text("Price Range", style: TextStyle(fontWeight: FontWeight.bold)),
                      TextField(
                        decoration: const InputDecoration(labelText: "Min Price"),
                        keyboardType: TextInputType.number,
                        onChanged: (val) => minPrice = double.tryParse(val),
                      ),
                      TextField(
                        decoration: const InputDecoration(labelText: "Max Price"),
                        keyboardType: TextInputType.number,
                        onChanged: (val) => maxPrice = double.tryParse(val),
                      ),
                      const SizedBox(height: 16),
                      const Text("Minimum Rating", style: TextStyle(fontWeight: FontWeight.bold)),
                      DropdownButton<double>(
                        value: minRating,
                        hint: const Text("Any"),
                        isExpanded: true,
                        items: [null, 1, 2, 3, 4, 5]
                            .map((r) => DropdownMenuItem(
                          value: r?.toDouble(),
                          child: Text(r == null ? "Any" : "$r+"),
                        ))
                            .toList(),
                        onChanged: (value) {
                          minRating = value;
                          applyFilters();
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          applyFilters();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        child: const Text("Apply Filters"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          resetFilters();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                        child: const Text("Reset Filters"),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      // drawer: NavbarDrawer(
      //   account: currentAccount,
      //   onLogout: () => debugPrint("Logout"),
      //   onLogin: () => debugPrint("Login pressed"),
      // ),
      drawer: NavbarDrawer(
        account:  currentAccount,
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


      body: loading
          ? const Center(child: CircularProgressIndicator())
          : tours.isEmpty
          ? const Center(child: Text("No tours found."))
          : GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 cột giống card bên React
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75, // tỉ lệ card
        ),
        itemCount: tours.length,
        itemBuilder: (context, index) {
          final tour = tours[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TourDetailPage(tour: tour),
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: tour.urls.isNotEmpty
                        ? Image.asset(
                      'assets/images/tour_details/${tour.urls}',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                        : Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image,
                        size: 40,
                      ),
                    ),
                  ),

                  // Nội dung
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tour.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              "${tour.rating}",
                              style:
                              const TextStyle(fontSize: 12),
                            ),
                            const Spacer(),
                            Text(
                              "\$${tour.price}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
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
