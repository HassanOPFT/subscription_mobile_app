import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:subscription_mobile_app/models/subscription_model.dart';

class SubscriptionRepository {
  final String baseUrl = "http://127.0.0.1:8000/api/subscriptions/";

  Future<List<Subscription>> getSubscriptions() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((e) => Subscription.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load subscriptions");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<void> createSubscription(Subscription subscription) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(subscription.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception("Failed to create subscription");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<void> updateSubscription(int id, Subscription subscription) async {
    try {
      final response = await http.patch(
        Uri.parse("$baseUrl$id/"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(subscription.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to update subscription");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<void> deleteSubscription(int id) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl$id/"));

      if (response.statusCode != 204) {
        throw Exception("Failed to delete subscription");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<List<dynamic>> getPriceHistory(int id) async {
    try {
      final response = await http.get(
        Uri.parse("http://127.0.0.1:8000/api/price-history/$id/"),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body)['data'];
      } else {
        throw Exception("Failed to load price history");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<void> bulkCreateSubscription(http.MultipartFile file) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("http://127.0.0.1:8000/api/subscriptions/csv-upload/"),
      );
      request.files.add(file);

      final response = await request.send();

      if (response.statusCode != 201) {
        throw Exception("Failed to bulk create subscriptions");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
