import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:subscription_mobile_app/repository/subscription_repository.dart';
import '../models/subscription_model.dart';

final subscriptionProvider = StateNotifierProvider<
  SubscriptionViewModel,
  AsyncValue<List<Subscription>>
>((ref) => SubscriptionViewModel());

class SubscriptionViewModel
    extends StateNotifier<AsyncValue<List<Subscription>>> {
  final SubscriptionRepository repository = SubscriptionRepository();

  SubscriptionViewModel() : super(const AsyncValue.loading()) {
    loadSubscriptions();
  }

  Future<void> loadSubscriptions() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await repository.getSubscriptions();
    });
  }

  Future<void> createSubscription(Subscription subscription) async {
    try {
      await repository.createSubscription(subscription);
      await loadSubscriptions();
    } catch (e) {
      throw Exception('Error creating subscription: $e');
    }
  }

  Future<void> updateSubscription(int id, Subscription subscription) async {
    try {
      await repository.updateSubscription(id, subscription);
      await loadSubscriptions();
    } catch (e) {
      throw Exception('Error updating subscription: $e');
    }
  }

  Future<void> deleteSubscription(int id) async {
    try {
      await repository.deleteSubscription(id);
      await loadSubscriptions();
    } catch (e) {
      throw Exception('Error deleting subscription: $e');
    }
  }

  Future<List<dynamic>> getPriceHistory(int id) async {
    try {
      return await repository.getPriceHistory(id);
    } catch (e) {
      throw Exception('Error fetching price history: $e');
    }
  }

  Future<void> bulkCreateSubscription(http.MultipartFile file) async {
    try {
      await repository.bulkCreateSubscription(file);
      await loadSubscriptions();
    } catch (e) {
      throw Exception('Error bulk creating subscriptions: $e');
    }
  }
}
