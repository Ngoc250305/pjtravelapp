class Location {
   int? locationId;
   String? name;
   String? description;
   String? imageUrl;

  Location({
    this.locationId,
    this.name,
    this.description,
    this.imageUrl,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    locationId: json['locationId'],
    name: json['name'],
    description: json['description'],
    imageUrl: json['imageUrl'],
  );
   Map<String, dynamic> toJson() {
     return {
       'locationId': locationId,
       'name': name,
       'description': description,
       'imageUrl':imageUrl,
     };
   }


}
