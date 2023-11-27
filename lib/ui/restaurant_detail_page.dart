import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/detail_restaurant.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/provider/detail_provider.dart';
import 'package:restaurant_app/ui/add_review_page.dart';
import 'package:http/http.dart' as http;

class RestaurantDetailPage extends StatefulWidget {
  static const routeName = '/restaurant_detail';

  final String restaurantId;

  const RestaurantDetailPage({super.key, required this.restaurantId});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  late DetailRestaurantElement restaurant;
  bool _isExpanded = false;

  Widget _getRestaurantData() {
    return Consumer<DetailProvider>(builder: (context, state, _) {
      if (state.state == DetailResultState.loading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state.state == DetailResultState.hasData) {
        var detail = state.result.restaurant;
        restaurant = detail;
        return _buildContent(context);
      } else if (state.state == DetailResultState.noData) {
        return Material(
          color: Colors.white,
          child: Center(
            child: Text(state.message),
          ),
        );
      } else if (state.state == DetailResultState.error) {
        return Material(
          color: Colors.white,
          child: Center(
            child: Text(state.message),
          ),
        );
      } else {
        return const Material(
          color: Colors.white,
          child: Center(
            child: Text(''),
          ),
        );
      }
    });
  }

  _restaurantPictureHero(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<bool>(
          future: provider.isFavorited(restaurant.id),
          builder: (context, snapshot) {
            var isFavorited = snapshot.data ?? false;
            return Hero(
              tag: restaurant.pictureId,
              child: Stack(
                children: [
                  Image.network(
                      'https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}'),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFAE445A),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: isFavorited
                        ? IconButton(
                            onPressed: () =>
                                provider.removeFavorite(restaurant.id),
                            icon: const Icon(
                              Icons.favorite_rounded,
                              color: Color(0xFFAE445A),
                              size: 30,
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              final restaurantData =
                                  provider.convertData(restaurant);
                              provider.addFavorite(restaurantData);
                            },
                            icon: const Icon(
                              Icons.favorite_border,
                              color: Color(0xFFAE445A),
                              size: 30,
                            ),
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Padding _restaurantDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _restaurantTitle(context),
          const SizedBox(
            height: 0,
          ),
          _restaurantCategories(),
          const SizedBox(
            height: 16,
          ),
          Text(
            'Address',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            restaurant.address,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            'Description',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(
            height: 8,
          ),
          _expandedDescriptionText(context),
        ],
      ),
    );
  }

  Column _restaurantReviews(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reviews',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color(0xFFDDA15A),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8.0), // Set border radius to 30
                    ),
                  ),
                ),
                child: Text(
                  'Add Review',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: Colors.white),
                ),
                onPressed: () {
                  final detailProvider =
                      Provider.of<DetailProvider>(context, listen: false);
                  Navigator.pushNamed(context, AddReviewPage.routeName,
                          arguments: widget.restaurantId)
                      .then((_) {
                    detailProvider.updateData(widget.restaurantId);
                    _getRestaurantData();
                  });
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: SizedBox(
            height: 150,
            child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(0),
                scrollDirection: Axis.horizontal,
                itemCount: restaurant.customerReviews.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Card(
                          color: const Color(0xFFF9E8C8),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.person_rounded,
                                  size: 80,
                                  color: Color(0xFFDDA15A),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        restaurant.customerReviews[index].name,
                                        overflow: TextOverflow.clip,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Flexible(
                                        child: Text(
                                          restaurant
                                              .customerReviews[index].review,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(color: Colors.black),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        restaurant.customerReviews[index].date,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }

  SizedBox _restaurantCategories() {
    return SizedBox(
      height: 48,
      child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(0),
          scrollDirection: Axis.horizontal,
          itemCount: restaurant.categories.length,
          itemBuilder: (context, index) {
            switch (restaurant.categories[index].name) {
              case 'Italia':
                return Card(
                  color: const Color(0xFF451952),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Center(
                        child: Text(
                      restaurant.categories[index].name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white),
                    )),
                  ),
                );
              case 'Modern':
                return Card(
                  color: const Color(0xFF91F3DC),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Center(
                        child: Text(
                      restaurant.categories[index].name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.black),
                    )),
                  ),
                );
              case 'Sop':
                return Card(
                  color: const Color(0xFFECABED),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Center(
                        child: Text(
                      restaurant.categories[index].name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.black),
                    )),
                  ),
                );
              case 'Spanyol':
                return Card(
                  color: const Color(0xFF008487),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Center(
                        child: Text(
                      restaurant.categories[index].name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white),
                    )),
                  ),
                );
              case 'Bali':
                return Card(
                  color: const Color(0xFF662101),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Center(
                        child: Text(
                      restaurant.categories[index].name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white),
                    )),
                  ),
                );
              case 'Jawa':
                return Card(
                  color: const Color(0xFF8E3F02),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Center(
                        child: Text(
                      restaurant.categories[index].name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white),
                    )),
                  ),
                );
              case 'Sunda':
                return Card(
                  color: const Color(0xFF32891C),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Center(
                        child: Text(
                      restaurant.categories[index].name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white),
                    )),
                  ),
                );
              default:
            }
            return Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Center(child: Text(restaurant.categories[index].name)),
              ),
            );
          }),
    );
  }

  Column _expandedDescriptionText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          restaurant.description,
          maxLines: _isExpanded ? null : 3,
          overflow: _isExpanded ? null : TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(
          height: 8,
        ),
        InkWell(
          child: Text(
            _isExpanded ? 'Read less' : 'Read more',
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: const Color(0xFF662549)),
          ),
          onTap: () => setState(() => _isExpanded = !_isExpanded),
        ),
      ],
    );
  }

  ListTile _restaurantTitle(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: Text(
        restaurant.name,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      subtitle: RichText(
        text: TextSpan(
          children: [
            const WidgetSpan(
              child: Icon(
                Icons.location_on_sharp,
                size: 20,
                color: Color(0xFFAE445A),
              ),
            ),
            TextSpan(
              text: restaurant.city,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
      trailing: RichText(
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
              text: restaurant.rating.toString(),
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }

  Column _foodsMenu(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            'Food Menu',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: SizedBox(
            height: 150,
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(0),
              scrollDirection: Axis.horizontal,
              itemCount: restaurant.menus.foods.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: 150,
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.fastfood_rounded,
                            size: 80,
                            color: Color(0xFFF39F5A),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            restaurant.menus.foods[index].name,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Column _drinksMenu(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            'Drink Menu',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: SizedBox(
            height: 150,
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              scrollDirection: Axis.horizontal,
              itemCount: restaurant.menus.drinks.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: 150,
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.fastfood_rounded,
                            size: 80,
                            color: Color(0xFFF39F5A),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(restaurant.menus.drinks[index].name),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  PlatformScaffold _buildContent(BuildContext context) {
    return PlatformScaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _restaurantPictureHero(context),
              _restaurantDetails(context),
              _restaurantReviews(context),
              _foodsMenu(context),
              _drinksMenu(context),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetailProvider>(
      create: (_) => DetailProvider(
          apiService: ApiService(http.Client()),
          restaurantId: widget.restaurantId),
      child: _getRestaurantData(),
    );
  }
}
