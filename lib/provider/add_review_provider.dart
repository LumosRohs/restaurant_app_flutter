import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/add_review.dart';

enum AddReviewState { loading, noData, hasData, error }

class ReviewProvider extends ChangeNotifier {
  final ApiService apiService;

  ReviewProvider({required this.apiService});

  late AddReview _reviewResult;
  late AddReviewState _state;

  String _message = '';
  String get message => _message;
  AddReview get result => _reviewResult;
  AddReviewState get state => _state;

  Future<dynamic> addCustomerReview(
      String id, String name, String review) async {
    try {
      _state = AddReviewState.loading;
      notifyListeners();
      final response = await apiService.addReview(id, name, review);
      if (response.error == false && response.message == 'success') {
        _state = AddReviewState.hasData;
        notifyListeners();
        return _message = 'Your review has been added, thank you!';
      } else {
        _state = AddReviewState.noData;
        notifyListeners();
        return _message = 'Failed to add the review';
      }
    } catch (e) {
      _state = AddReviewState.error;
      notifyListeners();
      if (e is SocketException) {
        return _message = 'No Internet Connection';
      } else {
        return _message = 'Failed to add the review';
      }
    }
  }
}
