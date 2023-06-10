import 'dart:convert';

class Story {
  Story({
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.title,
    required this.detail,
    required this.body,
    required this.views,
    required this.likes,
    required this.username,
    this.id,
  });

  double latitude;
  double longitude;
  int radius;
  String title;
  String detail;
  String body;
  int views;
  int likes;
  String username;
  int? id;

  //factory Story.fromJson(String str) => Story.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Story.fromMap(Map<String, dynamic> json) => Story(
    latitude: json["latitude"],
    longitude: json["longitude"],
    id: json["id"],
    radius: json["radius"]?.toDouble(),
    title: json["title"],
    detail: json["detail"],
    body: json["body"],
    views: json["views"],
    likes: json["likes"],
    username: json["username"]
  );

  Map<String, dynamic> toMap() => {
    "latitude": latitude,
    "longitude": longitude,
    "id": id,
    "radius": radius,
    "title": title,
    "detail": detail,
    "body": body,
    "views": views,
    "likes": likes,
    "username": username
  };
}
