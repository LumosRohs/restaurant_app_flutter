import 'dart:convert';

class Restaurant {
  bool error;
  String message;
  int count;
  List<RestaurantElement> restaurants;

  Restaurant({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  factory Restaurant.fromRawJson(String str) =>
      Restaurant.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        error: json["error"],
        message: json["message"],
        count: json["count"],
        restaurants: List<RestaurantElement>.from(
            json["restaurants"].map((x) => RestaurantElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "count": count,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
      };
}

class SearchRestaurant {
  bool error;
  int founded;
  List<RestaurantElement> restaurants;

  SearchRestaurant({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  factory SearchRestaurant.fromRawJson(String str) =>
      SearchRestaurant.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SearchRestaurant.fromJson(Map<String, dynamic> json) =>
      SearchRestaurant(
        error: json["error"],
        founded: json["founded"],
        restaurants: List<RestaurantElement>.from(
            json["restaurants"].map((x) => RestaurantElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "founded": founded,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
      };
}

class RestaurantElement {
  String id;
  String name;
  String description;
  String pictureId;
  String city;
  double rating;

  RestaurantElement({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory RestaurantElement.fromRawJson(String str) =>
      RestaurantElement.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RestaurantElement.fromJson(Map<String, dynamic> json) =>
      RestaurantElement(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        pictureId: json["pictureId"],
        city: json["city"],
        rating: json["rating"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "pictureId": pictureId,
        "city": city,
        "rating": rating,
      };
}
