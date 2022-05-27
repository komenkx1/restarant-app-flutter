import 'package:restaurant_app/model/menu.dart';
import 'package:restaurant_app/model/review.dart';

class Restaurant {
  Restaurant(
      {required this.id,
      required this.name,
      required this.description,
      required this.pictureId,
      required this.city,
      required this.rating,
      this.menus,
      this.customerReviews});

  String id;
  String name;
  String description;
  String pictureId;
  String city;
  double rating;
  Menus? menus;
  List<Review>? customerReviews;

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        pictureId: json["pictureId"],
        city: json["city"],
        rating: json["rating"].toDouble(),
        menus: json["menus"] != null ? Menus.fromJson(json["menus"]) : null,
        customerReviews: json["customerReviews"] != null
            ? List<Review>.from(
                json["customerReviews"].map((x) => Review.fromJson(x)))
            : null,
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
