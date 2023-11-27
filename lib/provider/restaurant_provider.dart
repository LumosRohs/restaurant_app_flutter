import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';

enum ResultState { loading, noData, hasData, error }

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider({required this.apiService}) {
    _fetchAllRestaurant();
  }

  late ResultState _state;

  String _message = '';
  String get message => _message;
  ResultState get state => _state;
  List _restaurants = [];
  List _searchResult = [];
  final List _filteredRestaurants = [];
  String query = '';
  List get result => _filteredRestaurants;

  Future<dynamic> _fetchAllRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await apiService.getRestaurantList();
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        _restaurants = restaurant.restaurants;
        _updateData();
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      if (e is SocketException) {
        return _message = 'No Internet Connection';
      } else {
        return _message = 'Failed to load list';
      }
    }
  }

  _updateData() {
    _filteredRestaurants.clear();
    if (query.isEmpty) {
      _filteredRestaurants.addAll(_restaurants);
    } else {
      _filteredRestaurants.addAll(_searchResult);
    }
    notifyListeners();
  }

  setQuery(String searchQuery) {
    query = searchQuery;
    _searchRestaurant(query);
  }

  Future<dynamic> _searchRestaurant(String query) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await apiService.searchRestaurant(query);
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        _searchResult = restaurant.restaurants;
        _updateData();
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      if (e is SocketException) {
        return _message = 'No Internet Connection';
      } else {
        return _message = 'Failed to load list';
      }
    }
  }
}
