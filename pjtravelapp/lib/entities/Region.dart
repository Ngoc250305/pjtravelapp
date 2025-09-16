import 'Location.dart';

class Region {
   int? regionId;
   String? name;
   List<Location> locations;

   Region({
     this.regionId,
     this.name,
     this.locations = const [],
   });
  factory Region.fromJson(Map<String, dynamic> json) => Region(
    regionId: json['regionId'],
    name: json['name'],
    locations: (json['locations'] as List)
        .map((e) => Location.fromJson(e))
        .toList(),
  );
}
