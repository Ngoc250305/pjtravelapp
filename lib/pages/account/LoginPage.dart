import 'package:flutter/material.dart';
import 'package:pjtravelapp/entities/account.dart';
import 'package:pjtravelapp/pages/account/AuthProvider.dart';
import 'package:pjtravelapp/service/ApiService.dart';
import 'package:pjtravelapp/service/AuthService.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class LoginPage extends StatefulWidget {
  final void Function(Account account, dynamic token) onLoginSuccess;

  const LoginPage({super.key, required this.onLoginSuccess});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late VideoPlayerController _videoController;

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _videoController = VideoPlayerController.asset('assets/videos/rua.mp4')
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
          _videoController.setLooping(true);
          _videoController.play();
        }
      });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _usernameController.dispose();
    _passwordController.dispose();
    _videoController.pause();
    _videoController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _videoController.pause();
    } else if (state == AppLifecycleState.resumed) {
      _videoController.play();
    }
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Please enter all required fields.";
      });
      return;
    }

    print('🔍 Trying to login with username: $username');

    try {
      final loginResponse = await ApiService.login(username, password);

      setState(() {
        _isLoading = false;
      });

      if (loginResponse != null) {
        await _videoController.pause();

        final account = await ApiService.getAccountById(loginResponse.accountId);

        if (account == null) {
          print(' Failed to fetch account details.');
          setState(() {
            _errorMessage = "Failed to retrieve account information.";
          });
          return;
        }

        if (!account.isActive) {
          print('❌ Account is not activated.');
          if (mounted) {
            await Navigator.pushReplacementNamed(context, '/verify-otp', arguments: account.email);
          }
          return;
        }

        print('✅ Login successful. Account ID: ${loginResponse.accountId}');
        // Gọi login với token
        AuthService.currentAccount = account;
        AuthService.token = loginResponse.token;
        // widget.onLoginSuccess(account);
        widget.onLoginSuccess(account, loginResponse.token);



        if (mounted) {
          Navigator.pop(context, account);
          await Navigator.pushReplacementNamed(context, '/');
        }
      } else {
        print('❌ Incorrect username or password.');
        setState(() {
          _errorMessage = "Incorrect username or password.";
        });
      }
    } catch (e) {
      print('❌ Error during login: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = "An error occurred. Please try again later.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/'); // Quay về Home
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _videoController.value.isInitialized
              ? SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoController.value.size.width,
                height: _videoController.value.size.height,
                child: VideoPlayer(_videoController),
              ),
            ),
          )
              : Container(color: Colors.black),
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Card(
                  color: Colors.white.withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 12,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 16),
                        const Text(
                          'Welcome to GlobleTrip',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (_errorMessage != null)
                          Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        const SizedBox(height: 16),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : SizedBox(
                          width: double.infinity,
                          child:
                          ElevatedButton(
                            onPressed: _handleLogin,
                            child: const Text('Login'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue, // màu nền
                              foregroundColor: Colors.white,  // màu chữ
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/reset-password');
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(decoration: TextDecoration.underline),
                          ),
                        ),
                        const Divider(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/register');
                              },
                              child: const Text(
                                'Create Account',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
