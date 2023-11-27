import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/list_restaurant.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/ui/restaurant_detail_page.dart';

class ListRestaurantPage extends StatefulWidget {
  static const routeName = '/list_page';
  const ListRestaurantPage({super.key});

  @override
  State<ListRestaurantPage> createState() => _ListRestaurantPageState();
}

class _ListRestaurantPageState extends State<ListRestaurantPage> {
  final _searchController = TextEditingController();
  late RestaurantElement restaurant;

  @override
  dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildList() {
    return Consumer<RestaurantProvider>(builder: (context, state, _) {
      if (state.state == ResultState.loading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state.state == ResultState.hasData) {
        return ListView.builder(
          key: const Key('Restaurant List'),
          shrinkWrap: true,
          itemCount: state.result.length,
          itemBuilder: (context, index) {
            var result = state.result[index];
            restaurant = result;
            return _buildContent(context, restaurant);
          },
        );
      } else if (state.state == ResultState.noData) {
        return Center(
          child: Material(
            child: Text(state.message),
          ),
        );
      } else if (state.state == ResultState.error) {
        return Center(
          child: Material(
            child: Text(state.message),
          ),
        );
      } else {
        return const Center(
          child: Material(
            child: Text(''),
          ),
        );
      }
    });
  }

  Widget _buildContent(BuildContext context, RestaurantElement restaurants) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
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
  }

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
    final restaurantProvider =
        Provider.of<RestaurantProvider>(context, listen: false);
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search',
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            restaurantProvider.setQuery(value);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Restaurants',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Recommended Restaurants For You!',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: _buildList(),
            ),
          ],
        ),
      ),
    );
  }
}
