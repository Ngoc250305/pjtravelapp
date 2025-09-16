import 'package:flutter/material.dart';
import 'package:pjtravelapp/entities/Tour.dart';
import 'package:pjtravelapp/entities/TourDetail.dart';

class PopularCardWidget extends StatelessWidget {
  final TourDetail tour;

  const PopularCardWidget({super.key, required this.tour});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh
          Image.network(
            'http://192.168.2.7:9999/images/tour_details/${tour.urls}',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 150,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 150,
              color: Colors.grey[300],
              child: const Icon(Icons.image_not_supported),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.red),
                    const SizedBox(width: 4),
                    Text(
                      tour.tourInfo.isNotEmpty ? tour.tourInfo.first : 'Vietnam',
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Title
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/tour-details',
                      arguments: tour.id,
                    );
                  },
                  child: Text(
                    tour.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                // Rating + reviews
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text("${tour.rating}"),
                    const SizedBox(width: 4),
                    Text(
                      "(${tour.reviews} reviews)",
                      style: const TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Spacer(),

          // Footer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "From \$${tour.price.toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.black54),
                    const SizedBox(width: 4),
                    Text("${tour.itineraries.length} days"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
