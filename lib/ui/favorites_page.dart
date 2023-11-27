import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/widgets/card_restaurant.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  Widget _buildList() {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        if (provider.state == DBState.hasData) {
          return ListView.builder(
            itemCount: provider.favorites.length,
            itemBuilder: (context, index) {
              return CardRestaurant(restaurants: provider.favorites[index]);
            },
          );
        } else {
          return Center(
            child: Material(
              child: Text(provider.message),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text('Favorite Restaurants'),
      ),
      body: _buildList(),
    );
  }
}
