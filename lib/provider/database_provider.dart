import 'package:restaurant_app/data/db/database_helper.dart';
import 'package:restaurant_app/data/model/detail_restaurant.dart';
import 'package:restaurant_app/data/model/list_restaurant.dart';
import 'package:flutter/foundation.dart';

enum DBState { loading, noData, hasData, error }

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}) {
    _getFavorites();
  }

  DBState? _state;
  DBState? get state => _state;

  String _message = '';
  String get message => _message;

  List<RestaurantElement> _favorites = [];
  List<RestaurantElement> get favorites => _favorites;

  void _getFavorites() async {
    _favorites = await databaseHelper.getFavorites();
    if (_favorites.isNotEmpty) {
      _state = DBState.hasData;
    } else {
      _state = DBState.noData;
      _message = 'Empty Data';
    }
    notifyListeners();
  }

  void addFavorite(RestaurantElement restaurant) async {
    try {
      await databaseHelper.insertFavorite(restaurant);
      _getFavorites();
    } catch (e) {
      _state = DBState.error;
      _message = 'Failed to add favorite';
      notifyListeners();
    }
  }

  Future<bool> isFavorited(String id) async {
    final favoritedRestaurant = await databaseHelper.getFavoriteById(id);
    return favoritedRestaurant.isNotEmpty;
  }

  void removeFavorite(String id) async {
    try {
      await databaseHelper.removeFavorite(id);
      _getFavorites();
    } catch (e) {
      _state = DBState.error;
      _message = 'Failed to remove favorite';
      notifyListeners();
    }
  }

  RestaurantElement convertData(DetailRestaurantElement restaurant) {
    final restaurantElement = RestaurantElement(
        id: restaurant.id,
        name: restaurant.name,
        description: restaurant.description,
        pictureId: restaurant.pictureId,
        city: restaurant.city,
        rating: restaurant.rating);
    return restaurantElement;
  }
}
