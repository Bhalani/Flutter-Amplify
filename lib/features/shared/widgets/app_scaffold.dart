import 'package:flutter/material.dart';
import 'app_bottom_nav.dart';

class AppScaffold extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onNavTap;
  final PreferredSizeWidget? appBar;
  final Widget body;
  final List<Widget>? floatingActions;

  const AppScaffold({
    super.key,
    required this.currentIndex,
    required this.onNavTap,
    this.appBar,
    required this.body,
    this.floatingActions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton:
          floatingActions != null && floatingActions!.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: floatingActions!,
                )
              : null,
      bottomNavigationBar: AppBottomNav(
        currentIndex: currentIndex,
        onTap: onNavTap,
      ),
    );
  }
}
