import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:mockito/annotations.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';

import 'provider_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('Restaurant Provider Test', () {
    final client = MockClient();
    late RestaurantProvider restaurantProvider;

    setUp(() {
      restaurantProvider = RestaurantProvider(apiService: ApiService(client));
    });

    test('fetch all restaurant with data should return hasData', () async {
      final response = {
        "error": false,
        "message": "success",
        "count": 2,
        "restaurants": [
          {
            "id": "1",
            "name": "restaurant_1",
            "description": "description_1",
            "pictureId": "1",
            "city": "mock_city_1",
            "rating": 4.2
          },
          {
            "id": "2",
            "name": "restaurant_2",
            "description": "description_2",
            "pictureId": "2",
            "city": "mock_city_2",
            "rating": 5.0
          },
        ]
      };
      when(client.get(Uri.parse('https://restaurant-api.dicoding.dev/list')))
          .thenAnswer((_) async => http.Response(jsonEncode(response), 200));

      await restaurantProvider.fetchAllRestaurant();

      expect(restaurantProvider.state, ResultState.hasData);
    });

    test('fetch all restaurant with empty data should return noData', () async {
      final response = {
        "error": false,
        "message": "success",
        "count": 0,
        "restaurants": []
      };
      when(client.get(Uri.parse('https://restaurant-api.dicoding.dev/list')))
          .thenAnswer((_) async => http.Response(jsonEncode(response), 200));

      await restaurantProvider.fetchAllRestaurant();

      expect(restaurantProvider.state, ResultState.noData);
    });

    test('search restaurant with data should return hasData', () async {
      final response = {
        "error": false,
        "founded": 1,
        "restaurants": [
          {
            "id": "1",
            "name": "restaurant_1",
            "description": "description_1",
            "pictureId": "1",
            "city": "mock_city_1",
            "rating": 4.2
          },
          {
            "id": "2",
            "name": "restaurant_2",
            "description": "description_2",
            "pictureId": "2",
            "city": "mock_city_2",
            "rating": 5.0
          },
        ]
      };

      const query = "query";

      when(client.get(
              Uri.parse('https://restaurant-api.dicoding.dev/search?q=$query')))
          .thenAnswer((_) async => http.Response(jsonEncode(response), 200));

      await restaurantProvider.searchRestaurant(query);

      expect(restaurantProvider.state, ResultState.hasData);
    });

    test('search restaurant with empty data should return noData', () async {
      final response = {"error": false, "founded": 0, "restaurants": []};

      const query = "query";

      when(client.get(
              Uri.parse('https://restaurant-api.dicoding.dev/search?q=$query')))
          .thenAnswer((_) async => http.Response(jsonEncode(response), 200));

      await restaurantProvider.searchRestaurant(query);

      expect(restaurantProvider.state, ResultState.noData);
    });
  });
}
