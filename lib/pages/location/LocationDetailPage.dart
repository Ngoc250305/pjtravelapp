import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pjtravelapp/pages/location/HotelDetailPage.dart';

class LocationDetailPage extends StatefulWidget {
  final int locationId;

  const LocationDetailPage({super.key, required this.locationId});

  @override
  State<LocationDetailPage> createState() => _LocationDetailPageState();
}

class _LocationDetailPageState extends State<LocationDetailPage> {
  Map<String, dynamic>? location;
  List<dynamic> hotels = [];
  List<dynamic> restaurants = [];
  List<dynamic> dishes = [];
  List<dynamic> attractions = [];
  bool isLoading = true;

  // static const String baseIP = "192.168.5.107";
  //THu
  static const String baseIP = "192.168.1.195";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final locRes = await http.get(
        Uri.parse('http://$baseIP:9999/api/locations/${widget.locationId}'),
      );

      if (locRes.statusCode == 200 && locRes.body.isNotEmpty) {
        location = json.decode(locRes.body);
      }

      final responses = await Future.wait([
        http.get(
          Uri.parse(
            'http://$baseIP:9999/api/hotels/location/${widget.locationId}',
          ),
        ),
        http.get(
          Uri.parse(
            'http://$baseIP:9999/api/restaurants/location/${widget.locationId}',
          ),
        ),
        http.get(
          Uri.parse(
            'http://$baseIP:9999/api/dishes/location/${widget.locationId}',
          ),
        ),
        http.get(
          Uri.parse(
            'http://$baseIP:9999/api/attractions/location/${widget.locationId}',
          ),
        ),
      ]);

