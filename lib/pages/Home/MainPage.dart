
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pjtravelapp/entities/TourDetail.dart';
import 'dart:convert';
import 'package:pjtravelapp/pages/tour/tour_detail_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<dynamic> locations = [];
  List<dynamic> tours = [];
  // List<TourDetail> tours = [];
  bool loading = true;
  int locationPage = 1;
  int tourPage = 1;
  final int itemsPerPage = 4;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final responses = await Future.wait([
        http.get(Uri.parse('http://192.168.2.7:9999/api/locations')),
        http.get(Uri.parse('http://192.168.2.7:9999/api/tour-details')),
      ]);

      if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
        final locJson = jsonDecode(responses[0].body);
        final tourJson = jsonDecode(responses[1].body);

        setState(() {
          locations = locJson;
          tours = tourJson;
          loading = false;
        });
      } else {
        throw Exception("Server error: ${responses[0].statusCode}, ${responses[1].statusCode}");
      }
    } catch (e) {
      print('❌ Error fetching data: $e');
      setState(() => loading = false);
    }
  }

  List<dynamic> _getPaginatedItems(List<dynamic> list, int page) {
    final start = (page - 1) * itemsPerPage;
    return list.sublist(start, start + itemsPerPage > list.length ? list.length : start + itemsPerPage);
  }

  Widget _buildDotPagination(int totalItems, int currentPage, Function(int) onPageChange) {
    int totalPages = (totalItems / itemsPerPage).ceil();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        return GestureDetector(
          onTap: () => onPageChange(index + 1),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentPage == index + 1 ? Colors.blue : Colors.grey,
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
  
    final paginatedLocations = _getPaginatedItems(locations, locationPage);
    final paginatedTours = _getPaginatedItems(tours, tourPage);
  
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----------------- DESTINATIONS -----------------
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text("MOST VISITED DESTINATION", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: paginatedLocations.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final loc = paginatedLocations[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/locations/${loc['locationId']}');
                },
                child: Card(
                  elevation: 4,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/locations/${loc['imageUrl']}',
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(loc['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(loc['description'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          _buildDotPagination(locations.length, locationPage, (page) => setState(() => locationPage = page)),
  
          // ----------------- TOURS -----------------
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text("HOT TOURS", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12),
          // GridView.builder(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   shrinkWrap: true,
          //   physics: const NeverScrollableScrollPhysics(),
          //   itemCount: paginatedTours.length,
          //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 2,
          //     childAspectRatio: 0.8,
          //     crossAxisSpacing: 10,
          //     mainAxisSpacing: 10,
          //   ),
          //   itemBuilder: (context, index) {
          //     final tourJson = paginatedTours[index];
          //     final tour = TourDetail.fromJson(tourJson );
          //     return GestureDetector(
          //       onTap: () {
          //         // 👉 điều hướng sang trang chi tiết, truyền thẳng tour map
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (_) => TourDetailPage(tour: tour),
          //           ),
          //         );
          //       },
          //       child: Card(
          //         elevation: 4,
          //         child: Column(
          //           children: [
          //             Image.asset(
          //               'assets/images/tour_details/${tour['urls']}',
          //               height: 100,
          //               width: double.infinity,
          //               fit: BoxFit.cover,
          //             ),
          //             Padding(
          //               padding: const EdgeInsets.all(8.0),
          //               child: Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   Text(tour['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
          //                   Text(tour['title'] ?? '', style: const TextStyle(fontSize: 12)),
          //                   Text(tour['description'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
          //                   Text('${tour['price']} USD', style: const TextStyle(color: Colors.red)),
          //                   const SizedBox(height: 8),
          //                 ],
          //               ),
          //             )
          //           ],
          //         ),
          //       ),
          //     );
          //   },
          // ),
          GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: paginatedTours.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final tourJson = paginatedTours[index]; // Map<String, dynamic>
              final tour = TourDetail.fromJson(tourJson); // ✅ convert sang model
  
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TourDetailPage(tour: tour),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/tour_details/${tour.urls}',
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tour.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                            // Text(tour.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                            Text('${tour.price} USD', style: const TextStyle(color: Colors.red)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          _buildDotPagination(tours.length, tourPage, (page) => setState(() => tourPage = page)),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  
}
