import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateTourAIDialog extends StatefulWidget {
  final bool open;
  final VoidCallback onClose;
  final Function(Map<String, dynamic>) onCreate;

  const CreateTourAIDialog({
    super.key,
    required this.open,
    required this.onClose,
    required this.onCreate,
  });

  @override
  State<CreateTourAIDialog> createState() => _CreateTourAIDialogState();
}

class _CreateTourAIDialogState extends State<CreateTourAIDialog> {
  Map<String, dynamic>? location;
  List<Map<String, dynamic>> locations = [];
  String maxPrice = "";
  String duration = "";
  bool loading = false;
  List<Map<String, String>> selectedPlaces = [];

  // sub-location mock kèm hình ảnh
  final Map<String, List<Map<String, String>>> subLocations = {
    "Japan": [
      {"name": "Tokyo", "image": "assets/images/tours/tokyo.jpg"},
      {"name": "Osaka", "image": "assets/images/tours/osaka.jpg"},
      {"name": "Kyoto", "image": "assets/images/tours/kyoto.jpg"},
    ],
    "Vietnam": [
      {"name": "Hà Nội", "image": "assets/images/tours/hanoi.jpg"},
      {"name": "Đà Nẵng", "image": "assets/images/tours/danang.jpg"},
      {"name": "Hồ Chí Minh", "image": "assets/images/tours/hochiminh.jpg"},
    ],
    "Indonesia": [
      {"name": "Jakarta", "image": "assets/images/tours/jakarta1.jpg"},
      {"name": "Bukittinggi", "image": "assets/images/tours/bukittinggi.jpg"},
      {"name": "Padang", "image": "assets/images/tours/padang.jpg"},
    ],
    "Angola": [
      {"name": "Miguel", "image": "assets/images/tours/miguel.jpg"},
      {"name": "Kalandula", "image": "assets/images/tours/kalandula.jpg"},
      {"name": "Kissama", "image": "assets/images/tours/kissama.jpg"},
      {"name": "Luanda", "image": "assets/images/tours/luanda.jpg"},
    ],
  };

  @override
  void initState() {
    super.initState();
    if (widget.open) {
      fetchLocations();
    }
  }

@override
void didUpdateWidget(covariant CreateTourAIDialog oldWidget) {
  super.didUpdateWidget(oldWidget);
  if (widget.open && !oldWidget.open) {
    fetchLocations();
  }
}

  Future<void> fetchLocations() async {
    try {
      final res = await http.get(Uri.parse("http://192.168.2.7:9999/api/locations"));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          locations = List<Map<String, dynamic>>.from(data);
        });
      } else {
        debugPrint("Lỗi tải location: ${res.statusCode}");
      }
    } catch (e) {
      debugPrint("Lỗi tải location: $e");
    }
  }

  void togglePlace(Map<String, String> place) {
    setState(() {
      if (selectedPlaces.any((p) => p["name"] == place["name"])) {
        selectedPlaces.removeWhere((p) => p["name"] == place["name"]);
      } else {
        selectedPlaces.add(place);
      }
    });
  }

  Future<void> handleSubmit() async {
    if (location == null) return;
    setState(() => loading = true);

    try {
      final token = ""; // TODO: lấy token nếu có (vd từ SharedPreferences)
      final headers = {
        "Content-Type": "application/json",
        if (token.isNotEmpty) "Authorization": "Bearer $token"
      };

      final url =
          "http://192.168.2.7:9999/api/ai-tours/generate?locationId=${location!["locationId"]}&maxPrice=$maxPrice&duration=$duration";

      final res = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode({
          "selectedPlaces": selectedPlaces.map((p) => p["name"]).toList(),
        }),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        widget.onCreate({...data, "isAI": true});
        widget.onClose();
      } else {
        debugPrint("Error creating AI tour: ${res.statusCode}");
      }
    } catch (e) {
      debugPrint("Error creating AI tour: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.open) return const SizedBox.shrink();

    return AlertDialog(
      title: const Text("Create tours using AI"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<Map<String, dynamic>>(
              value: location,
              items: locations
                  .map((loc) => DropdownMenuItem(
                        value: loc,
                        child: Text(loc["name"]),
                      ))
                  .toList(),
              onChanged: (newLoc) {
                setState(() {
                  location = newLoc;
                  selectedPlaces.clear();
                });
              },
              decoration: const InputDecoration(labelText: "Location"),
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: "Maximum budget"),
              keyboardType: TextInputType.number,
              onChanged: (v) => setState(() => maxPrice = v),
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: "Number of days"),
              keyboardType: TextInputType.number,
              onChanged: (v) => setState(() => duration = v),
            ),
            const SizedBox(height: 16),

            if (location != null &&
                subLocations.containsKey(location!["name"])) ...[
              const Text("Choose places to visit:"),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: subLocations[location!["name"]]!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final place = subLocations[location!["name"]]![index];
                  final selected =
                      selectedPlaces.any((p) => p["name"] == place["name"]);

                  return GestureDetector(
                    onTap: () => togglePlace(place),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selected ? Colors.blue : Colors.grey,
                          width: selected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(8)),
                              child: Image.asset(
                                place["image"]!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              place["name"]!,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: loading ? null : widget.onClose,
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: loading ? null : handleSubmit,
          child: Text(loading ? "Creating..." : "Create tours"),
        ),
      ],
    );
  }
}
