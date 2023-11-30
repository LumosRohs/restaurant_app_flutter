import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/widgets/card_restaurant.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  Future<bool> _checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  Widget _buildList() {
    return FutureBuilder<bool>(
      future: _checkInternetConnectivity(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.data == null || !snapshot.data!) {
          return const Center(
            child: Material(
              child: Text('No internet Connection'),
            ),
          );
        } else {
          return Consumer<DatabaseProvider>(
            builder: (context, provider, child) {
              if (provider.state == DBState.hasData) {
                return ListView.builder(
                  itemCount: provider.favorites.length,
                  itemBuilder: (context, index) {
                    return CardRestaurant(
                        restaurants: provider.favorites[index]);
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
