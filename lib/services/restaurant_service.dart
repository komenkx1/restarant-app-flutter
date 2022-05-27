import 'dart:convert';
import 'package:restaurant_app/helper/api_endpoints.dart';
import 'package:restaurant_app/helper/endpoint_option.dart';
import 'package:restaurant_app/model/restaurants.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/model/review.dart';

late EndpointOption endpointOption;

class RestaurantServices {
  _setHeaders() => {'Accept': 'application/json'};

  Future<List<Restaurant>> getRestaurant() async {
    endpointOption = EndpointOption(url: ApiEndpoint.getRestaurants);

    final response = await http.get(endpointOption.getData());
    final data = json.decode(response.body);

    if (data["restaurants"] != null) {
      List<Restaurant> listRestaurant =
          data["restaurants"].map<Restaurant>((json) {
        return Restaurant.fromJson(json);
      }).toList();
      return listRestaurant;
    }
    return [];
  }

  Future<List<Restaurant>> searchRestaurant(String querys) async {
    endpointOption =
        EndpointOption(url: ApiEndpoint.searchRestaurants, query: querys);

    final response = await http.get(endpointOption.getData());
    final data = json.decode(response.body);

    if (data["restaurants"] != null) {
      List<Restaurant> listRestaurant =
          data["restaurants"].map<Restaurant>((json) {
        return Restaurant.fromJson(json);
      }).toList();
      return listRestaurant;
    }
    return [];
  }

  Future<Restaurant> getDetailRestaurant(String id) async {
    endpointOption =
        EndpointOption(url: ApiEndpoint.getRestaurantsDetail, id: id);

    final response = await http.get(endpointOption.getData());
    final data = json.decode(response.body);

    Restaurant restaurant = Restaurant.fromJson(data["restaurant"]);
    return restaurant;
  }

  Future<List<Review>> addReviewRestaurant(String id, Review rewiewData) async {
    endpointOption = EndpointOption(url: ApiEndpoint.addRestaurantsReview);

    final response = await http
        .post(endpointOption.getData(), headers: _setHeaders(), body: {
      "id": id,
      "name": rewiewData.name,
      "review": rewiewData.review,
    });
    final data = json.decode(response.body);

    if (data["customerReviews"] != null) {
      List<Review> listReview = data["customerReviews"].map<Review>((json) {
        return Review.fromJson(json);
      }).toList();
      return listReview;
    }
    return [];
  }
}
