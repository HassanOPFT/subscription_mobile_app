import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:subscription_mobile_app/views/dashboard_screen.dart';
import 'package:subscription_mobile_app/views/subscriptions_screen.dart';

final List<String> mainScreenRoutes = [
  DashboardScreen.routeName,
  SubscriptionsScreen.routeName,
];

class SubManagerBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const SubManagerBottomNavigationBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        context.go(mainScreenRoutes[index]);
      },
      destinations: [
        _buildNavigationDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
          label: 'Home',
        ),
        _buildNavigationDestination(
          icon: const Icon(Icons.subscriptions_outlined),
          selectedIcon: const Icon(Icons.subscriptions),
          label: 'Subscriptions',
        ),
      ],
    );
  }

  NavigationDestination _buildNavigationDestination({
    required Icon icon,
    required String label,
    required Icon selectedIcon,
  }) {
    return NavigationDestination(
      icon: icon,
      selectedIcon: selectedIcon,
      label: label,
    );
  }
}
