import 'dart:convert';

class Place {
  Place({
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.title,
    required this.detail,
    required this.body,
    required this.image,
    required this.city,
    this.id,
  });

  double latitude;
  double longitude;
  int radius;
  String title;
  String detail;
  String body;
  String image;
  String city;
  int? id;

  //factory Place.fromJson(String str) => Place.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Place.fromMap(Map<String, dynamic> json) => Place(
    latitude: json["latitude"],
    longitude: json["longitude"],
    id: json["id"],
    radius: json["radius"]?.toDouble(),
    title: json["title"],
    detail: json["detail"],
    body: json["body"],
    image: json["image"],
    city: json["city"]
  );

  Map<String, dynamic> toMap() => {
    "latitude": latitude,
    "longitude": longitude,
    "id": id,
    "radius": radius,
    "title": title,
    "detail": detail,
    "body": body,
    "image": image,
    "city": city
  };
}
