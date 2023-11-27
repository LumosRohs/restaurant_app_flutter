import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/detail_restaurant.dart';

enum DetailResultState { loading, noData, hasData, error }

class DetailProvider extends ChangeNotifier {
  final ApiService apiService;
  final String restaurantId;

  DetailProvider({required this.apiService, required this.restaurantId}) {
    _fetchRestaurantDetail(restaurantId);
  }

  late DetailRestaurant _detailResult;
  late DetailResultState _state;

  String _message = '';
  String get message => _message;
  DetailRestaurant get result => _detailResult;
  DetailResultState get state => _state;

  updateData(String restaurantId) {
    _fetchRestaurantDetail(restaurantId);
  }

  Future<dynamic> _fetchRestaurantDetail(String restaurantId) async {
    try {
      _state = DetailResultState.loading;
      notifyListeners();
      final detail = await apiService.getRestaurantDetail(restaurantId);

      _state = DetailResultState.hasData;
      notifyListeners();
      return _detailResult = detail;
    } catch (e) {
      _state = DetailResultState.error;
      notifyListeners();
      if (e is SocketException) {
        return _message = 'No Internet Connection';
      } else {
        return _message = 'Failed to load the data';
      }
    }
  }
}
