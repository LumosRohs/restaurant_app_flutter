import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/list_restaurant.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/ui/list_restaurant_page.dart';

import 'widget_test.mocks.dart';

@GenerateMocks([RestaurantProvider])
void main() {
  group('List Restaurant Page test', () {
    late RestaurantProvider restaurantProvider;

    setUp(() {
      restaurantProvider = MockRestaurantProvider();
    });

    final restaurants = [
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
    ];

    final restaurantElements = restaurants
        .map((restaurant) => RestaurantElement.fromJson(restaurant))
        .toList();

    testWidgets('Check if ListView shows up', (WidgetTester tester) async {
      when(restaurantProvider.state).thenReturn(ResultState.hasData);
      when(restaurantProvider.result).thenReturn(restaurantElements);

      await mockNetworkImages(() async => await tester.pumpWidget(
            ChangeNotifierProvider<RestaurantProvider>(
              create: (context) => restaurantProvider,
              child: const MaterialApp(
                home: ListRestaurantPage(),
              ),
            ),
          ));

      final listViewFinder = find.byType(ListView);

      expect(listViewFinder, findsOneWidget);
    });
  });
}
