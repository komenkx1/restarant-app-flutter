import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/helper/api_endpoints.dart';
import 'package:restaurant_app/helper/endpoint_option.dart';
import 'package:restaurant_app/model/restaurants.dart';
import 'package:restaurant_app/services/restaurant_service.dart';

import 'fetch_unit_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('restaurantList', () {
    test('return a List Restaurant if the http call completes successfully',
        () async {
      final client = MockClient();
      EndpointOption endpointOption =
          EndpointOption(url: ApiEndpoint.getRestaurants);

      when(client.get(endpointOption.getData())).thenAnswer((_) async =>
          http.Response(
              '{"error": false,"message": "success","count": 20,"restaurants": []}',
              200));

      expect(await RestaurantServices(client: client).getRestaurant(),
          isA<List<Restaurant>>());
    });
    test('throws an exception if the http call completes with an error',
        () async {
      final client = MockClient();

      when(client.get(endpointOption.getData()))
          .thenAnswer((_) async => http.Response('Not Found', 200));
      expect(
          RestaurantServices(client: client).getRestaurant(), throwsException);
    });
  });
}
