import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String phoneNumber = "";
  String otp = "";
  bool isOtpSent = false;

  void _onKeyPress(String value) {
    setState(() {
      if (!isOtpSent) {
        if (phoneNumber.length < 10) phoneNumber += value;
      } else {
        if (otp.length < 4) otp += value;
      }
    });
  }

  void _onBackspace() {
    setState(() {
      if (!isOtpSent) {
        if (phoneNumber.isNotEmpty) phoneNumber = phoneNumber.substring(0, phoneNumber.length - 1);
      } else {
        if (otp.isNotEmpty) otp = otp.substring(0, otp.length - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: isOtpSent ? AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.navyPrimary),
          onPressed: () => setState(() {
            isOtpSent = false;
            otp = "";
          }),
        ),
      ) : null,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (!isOtpSent) const SizedBox(height: 40),
                    Text(
                      isOtpSent ? 'Verify OTP' : 'Login',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navyPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isOtpSent
                          ? 'Enter the 4-digit code sent to \n+91 $phoneNumber'
                          : 'Enter your phone number to continue',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 48),
                    if (!isOtpSent) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(
                              '+91',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.navyPrimary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(width: 1, height: 24, color: Colors.grey[300]),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                phoneNumber.isEmpty ? 'Phone Number' : phoneNumber,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: phoneNumber.isEmpty ? Colors.grey[400] : AppColors.darkGrey,
                                  letterSpacing: phoneNumber.isEmpty ? 0 : 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(4, (index) {
                          bool isFilled = otp.length > index;
                          return Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isFilled ? AppColors.orangeSecondary : Colors.grey[300]!,
                                width: 2,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              isFilled ? otp[index] : "",
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkGrey,
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                    const SizedBox(height: 48),
                    ElevatedButton(
                      onPressed: () {
                        if (!isOtpSent) {
                          if (phoneNumber.length == 10) {
                            setState(() => isOtpSent = true);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('OTP sent to your phone')),
                            );
                          }
                        } else {
                          if (otp.length == 4) {
                            context.go('/dashboard');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.navyPrimary,
                        disabledBackgroundColor: Colors.grey[300],
                        minimumSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isOtpSent ? 'CONFIRM & LOGIN' : 'SEND OTP',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _NumericKeypad(
              onKeyPress: _onKeyPress,
              onBackspace: _onBackspace,
            ),
          ],
        ),
      ),
    );
  }
}

class _NumericKeypad extends StatelessWidget {
  final Function(String) onKeyPress;
  final VoidCallback onBackspace;

  const _NumericKeypad({required this.onKeyPress, required this.onBackspace});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          _buildRow(['1', '2', '3']),
          _buildRow(['4', '5', '6']),
          _buildRow(['7', '8', '9']),
          _buildLastRow(),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) => _KeyButton(text: key, onTap: () => onKeyPress(key))).toList(),
    );
  }

  Widget _buildLastRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SizedBox(width: 80, height: 80), // Placeholder
        _KeyButton(text: '0', onTap: () => onKeyPress('0')),
        _KeyButton(
          icon: Icons.backspace_outlined,
          onTap: onBackspace,
        ),
      ],
    );
  }
}

class _KeyButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback onTap;

  const _KeyButton({this.text, this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 80,
        height: 80,
        alignment: Alignment.center,
        child: icon != null
            ? Icon(icon, color: AppColors.navyPrimary, size: 28)
            : Text(
                text!,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navyPrimary,
                ),
              ),
      ),
    );
  }
}
