import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/list_restaurant.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/ui/restaurant_detail_page.dart';

class CardRestaurant extends StatelessWidget {
  final RestaurantElement restaurants;
  const CardRestaurant({super.key, required this.restaurants});

  Padding _restaurantDescription(
      RestaurantElement restaurants, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            restaurants.name,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(
            height: 4,
          ),
          Expanded(
            flex: 2,
            child: RichText(
              text: TextSpan(
                children: [
                  const WidgetSpan(
                    child: Icon(
                      Icons.location_on_sharp,
                      size: 16,
                      color: Color(0xFFAE445A),
                    ),
                  ),
                  TextSpan(
                    text: restaurants.city,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: RichText(
              text: TextSpan(
                children: [
                  const WidgetSpan(
                    child: Icon(
                      Icons.star_rate_rounded,
                      size: 20,
                      color: Color(0xFFF39F5A),
                    ),
                  ),
                  TextSpan(
                    text: restaurants.rating.toString(),
                    style: Theme.of(context).textTheme.labelLarge,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<bool>(
          future: provider.isFavorited(restaurants.id),
          builder: (_, __) {
            return Material(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: InkWell(
                  child: SizedBox(
                    height: 100,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: restaurants.pictureId,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              'https://restaurant-api.dicoding.dev/images/small/${restaurants.pictureId}',
                              width: 120,
                              height: 100,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Expanded(
                          child: _restaurantDescription(restaurants, context),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, RestaurantDetailPage.routeName,
                        arguments: restaurants.id);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
