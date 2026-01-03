import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/deep_link_service.dart';

class DeepLinkInitializer extends ConsumerStatefulWidget {
  final Widget child;

  const DeepLinkInitializer({super.key, required this.child});

  @override
  ConsumerState<DeepLinkInitializer> createState() =>
      _DeepLinkInitializerState();
}

class _DeepLinkInitializerState extends ConsumerState<DeepLinkInitializer> {
  @override
  void initState() {
    super.initState();
    // Initialize deep link service after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DeepLinkService.initialize(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
