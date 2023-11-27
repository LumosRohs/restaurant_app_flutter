import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/model/add_review.dart';
import 'package:restaurant_app/data/model/detail_restaurant.dart';
import 'package:restaurant_app/data/model/list_restaurant.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';
  final http.Client client;

  ApiService(this.client);

  Future<Restaurant> getRestaurantList() async {
    final response = await client.get(Uri.parse("$_baseUrl/list"));
    if (response.statusCode == 200) {
      return Restaurant.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }

  Future<DetailRestaurant> getRestaurantDetail(String id) async {
    final response = await client.get(Uri.parse("$_baseUrl/detail/$id"));
    if (response.statusCode == 200) {
      return DetailRestaurant.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }

  Future<SearchRestaurant> searchRestaurant(String query) async {
    final response = await client.get(Uri.parse("$_baseUrl/search?q=$query"));
    if (response.statusCode == 200) {
      return SearchRestaurant.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }

  Future<AddReview> addReview(String id, String name, String review) async {
    final response = await client.post(
      Uri.parse("$_baseUrl/review"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'id': id, 'name': name, 'review': review}),
    );
    if (response.statusCode == 201) {
      return AddReview.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error while adding review');
    }
  }
}
