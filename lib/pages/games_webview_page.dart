import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'login_page.dart';

class AuthResult {
  final String token;
  const AuthResult({required this.token});
}

class GamesWebViewPage extends StatefulWidget {
  const GamesWebViewPage({
    super.key,
    required this.initialUrl,
    required this.cookieDomain,
    this.cookieName = 'jwt',
  });

  final String initialUrl;
  final String cookieDomain;  
  final String cookieName;

  @override
  State<GamesWebViewPage> createState() => _GamesWebViewPageState();
}

class _GamesWebViewPageState extends State<GamesWebViewPage> {
  late final WebViewController _controller;
  final WebViewCookieManager _cookieManager = WebViewCookieManager();

  String? _token = 'eyJraWQiOiJib042SkVrcU95dDJ5TFViMm0zWnZKSzNEMFhxcTRqclg0MnFzOEZsXC9VVT0iLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiI3MzU0ZjgwMi1kMDgxLTcwZjEtZjk0Mi1jZGU5Yjc1YTcxZDgiLCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAuZXUtY2VudHJhbC0xLmFtYXpvbmF3cy5jb21cL2V1LWNlbnRyYWwtMV8zWDRMbjFackciLCJjbGllbnRfaWQiOiI0aWE0M29zN2JjcmE2Y29ncnUydTEwOTVmdiIsIm9yaWdpbl9qdGkiOiJiYmU1YzJiOS1iYmY5LTQ4YjgtOTk4NS0wOWNhNTgwYTAzMDYiLCJldmVudF9pZCI6IjM2ZmZjZmQ0LTE4NTEtNDdmZi1hYjQwLTNmYWEwODFiZWFmMiIsInRva2VuX3VzZSI6ImFjY2VzcyIsInNjb3BlIjoiYXdzLmNvZ25pdG8uc2lnbmluLnVzZXIuYWRtaW4iLCJhdXRoX3RpbWUiOjE3NzIxMDYyNTcsImV4cCI6MTc3MjEwOTg1NywiaWF0IjoxNzcyMTA2MjU3LCJqdGkiOiI4ZWVjNTdjOS1kYzcwLTRhZGYtOWU5Ny1jZWVkODMxMGY3YjIiLCJ1c2VybmFtZSI6IjczNTRmODAyLWQwODEtNzBmMS1mOTQyLWNkZTliNzVhNzFkOCJ9.pV0ojAJ9-Zex0_5WxUTwwignRfMXYKinCuIXWKp-HaHD7HCDsjPVpQcLEndHrIoToJYa6aiPTsbkvjDQUcUxmDkCuAY0D5y11NHuto-wFqYeUudehgDW69_8zTnk4fJIWueISNVS5gl4c5gPyCqkPjHdq4qgpXM5h62VNPMA_GJAV5w-eu1N98wJCFHkzKT1SF1SRm18Yuglv5IQdlmF2S_tHhJ06DAqg80u5bvjd3cIhgNLit3lkda_7t-xJm3i-t4w010DZeGp5gykdWUWQ04j4zXGEktBYcTvnVp8vlxfd8FuSTedp21Gz90MWqbGojmHIfJqcXpUSSSKXxQYKA';
  bool _canGoBack = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (_) async {
            final canBack = await _controller.canGoBack();
            if (mounted) {
              setState(() {
                _isLoading = false;
                _canGoBack = canBack;
              });
            }
          },
          onWebResourceError: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
        ),
      );

    // Відкриваємо сайт (якщо токена нема — просто відкриє як гість)
    _openInitial();
  }

  Future<void> _openInitial() async {
    // Якщо токен вже є — поставимо cookie ДО відкриття
    if (_token != null) {
      await _setAuthCookie(_token!);
    }
    await _controller.loadRequest(Uri.parse(widget.initialUrl));
  }

  Future<void> _refreshCanGoBack() async {
    final canBack = await _controller.canGoBack();
    if (mounted) setState(() => _canGoBack = canBack);
  }

  Future<void> _goBack() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      await _refreshCanGoBack();
    }
  }

  Future<void> _setAuthCookie(String token) async {
    await _cookieManager.setCookie(
      WebViewCookie(
        name: widget.cookieName,
        value: token,
        domain: widget.cookieDomain,
        path: '/',
      ),
    );
  }

  Future<void> _openLogin() async {
    final result = await Navigator.of(context).push<AuthResult>(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );

    if (result == null) return;

    // зберігаємо токен в стані
    _token = result.token;

    // ставимо cookie і заново відкриваємо initialUrl (надійніше за reload)
    await _setAuthCookie(_token!);
    await _controller.loadRequest(Uri.parse(widget.initialUrl));

    await _refreshCanGoBack();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Games'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _canGoBack ? _goBack : null,
        ),
        actions: [
          TextButton(
            onPressed: _openLogin,
            child: const Text('Login'),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const LinearProgressIndicator(),
        ],
      ),
    );
  }
}