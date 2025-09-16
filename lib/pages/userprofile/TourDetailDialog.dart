import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TourDetailDialog extends StatelessWidget {
  final Map<String, dynamic>? selectedTour;
  final VoidCallback onClose;
  final Future<void> Function()? onGenerateAI;
  final Future<void> Function()? onSaveAI;
  final bool isLoading;
  final bool hasAiTour;

  const TourDetailDialog({
    super.key,
    required this.selectedTour,
    required this.onClose,
    this.onGenerateAI,
    this.onSaveAI,
    this.isLoading = false,
    this.hasAiTour = false,
  });

  String formatCurrency(dynamic value) {
    if (value == null) return "N/A";
    final formatter = NumberFormat.currency(locale: "en_US", symbol: "\$");
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    if (selectedTour == null) return const SizedBox.shrink();

    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      title: Container(
        padding: const EdgeInsets.all(16),
        color: Theme.of(context).primaryColor,
        child: Text(
          selectedTour!["title"] ?? "Untitled Tour",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: SizedBox(
  width: double.maxFinite,
  height: MediaQuery.of(context).size.height * 0.6, // dialog chiếm tối đa 60% màn hình
  child: SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Image
        if (selectedTour!["imageUrl"] != null &&
            selectedTour!["imageUrl"].isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/tours/${selectedTour!["imageUrl"]}',
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          )
        else
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(child: Text("No image available")),
          ),

        const SizedBox(height: 12),

        /// Description, Location, Price
        Text(
          selectedTour!["description"] ?? "No description available",
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text("Location: ${selectedTour!["location"]?["name"] ?? "Unknown"}"),
        Text("Price: ${formatCurrency(selectedTour!["price"])}"),
        const SizedBox(height: 8),

        /// Rating
        if (selectedTour!["rating"] != null)
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber[600], size: 20),
              const SizedBox(width: 4),
              Text("${selectedTour!["rating"]}/5"),
            ],
          ),

        const SizedBox(height: 16),

        /// Schedules
        if (selectedTour!["tourSchedules"] != null &&
            selectedTour!["tourSchedules"].isNotEmpty) ...[
          const Text(
            "Schedules:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Column(
            children: List.generate(
              selectedTour!["tourSchedules"].length,
              (i) {
                final schedule = selectedTour!["tourSchedules"][i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Day ${schedule["dayNumber"]}: ${schedule["notes"] ?? ""}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 6),

                        /// Activities
                        if (schedule["activities"] != null &&
                            schedule["activities"].isNotEmpty)
                          Column(
                            children: List.generate(
                              schedule["activities"].length,
                              (j) {
                                final act = schedule["activities"][j];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${act["timeFrom"]} - ${act["timeTo"]}: ${act["title"]}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                          "${act["description"]} @ ${act["location"]}"),

                                      /// Expenses
                                      if (act["expenses"] != null &&
                                          act["expenses"].isNotEmpty)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: List.generate(
                                            act["expenses"].length,
                                            (k) {
                                              final e = act["expenses"][k];
                                              return Text(
                                                "Expense: ${e["description"]} - ${formatCurrency(e["estimatedCost"])}",
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        else
                          const Text(
                            "No activities",
                            style: TextStyle(color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ] else
          const Text("No schedules available"),
      ],
    ),
  ),
),

      actions: [
        ElevatedButton(onPressed: onClose, child: const Text("Close")),
        // if (onGenerateAI != null)
        //   OutlinedButton(
        //     onPressed: isLoading ? null : onGenerateAI,
        //     child: Text(isLoading ? "Generating..." : "Generate AI Tour"),
        //   ),
        // if (hasAiTour && onSaveAI != null)
        //   ElevatedButton(
        //     style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
        //     onPressed: onSaveAI,
        //     child: const Text("Save AI Tour"),
        //   ),
      ],
    );
  }
}
