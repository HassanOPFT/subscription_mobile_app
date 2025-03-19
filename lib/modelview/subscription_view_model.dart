import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:subscription_mobile_app/repository/subscription_repository.dart';

final subscriptionProvider =
    StateNotifierProvider<SubscriptionViewModel, AsyncValue<SubscriptionData>>(
      (ref) => SubscriptionViewModel(),
    );

class SubscriptionViewModel
    extends StateNotifier<AsyncValue<SubscriptionData>> {
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

  Future<void> createSubscription({
    required String name,
    required double price,
    required String billingCycle,
  }) async {
    try {
      await repository.createSubscription(
        name: name,
        price: price,
        billingCycle: billingCycle,
      );
      await loadSubscriptions();
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
      await repository.updateSubscription(
        id: id,
        name: name,
        price: price,
        billingCycle: billingCycle,
      );
      await loadSubscriptions();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteSubscription(int id) async {
    try {
      await repository.deleteSubscription(id);
      await loadSubscriptions();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getPriceHistory(int id) async {
    try {
      return await repository.getPriceHistory(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> bulkCreateSubscription(http.MultipartFile file) async {
    try {
      await repository.bulkCreateSubscription(file);
      await loadSubscriptions();
    } catch (e) {
      rethrow;
    }
  }
}
