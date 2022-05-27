import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/model/restaurants.dart';
import 'package:restaurant_app/services/restaurant_service.dart';

void main() {
  test('should success to parsing data from api json', () async {
    // arrange
    var apiService = RestaurantServices();

    //act
    var restorantData = await apiService.getRestaurant();

    // assert
    expect(restorantData, isA<List<Restaurant>>());
  });

  // test('should success adding favorite restaurant', () async {
  //   // arrange
  //   WidgetsFlutterBinding.ensureInitialized();
  //   var databaseHelper = DatabaseHelper();
  //   var apiService = RestaurantServices();
  //   var restaurantProvider = RestaurantProvider(apiService: apiService);

  //   //act
  //   var restorantData = await apiService.getRestaurant();
  //   var restaurant = restorantData[1];
  //   await restaurantProvider.addFavorite(restaurant);
  //   var isFavorite = await databaseHelper.getFavorite();

  //   // assert
  //   var result = isFavorite.isNotEmpty ? true : false;
  //   expect(result, true);
  // });
}
