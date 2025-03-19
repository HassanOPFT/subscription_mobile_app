import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:subscription_mobile_app/models/subscription_model.dart';

class SubscriptionData {
  final List<Subscription> subscriptions;
  final double totalMonthlyCost;
  final double totalAnnualCost;

  SubscriptionData({
    required this.subscriptions,
    required this.totalMonthlyCost,
    required this.totalAnnualCost,
  });
}

class SubscriptionRepository {
  final String baseUrl = "http://10.0.2.2:8000/api/subscriptions/";

  Future<SubscriptionData> getSubscriptions() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;

        final double totalMonthlyCost =
            json.decode(response.body)['total_monthly_cost'];

        final double totalAnnualCost =
            json.decode(response.body)['total_annual_cost'];

        final subscriptions =
            data.map((e) => Subscription.fromJson(e)).toList();

        return SubscriptionData(
          subscriptions: subscriptions,
          totalMonthlyCost: totalMonthlyCost,
          totalAnnualCost: totalAnnualCost,
        );
      } else {
        throw Exception("Failed to load subscriptions");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createSubscription({
    required String name,
    required double price,
    required String billingCycle,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'price': price,
          'billing_cycle': billingCycle,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception("Failed to create subscription");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateSubscription({
    required int id,
    required String name,
    required double price,
    required String billingCycle,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse("$baseUrl$id/"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'price': price,
          'billing_cycle': billingCycle,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to update subscription");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteSubscription(int id) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl$id/"));

      if (response.statusCode != 200) {
        throw Exception("Failed to delete subscription");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getPriceHistory(int id) async {
    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:8000/api/price-history/$id/"),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body)['data'];
      } else {
        throw Exception("Failed to load price history");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> bulkCreateSubscription(http.MultipartFile file) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("http://10.0.2.2:8000/api/subscriptions/csv-upload/"),
      );
      request.files.add(file);

      final response = await request.send();

      if (response.statusCode != 201) {
        throw Exception("Failed to bulk create subscriptions");
      }
    } catch (e) {
      rethrow;
    }
  }
}