      if (responses[0].statusCode == 200) {
        hotels = json.decode(responses[0].body);
      }
      if (responses[1].statusCode == 200) {
        restaurants = json.decode(responses[1].body);
      }
      if (responses[2].statusCode == 200) {
        dishes = json.decode(responses[2].body);
      }
      if (responses[3].statusCode == 200) {
        attractions = json.decode(responses[3].body);
      }
    } catch (e) {
      print('❌ Fetch error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget buildCards(List<dynamic> items, String type) {
    if (items.isEmpty) return const SizedBox();

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final itemId = item['id'] ??
                item['hotelId'] ??
                item['restaurantId'] ??
                item['dishId'] ??
                item['attractionId'] ??
                item['locationId'];

            return GestureDetector(
              onTap: () {
                if (type == "hotel") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HotelDetailPage(hotelId: itemId),
                    ),
                  );
                }
                // TODO: thêm các detail page khác cho restaurant, dish, attraction
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.asset(
                        "assets/images/locations/${item['imageUrl']}",
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) {
                          return Image.asset(
                            "assets/images/no-image.jpg",
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        item['name'] ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (item['description'] != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          (item['description'] as String).length > 60
                              ? '${item['description'].substring(0, 60)}...'
                              : item['description'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (location == null) {
      return const Scaffold(body: Center(child: Text("Location not found")));
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Banner
            Stack(
              children: [
                Image.asset(
                  "assets/images/locations/${location!['imageUrl']}",
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print(
                      "❌ Asset not found: assets/images/locations/${location!['imageUrl']}",
                    );
                    return Image.asset(
                      "assets/images/no-image.jpg",
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  },
                ),
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location!['name'] ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        location!['country']?['name'] ?? '',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (location!['description'] != null) ...[
                    const Text(
                      "Overview",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(location!['description']),
                  ],
                  if (hotels.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      "Hotels in ${location!['name']}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    buildCards(hotels, "hotel"),
                  ],
                  if (restaurants.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      "Popular Restaurants",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    buildCards(restaurants, "restaurant"),
                  ],
                  if (dishes.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      "Local Dishes",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    buildCards(dishes, "dish"),
                  ],
                  if (attractions.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      "Top Attractions",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    buildCards(attractions, "attraction"),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:pjtravelapp/pages/location/HotelDetailPage.dart';

// class LocationDetailPage extends StatefulWidget {
//   const LocationDetailPage({super.key});

//   @override
//   State<LocationDetailPage> createState() => _LocationDetailPageState();
// }

// class _LocationDetailPageState extends State<LocationDetailPage> {
//   int? locationId;
//   Map<String, dynamic>? location;
//   List<dynamic> hotels = [];
//   List<dynamic> restaurants = [];
//   List<dynamic> dishes = [];
//   List<dynamic> attractions = [];
//   bool isLoading = true;

//   static const String baseIP = "192.168.1.195";

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     // ✅ Lấy locationId từ arguments khi push route
//     if (locationId == null) {
//       final args = ModalRoute.of(context)?.settings.arguments as Map?;
//       locationId = args?['locationId'] as int?;
//       if (locationId != null) {
//         fetchData();
//       } else {
//         setState(() => isLoading = false);
//       }
//     }
//   }

//   Future<void> fetchData() async {
//     if (locationId == null) return;

//     try {
//       final locRes = await http.get(
//         Uri.parse('http://$baseIP:9999/api/locations/$locationId'),
//       );

//       if (locRes.statusCode == 200 && locRes.body.isNotEmpty) {
//         location = json.decode(locRes.body);
//       }

//       final responses = await Future.wait([
//         http.get(Uri.parse('http://$baseIP:9999/api/hotels/location/$locationId')),
//         http.get(Uri.parse('http://$baseIP:9999/api/restaurants/location/$locationId')),
//         http.get(Uri.parse('http://$baseIP:9999/api/dishes/location/$locationId')),
//         http.get(Uri.parse('http://$baseIP:9999/api/attractions/location/$locationId')),
//       ]);

//       if (responses[0].statusCode == 200) {
//         hotels = json.decode(responses[0].body);
//       }
//       if (responses[1].statusCode == 200) {
//         restaurants = json.decode(responses[1].body);
//       }
//       if (responses[2].statusCode == 200) {
//         dishes = json.decode(responses[2].body);
//       }
//       if (responses[3].statusCode == 200) {
//         attractions = json.decode(responses[3].body);
//       }
//     } catch (e) {
//       print('❌ Fetch error: $e');
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   Widget buildCards(List<dynamic> items, String type) {
//     if (items.isEmpty) return const SizedBox();

//     return Column(
//       children: [
//         GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 16,
//             mainAxisSpacing: 16,
//             childAspectRatio: 0.8,
//           ),
//           itemCount: items.length,
//           itemBuilder: (context, index) {
//             final item = items[index];
//             final itemId = item['id'] ??
//                 item['hotelId'] ??
//                 item['restaurantId'] ??
//                 item['dishId'] ??
//                 item['attractionId'] ??
//                 item['locationId'];

//             return GestureDetector(
//               onTap: () {
//                 if (type == "hotel") {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => HotelDetailPage(hotelId: itemId),
//                     ),
//                   );
//                 }
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.15),
//                       blurRadius: 8,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                   color: Colors.white,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ClipRRect(
//                       borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//                       child: Image.asset(
//                         "assets/images/locations/${item['imageUrl']}",
//                         height: 120,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stack) {
//                           return Image.asset(
//                             "assets/images/no-image.jpg",
//                             height: 120,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                           );
//                         },
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8),
//                       child: Text(
//                         item['name'] ?? '',
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                     if (item['description'] != null)
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 8),
//                         child: Text(
//                           (item['description'] as String).length > 60
//                               ? '${item['description'].substring(0, 60)}...'
//                               : item['description'],
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(fontSize: 12, color: Colors.grey),
//                         ),
//                       ),
//                     const SizedBox(height: 8),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     if (location == null) {
//       return const Scaffold(body: Center(child: Text("Location not found")));
//     }

//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Hero Banner
//             Stack(
//               children: [
//                 Image.asset(
//                   "assets/images/locations/${location!['imageUrl']}",
//                   height: 250,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) {
//                     return Image.asset(
//                       "assets/images/no-image.jpg",
//                       height: 250,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                     );
//                   },
//                 ),
//                 Container(
//                   height: 250,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Colors.black.withOpacity(0.3),
//                         Colors.black.withOpacity(0.6),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   left: 16,
//                   bottom: 16,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         location!['name'] ?? '',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         location!['country']?['name'] ?? '',
//                         style: const TextStyle(
//                           color: Colors.white70,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),

//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (location!['description'] != null) ...[
//                     const Text(
//                       "Overview",
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(location!['description']),
//                   ],
//                   if (hotels.isNotEmpty) ...[
//                     const SizedBox(height: 24),
//                     Text(
//                       "Hotels in ${location!['name']}",
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     buildCards(hotels, "hotel"),
//                   ],
//                   if (restaurants.isNotEmpty) ...[
//                     const SizedBox(height: 24),
//                     const Text(
//                       "Popular Restaurants",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     buildCards(restaurants, "restaurant"),
//                   ],
//                   if (dishes.isNotEmpty) ...[
//                     const SizedBox(height: 24),
//                     const Text(
//                       "Local Dishes",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     buildCards(dishes, "dish"),
//                   ],
//                   if (attractions.isNotEmpty) ...[
//                     const SizedBox(height: 24),
//                     const Text(
//                       "Top Attractions",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     buildCards(attractions, "attraction"),
//                   ],
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
