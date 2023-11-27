import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:restaurant_app/ui/favorites_page.dart';
import 'package:restaurant_app/ui/list_restaurant_page.dart';
import 'package:restaurant_app/ui/restaurant_detail_page.dart';
import 'package:restaurant_app/ui/settings_page.dart';
import 'package:restaurant_app/utils/notification_helper.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomNavIndex = 0;

  final NotificationHelper _notificationHelper = NotificationHelper();

  final List<Widget> _listWidget = [
    const ListRestaurantPage(),
    const FavoritesPage(),
    const SettingsPage(),
  ];

  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.placemark : Icons.fastfood),
      label: 'Restaurant',
    ),
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.heart : Icons.favorite),
      label: 'Favorites',
    ),
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.settings : Icons.settings),
      label: 'Settings',
    ),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _notificationHelper
        .configureSelectNotificationSubject(RestaurantDetailPage.routeName);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: _listWidget[_bottomNavIndex],
      bottomNavBar: PlatformNavBar(
        currentIndex: _bottomNavIndex,
        items: _bottomNavBarItems,
        itemChanged: _onBottomNavTapped,
        height: 80,
      ),
    );
  }
}
