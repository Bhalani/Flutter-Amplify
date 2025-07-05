import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../provider/sync_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _showWebView = false;
  String? _webViewUrl;
  WebViewController? _controller;

  void _openWebView(String url) {
    setState(() {
      _webViewUrl = url;
      _showWebView = true;
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onNavigationRequest: (request) {
              // Optionally, close WebView on a certain callback URL if needed
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(url));
    });
  }

  void _closeWebView() {
    setState(() {
      _showWebView = false;
      _webViewUrl = null;
      _controller = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final syncUrlAsync = ref.watch(syncUrlProvider);
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Welcome to home page!',
                style: TextStyle(fontFamily: 'Lato', fontSize: 18),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: syncUrlAsync.isLoading
                    ? null
                    : () async {
                        final url = await ref.read(syncUrlProvider.future);
                        if (url != null) {
                          _openWebView(url);
                        } else {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Failed to get sync URL from backend.')),
                            );
                          }
                        }
                      },
                child: syncUrlAsync.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Sync'),
              ),
            ],
          ),
        ),
        if (_showWebView && _webViewUrl != null && _controller != null)
          Positioned.fill(
            child: SafeArea(
              child: WebViewWidget(controller: _controller!),
            ),
          ),
      ],
    );
  }
}
