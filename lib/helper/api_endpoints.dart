class ApiEndpoint {
  static const baseEndpoints = "https://restaurant-api.dicoding.dev";

  static const getRestaurants = baseEndpoints + "/list";
  static const getRestaurantsDetail = baseEndpoints + "/detail";
  static const searchRestaurants = baseEndpoints + "/search";
  static const addRestaurantsReview = baseEndpoints + "/review";
}
