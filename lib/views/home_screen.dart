import 'package:flutter/material.dart';
import 'package:subscription_mobile_app/widgets/sub_manager_app_bar.dart';
import 'package:subscription_mobile_app/widgets/sub_manager_bottom_navigation_bar.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SubManagerAppBar(title: 'SubManager'),
      body: const Center(child: Text('Home')),
      bottomNavigationBar: SubManagerBottomNavigationBar(currentIndex: 0),
    );
  }
}
