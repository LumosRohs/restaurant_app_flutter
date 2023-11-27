import 'dart:convert';

class AddReview {
  bool error;
  String message;
  List<CustomerReview> customerReviews;

  AddReview({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  factory AddReview.fromRawJson(String str) =>
      AddReview.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddReview.fromJson(Map<String, dynamic> json) => AddReview(
        error: json["error"],
        message: json["message"],
        customerReviews: List<CustomerReview>.from(
            json["customerReviews"].map((x) => CustomerReview.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "customerReviews":
            List<dynamic>.from(customerReviews.map((x) => x.toJson())),
      };
}

class CustomerReview {
  String name;
  String review;
  String date;

  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  factory CustomerReview.fromRawJson(String str) =>
      CustomerReview.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerReview.fromJson(Map<String, dynamic> json) => CustomerReview(
        name: json["name"],
        review: json["review"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "review": review,
        "date": date,
      };
}
