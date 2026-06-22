import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'vehicle_animated_screen.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/session_service.dart';

class OtpScreen extends StatefulWidget {
  final AuthService authService;
  final String phoneNumber;
  final bool isExistingUser;

  const OtpScreen({
    super.key, 
    required this.authService,
    required this.phoneNumber,
    required this.isExistingUser,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final SessionService sessionService = SessionService();
  
  int seconds = 30;
  Timer? timer;
  String errorMessage = "";
  bool isLoading = false;
  bool isOtpComplete = false;

  @override
  void initState() {
    super.initState();
    startTimer();
    for (int i = 0; i < 4; i++) {
      _controllers[i].addListener(_checkOtpCompletion);
      _focusNodes[i].addListener(() {
        if (mounted) setState(() {});
      });
    }
  }

  void startTimer() {
    timer?.cancel();
    setState(() {
      seconds = 30;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _checkOtpCompletion() {
    bool complete = true;
    for (var controller in _controllers) {
      if (controller.text.trim().isEmpty) {
        complete = false;
        break;
      }
    }
    if (complete != isOtpComplete) {
      setState(() {
        isOtpComplete = complete;
      });
    }
  }

  String getEnteredOtp() {
    return _controllers.map((c) => c.text.trim()).join();
  }

  Future<void> verifyOtp() async {
    final otp = getEnteredOtp();
    if (otp.length < 4) return;

    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    bool verified = widget.authService.verifyOtp(otp);

    if (verified) {
      debugPrint("🚨 THE ID CARD I AM HANDING THE WALLET IS: '${widget.authService.accessToken}'");
      await sessionService.saveToken(widget.authService.accessToken);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => VehicleAnimatedScreen(
              isExistingUser: widget.isExistingUser,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    } else {
      if (mounted) {
        setState(() {
          errorMessage = "Invalid OTP. Try again.";
        });
      }
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        "OTP Verification",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF0F0933)),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Enter the 4-digit code sent to your phone number",
                        style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 40),

                      // 4 Discrete Digit Inputs Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(4, (index) {
                          return Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAFBFE),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _focusNodes[index].hasFocus
                                    ? const Color(0xFF4313B8)
                                    : Colors.grey.shade200,
                                width: _focusNodes[index].hasFocus ? 2.0 : 1.0,
                              ),
                            ),
                            child: Focus(
                              onKeyEvent: (node, event) {
                                if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
                                  if (_controllers[index].text.isEmpty && index > 0) {
                                    FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                                    return KeyEventResult.handled;
                                  }
                                }
                                return KeyEventResult.ignored;
                              },
                              child: TextField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                maxLength: 1,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F0933)),
                                decoration: const InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                ),
                                onChanged: (val) {
                                  if (val.isNotEmpty) {
                                    if (index < 3) {
                                      _focusNodes[index + 1].requestFocus();
                                    } else {
                                      _focusNodes[index].unfocus();
                                      verifyOtp(); // Auto-verify on last digit
                                    }
                                  } else {
                                    if (index > 0) {
                                      _focusNodes[index - 1].requestFocus();
                                    }
                                  }
                                },
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 16),

                      // Error message view
                      if (errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                errorMessage,
                                style: const TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 16),

                      // Resend countdown indicator
                      Center(
                        child: seconds == 0
                            ? TextButton.icon(
                                onPressed: () async {
                                  await widget.authService.sendOtp(widget.phoneNumber.isNotEmpty ? widget.phoneNumber : "");
                                  startTimer();
                                },
                                icon: const Icon(Icons.refresh_rounded, size: 16, color: Color(0xFF4313B8)),
                                label: const Text(
                                  "Resend OTP",
                                  style: TextStyle(color: Color(0xFF4313B8), fontWeight: FontWeight.bold),
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFAFBFE),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: Colors.grey.shade100),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      width: 12,
                                      height: 12,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4313B8)),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Resend OTP in 00:${seconds.toString().padLeft(2, '0')}",
                                      style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),

              // Pinned Verify Button
              Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: (isLoading || !isOtpComplete) ? null : verifyOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4313B8),
                      disabledBackgroundColor: const Color(0xFF4313B8).withOpacity(0.4),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Verify OTP",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
