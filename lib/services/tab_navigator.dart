import 'package:flutter/material.dart';

class TabNavigator extends StatelessWidget {
  final Widget tabScreen;
  final String tabName;

  const TabNavigator({required this.tabScreen, required this.tabName});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (context) => tabScreen,
        );
      },
    );
  }
}
