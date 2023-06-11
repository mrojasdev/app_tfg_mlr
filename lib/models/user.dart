import 'dart:convert';

class User {
  User({
    required this.username,
    required this.passwd,
    required this.firstname,
    required this.lastname,
    required this.age,
    required this.email,
  });

  String username;
  String passwd;
  String firstname;
  String lastname;
  int age;
  String email;

  //factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
    username: json["username"],
    passwd: json["passwd"],
    firstname: json["firstname"],
    lastname: json["lastname"]?.toDouble(),
    age: json["age"],
    email: json["email"],
  );

  Map<String, dynamic> toMap() => {
    "username": username,
    "passwd": passwd,
    "firstname": firstname,
    "lastname": lastname,
    "age": age,
    "email": email,
  };
}
