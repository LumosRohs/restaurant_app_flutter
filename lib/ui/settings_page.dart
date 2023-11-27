import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/preferences_provider.dart';
import 'package:restaurant_app/provider/scheduling_provider.dart';
import 'package:restaurant_app/widgets/custom_dialog.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Widget _buildList(BuildContext context) {
    return Consumer<PreferencesProvider>(
      builder: (context, provider, child) {
        return ListView(
          children: [
            Material(
              child: ListTile(
                title: const Text('Dark Theme'),
                trailing: Switch.adaptive(
                  value: provider.isDarkTheme,
                  onChanged: (value) {
                    provider.enableDarkTheme(value);
                  },
                ),
              ),
            ),
            Material(
              child: ListTile(
                title: const Text('Scheduling Restaurants'),
                trailing: Consumer<SchedulingProvider>(
                  builder: (context, scheduled, _) {
                    return Switch.adaptive(
                      value: provider.isDailyRestaurantsActive,
                      onChanged: (value) async {
                        if (Platform.isIOS) {
                          customDialog(context);
                        } else {
                          scheduled.scheduledRestaurants(value);
                          provider.enableDailyRestaurants(value);
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text('Settings'),
      ),
      body: _buildList(context),
    );
  }
}
