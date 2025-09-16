import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pjtravelapp/service/ApiService.dart';
import 'package:video_player/video_player.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> with WidgetsBindingObserver {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());

  bool otpSent = false;
  bool loading = false;
  String message = '';
  Color messageColor = Colors.red;
  int timer = 300;
  Timer? countdownTimer;
  late VideoPlayerController _videoController;

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
    emailController.dispose();
    passwordController.dispose();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    countdownTimer?.cancel();
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

  void startTimer() {
    countdownTimer?.cancel();
    timer = 300;
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timerObj) {
      if (timer == 0) {
        timerObj.cancel();
      } else {
        setState(() {
          timer--;
        });
      }
    });
  }

  String formatTime(int seconds) {
    int m = seconds ~/ 60;
    int s = seconds % 60;
    return '${m}:${s.toString().padLeft(2, '0')}';
  }

  Future<void> handleSendOtp() async {
    setState(() {
      message = '';
    });

    if (emailController.text.isEmpty) {
      setState(() {
        messageColor = Colors.red;
        message = 'Please enter your email.';
      });
      return;
    }

    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(emailController.text)) {
      setState(() {
        messageColor = Colors.red;
        message = 'Please enter a valid email address.';
      });
      return;
    }

    try {
      setState(() {
        loading = true;
      });
      await ApiService.sendOtp(emailController.text);
      setState(() {
        otpSent = true;
        messageColor = Colors.green;
        message = 'OTP has been sent to your email.';
      });
      startTimer();
    } catch (e) {
      setState(() {
        messageColor = Colors.red;
        message = 'Failed to send OTP. Please try again.';
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> handleResetPassword() async {
    setState(() {
      message = '';
    });

    if (otpControllers.any((c) => c.text.isEmpty) || passwordController.text.isEmpty) {
      setState(() {
        messageColor = Colors.red;
        message = 'Please enter complete OTP and the new password.';
      });
      return;
    }

    if (timer == 0) {
      setState(() {
        messageColor = Colors.red;
        message = 'OTP expired. Please request a new one.';
      });
      return;
    }

    try {
      setState(() {
        loading = true;
      });
      final otp = otpControllers.map((c) => c.text).join('');
      await ApiService.resetPassword(emailController.text, otp, passwordController.text);

      setState(() {
        messageColor = Colors.green;
        message = 'Password reset successful. Redirecting to login...';
      });

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    } catch (e) {
      setState(() {
        messageColor = Colors.red;
        message = 'Reset failed. Please try again.';
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void resetOtpInput() {
    for (var controller in otpControllers) {
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Quay về Login
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
          Container(color: Colors.black.withOpacity(0.6)),
          Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Forgot Password',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    if (!otpSent) ...[
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Enter your email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: handleSendOtp,
                        child: const Text('Send OTP'),
                      ),
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(6, (index) {
                          return SizedBox(
                            width: 40,
                            child: TextField(
                              controller: otpControllers[index],
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                counterText: '',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 5) {
                                  FocusScope.of(context).nextFocus();
                                } else if (value.isEmpty && index > 0) {
                                  FocusScope.of(context).previousFocus();
                                }
                              },
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Time remaining: ${formatTime(timer)}',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Enter new password',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: timer == 0 ? null : handleResetPassword,
                        child: const Text('Confirm Password Reset'),
                      ),
                      const SizedBox(height: 8),
                      if (timer == 0)
                        Column(
                          children: [
                            const Text(
                              '❌ OTP expired. Please request a new one.',
                              style: TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  otpSent = false;
                                  message = '';
                                  resetOtpInput();
                                });
                              },
                              child: const Text('Request New OTP'),
                            ),
                          ],
                        ),
                    ],
                    const SizedBox(height: 16),
                    if (message.isNotEmpty)
                      Text(
                        message,
                        style: TextStyle(color: messageColor),
                      ),
                    if (loading)
                      const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
