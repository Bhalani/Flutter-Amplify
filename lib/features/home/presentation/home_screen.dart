import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import '../provider/sync_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _showWebView = false;
  String? _webViewUrl;
  final _callbackUrlPrefix =
      'http://192.168.116.123:8080/tink/callback/transactions';
  WebViewController? _controller;
  bool _isListening = false;

  void _openWebView(String url) {
    setState(() {
      _webViewUrl = url;
      _showWebView = true;
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onNavigationRequest: (request) {
              final uri = Uri.parse(request.url);
              final callbackUri = Uri.parse(_callbackUrlPrefix);
              if (uri.origin == callbackUri.origin &&
                  uri.path == callbackUri.path) {
                _closeWebView();
                return NavigationDecision.prevent;
              }
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

  Future<void> _handleSync() async {
    final notifier = ref.read(syncProvider.notifier);
    try {
      final result =
          await notifier.syncAndGetUrls(); // returns {url, callback_url}
      if (result != null) {
        final appCallback = 'treuewert://callback';
        // Attach the app callback as a query param to the backend url
        final uri = Uri.parse(result['url']!);
        final urlWithCallback = uri.replace(queryParameters: {
          ...uri.queryParameters,
          'redirect_uri': appCallback,
        }).toString();
        // Save the backend callback_url for later use
        setState(() {
          _webViewUrl = urlWithCallback;
          debugPrint('Opening WebView with URL: $urlWithCallback');
          _showWebView = true;
          _controller = WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setNavigationDelegate(
              NavigationDelegate(
                onNavigationRequest: (request) {
                  // When the app callback is hit, close the WebView
                  if (request.url.startsWith(appCallback)) {
                    _closeWebView();
                    // Extract params from the callback
                    final callbackUri = Uri.parse(request.url);
                    // Send params to backend callback_url
                    _sendParamsToBackend(
                        result['callback_url']!, callbackUri.queryParameters);
                    return NavigationDecision.prevent;
                  }
                  return NavigationDecision.navigate;
                },
              ),
            )
            ..loadRequest(Uri.parse(urlWithCallback));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sync failed: $e')),
        );
      }
    }
  }

  Future<void> _sendParamsToBackend(
      String backendCallbackUrl, Map<String, String> params) async {
    try {
      final uri = Uri.parse(backendCallbackUrl);
      final urlWithParams = uri.replace(queryParameters: {
        ...uri.queryParameters,
        ...params,
      }).toString();
      await http.get(Uri.parse(urlWithParams));
      debugPrint('Sent params to backend callback: $urlWithParams');
    } catch (e) {
      debugPrint('Failed to send params to backend callback: $e');
    }
  }

  void _handleCallbackSyncInProgress() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Sync in progress. You will be notified when details are updated.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isListening) {
      ref.listen<bool>(syncWebViewCloseProvider, (previous, next) {
        if (next == true && _showWebView) {
          _closeWebView();
          _handleCallbackSyncInProgress();
          ref.read(syncWebViewCloseProvider.notifier).state = false;
        }
      });
      _isListening = true;
    }
    final syncState = ref.watch(syncProvider);
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
                onPressed: syncState.isLoading ? null : _handleSync,
                child: syncState.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Sync'),
              ),
              const SizedBox(height: 24),
              syncState.when(
                data: (result) => result != null
                    ? Text('Hello Mr. ${result.firstName} ${result.lastName}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))
                    : const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
                error: (e, _) => Text('Error: $e',
                    style: const TextStyle(color: Colors.red)),
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
