// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// class HotelDetailPage extends StatefulWidget {
//   final int hotelId;
//
//   const HotelDetailPage({Key? key, required this.hotelId}) : super(key: key);
//
//   @override
//   _HotelDetailPageState createState() => _HotelDetailPageState();
// }
//
// class _HotelDetailPageState extends State<HotelDetailPage> {
//   Map<String, dynamic>? hotel;
//   List<dynamic> locations = [];
//   List<dynamic> reviews = [];
//
//   int userRating = 0;
//   String comment = "";
//   Map<int, String> replyContent = {};
//
//   final emojiMap = {
//     1: "😡",
//     2: "😕",
//     3: "😐",
//     4: "🙂",
//     5: "🤩",
//   };
//
//   @override
//   void initState() {
//     super.initState();
//     fetchHotelDetail();
//   }
//
//   Future<void> fetchHotelDetail() async {
//     final resHotel =
//     await http.get(Uri.parse("http://localhost:9999/api/hotels/${widget.hotelId}"));
//     final resLocations =
//     await http.get(Uri.parse("http://localhost:9999/api/locations"));
//     final resReviews =
//     await http.get(Uri.parse("http://localhost:9999/api/ratings/hotel/${widget.hotelId}"));
//
//     setState(() {
//       hotel = json.decode(resHotel.body);
//       locations = json.decode(resLocations.body);
//       reviews = json.decode(resReviews.body);
//     });
//   }
//
//   String getLocationName(int id) {
//     final loc = locations.firstWhere(
//           (l) => l["locationId"] == id,
//       orElse: () => null,
//     );
//     return loc != null ? loc["name"] : "Unknown";
//   }
//
//   Future<void> submitRating() async {
//     if (userRating == 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Please select a rating before submitting.")));
//       return;
//     }
//
//     final token = ""; // Lấy token từ storage (SharedPreferences)
//     final accountId = 1; // Lấy accountId từ storage
//
//     final res = await http.post(
//       Uri.parse("http://localhost:9999/api/ratings/createReview"),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token"
//       },
//       body: json.encode({
//         "rating": userRating,
//         "comment": comment.isNotEmpty ? comment : "No comment provided.",
//         "accountId": accountId,
//         "hotelId": hotel!["hotelId"],
//       }),
//     );
//
//     if (res.statusCode == 200) {
//       setState(() {
//         userRating = 0;
//         comment = "";
//       });
//       await fetchHotelDetail();
//     }
//   }
//
//   Future<void> submitReply(int parentId) async {
//     final replyText = replyContent[parentId] ?? "";
//     if (replyText.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Reply cannot be empty!")));
//       return;
//     }
//
//     final token = ""; // Lấy token từ storage
//     final accountId = 1;
//
//     final res = await http.post(
//       Uri.parse("http://localhost:9999/api/ratings/createReview"),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token"
//       },
//       body: json.encode({
//         "rating": null,
//         "comment": replyText,
//         "accountId": accountId,
//         "hotelId": hotel!["hotelId"],
//         "parentId": parentId,
//       }),
//     );
//
//     if (res.statusCode == 200) {
//       setState(() {
//         replyContent[parentId] = "";
//       });
//       await fetchHotelDetail();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (hotel == null) {
//       return Scaffold(
//         appBar: AppBar(title: Text("Hotel Detail")),
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(title: Text(hotel!["name"])),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.network(
//               "http://localhost:9999/images/locations/${hotel!["imageUrl"]}",
//               errorBuilder: (ctx, _, __) =>
//                   Image.asset("assets/images/no-image.jpg"),
//             ),
//             SizedBox(height: 12),
//             Text(
//               hotel!["name"],
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             Text("Location: ${getLocationName(hotel!["locationId"])}"),
//             SizedBox(height: 8),
//             Row(
//               children: List.generate(
//                 5,
//                     (i) => Text(
//                   emojiMap[i + 1]!,
//                   style: TextStyle(
//                     fontSize: 28,
//                     color: (hotel!["rating"] ?? 0) >= i + 1
//                         ? Colors.black
//                         : Colors.grey,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 12),
//             Text(hotel!["description"] ?? ""),
//             Divider(),
//
//             // User rating input
//             Text("Your Rating:", style: TextStyle(fontWeight: FontWeight.bold)),
//             Row(
//               children: List.generate(
//                 5,
//                     (i) => GestureDetector(
//                   onTap: () => setState(() => userRating = i + 1),
//                   child: Text(
//                     emojiMap[i + 1]!,
//                     style: TextStyle(
//                       fontSize: 32,
//                       color: userRating >= i + 1 ? Colors.black : Colors.grey,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             TextField(
//               decoration: InputDecoration(hintText: "Leave a comment..."),
//               onChanged: (val) => setState(() => comment = val),
//             ),
//             ElevatedButton(
//               onPressed: submitRating,
//               child: Text("Submit Rating"),
//             ),
//             Divider(),
//
//             // Reviews Section
//             Text("All Reviews", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             ...reviews.map((r) {
//               return Card(
//                 margin: EdgeInsets.symmetric(vertical: 8),
//                 child: Padding(
//                   padding: EdgeInsets.all(12),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(r["user"]?["username"] ?? "Anonymous",
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                       if (r["rating"] != null)
//                         Row(
//                           children: List.generate(
//                             5,
//                                 (i) => Text(
//                               emojiMap[i + 1]!,
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 color: r["rating"] >= i + 1
//                                     ? Colors.black
//                                     : Colors.grey,
//                               ),
//                             ),
//                           ),
//                         ),
//                       Text(r["comment"]),
//                       if (r["replies"] != null)
//                         Padding(
//                           padding: EdgeInsets.only(left: 20, top: 8),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: r["replies"]
//                                 .map<Widget>(
//                                   (rep) => Text(
//                                 "${rep["user"]?["username"] ?? "Admin"}: ${rep["comment"]}",
//                                 style: TextStyle(color: Colors.grey[700]),
//                               ),
//                             )
//                                 .toList(),
//                           ),
//                         ),
//                       Padding(
//                         padding: EdgeInsets.only(left: 20, top: 8),
//                         child: Column(
//                           children: [
//                             TextField(
//                               decoration:
//                               InputDecoration(hintText: "Write a reply..."),
//                               onChanged: (val) =>
//                               replyContent[r["id"]] = val,
//                             ),
//                             TextButton(
//                               onPressed: () => submitReply(r["id"]),
//                               child: Text("Reply"),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HotelDetailPage extends StatefulWidget {
  final int hotelId;

  const HotelDetailPage({Key? key, required this.hotelId}) : super(key: key);

  @override
  State<HotelDetailPage> createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage> {
  Map<String, dynamic>? hotel;
  List<dynamic> locations = [];
  List<dynamic> reviews = [];

  int userRating = 0;
  String comment = "";
  Map<int, String> replyContent = {};

  static const String baseIP = "192.168.1.195"; // chỉnh theo server của bạn

  final emojiMap = {
    1: "😡",
    2: "😕",
    3: "😐",
    4: "🙂",
    5: "🤩",
  };

  @override
  void initState() {
    super.initState();
    fetchHotelDetail();
  }

  Future<void> fetchHotelDetail() async {
    try {
      final resHotel = await http.get(
        Uri.parse("http://$baseIP:9999/api/hotels/${widget.hotelId}"),
      );
      final resLocations = await http.get(
        Uri.parse("http://$baseIP:9999/api/locations"),
      );
      final resReviews = await http.get(
        Uri.parse("http://$baseIP:9999/api/ratings/hotel/${widget.hotelId}"),
      );

      if (!mounted) return;

      setState(() {
        hotel = resHotel.statusCode == 200 ? json.decode(resHotel.body) : null;
        locations = resLocations.statusCode == 200
            ? json.decode(resLocations.body)
            : [];
        reviews = resReviews.statusCode == 200
            ? json.decode(resReviews.body)
            : [];
      });
    } catch (e) {
      debugPrint("❌ Fetch error: $e");
    }
  }

  String getLocationName(int id) {
    final loc = locations.cast<Map<String, dynamic>>().firstWhere(
          (l) => l["locationId"] == id,
      orElse: () => {},
    );
    return loc.isNotEmpty ? (loc["name"] ?? "Unknown") : "Unknown";
  }

  Future<void> submitRating() async {
    if (userRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a rating before submitting.")),
      );
      return;
    }

    final token = ""; // TODO: lấy token từ storage
    final accountId = 1; // TODO: lấy accountId từ storage

    try {
      final res = await http.post(
        Uri.parse("http://$baseIP:9999/api/ratings/createReview"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode({
          "rating": userRating,
          "comment": comment.isNotEmpty ? comment : "No comment provided.",
          "accountId": accountId,
          "hotelId": hotel?["hotelId"],
        }),
      );

      if (res.statusCode == 200) {
        setState(() {
          userRating = 0;
          comment = "";
        });
        await fetchHotelDetail();
      }
    } catch (e) {
      debugPrint("❌ Submit rating error: $e");
    }
  }

  Future<void> submitReply(int parentId) async {
    final replyText = replyContent[parentId] ?? "";
    if (replyText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Reply cannot be empty!")),
      );
      return;
    }

    final token = ""; // TODO: lấy token từ storage
    final accountId = 1;

    try {
      final res = await http.post(
        Uri.parse("http://$baseIP:9999/api/ratings/createReview"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode({
          "rating": null,
          "comment": replyText,
          "accountId": accountId,
          "hotelId": hotel?["hotelId"],
          "parentId": parentId,
        }),
      );

      if (res.statusCode == 200) {
        setState(() {
          replyContent[parentId] = "";
        });
        await fetchHotelDetail();
      }
    } catch (e) {
      debugPrint("❌ Submit reply error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (hotel == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Hotel Detail")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(hotel!["name"] ?? "Hotel Detail")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              "http://$baseIP:9999/images/locations/${hotel!["imageUrl"]}",
              errorBuilder: (ctx, _, __) =>
                  Image.asset("assets/images/no-image.jpg"),
            ),
            const SizedBox(height: 12),
            Text(
              hotel!["name"] ?? "",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text("Location: ${getLocationName(hotel!["locationId"] ?? 0)}"),
            const SizedBox(height: 8),
            Row(
              children: List.generate(
                5,
                    (i) => Text(
                  emojiMap[i + 1]!,
                  style: TextStyle(
                    fontSize: 28,
                    color: (hotel?["rating"] ?? 0) >= i + 1
                        ? Colors.black
                        : Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(hotel!["description"] ?? ""),
            const Divider(),

            /// User rating input
            const Text("Your Rating:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: List.generate(
                5,
                    (i) => GestureDetector(
                  onTap: () => setState(() => userRating = i + 1),
                  child: Text(
                    emojiMap[i + 1]!,
                    style: TextStyle(
                      fontSize: 32,
                      color: userRating >= i + 1 ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            TextField(
              decoration:
              const InputDecoration(hintText: "Leave a comment..."),
              onChanged: (val) => setState(() => comment = val),
            ),
            ElevatedButton(
              onPressed: submitRating,
              child: const Text("Submit Rating"),
            ),
            const Divider(),

            /// Reviews Section
            const Text("All Reviews",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ...reviews.map((r) {
              final replies = (r["replies"] ?? []) as List<dynamic>;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r["user"]?["username"] ?? "Anonymous",
                          style:
                          const TextStyle(fontWeight: FontWeight.bold)),
                      if (r["rating"] != null)
                        Row(
                          children: List.generate(
                            5,
                                (i) => Text(
                              emojiMap[i + 1]!,
                              style: TextStyle(
                                fontSize: 20,
                                color: (r["rating"] ?? 0) >= i + 1
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      Text(r["comment"] ?? ""),
                      if (replies.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: replies
                                .map<Widget>(
                                  (rep) => Text(
                                "${rep["user"]?["username"] ?? "Admin"}: ${rep["comment"]}",
                                style:
                                TextStyle(color: Colors.grey[700]),
                              ),
                            )
                                .toList(),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 8),
                        child: Column(
                          children: [
                            TextField(
                              decoration: const InputDecoration(
                                  hintText: "Write a reply..."),
                              onChanged: (val) =>
                              replyContent[r["id"]] = val,
                            ),
                            TextButton(
                              onPressed: () => submitReply(r["id"]),
                              child: const Text("Reply"),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
