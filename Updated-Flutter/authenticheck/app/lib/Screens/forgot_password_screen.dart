import 'package:flutter/material.dart';
import '../Api/auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  int _step = 0; // 0: email, 1: otp, 2: new password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  String? _email;

  Future<void> _sendOtp() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final result = await sendOtp(_emailController.text.trim());
      setState(() {
        _step = 1;
        _email = _emailController.text.trim();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'OTP sent to your email')),
      );
    } catch (e) {
      setState(() { _error = e.toString().replaceAll('Exception: ', ''); });
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  Future<void> _verifyOtp() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final result = await verifyOtp(_email!, _otpController.text.trim());
      setState(() { _step = 2; });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'OTP verified')),
      );
    } catch (e) {
      setState(() { _error = e.toString().replaceAll('Exception: ', ''); });
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  Future<void> _resetPassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() { _error = 'Passwords do not match'; });
      return;
    }
    setState(() { _isLoading = true; _error = null; });
    try {
      final result = await resetPassword(_email!, _newPasswordController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Password reset successful')),
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() { _error = e.toString().replaceAll('Exception: ', ''); });
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  Widget _buildEmailStep() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Forgot Password?',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
        ),
        const SizedBox(height: 8),
        const Text(
          'Enter the email address associated with your account',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            hintText: 'Email address',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 45,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _sendOtp,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal[700]),
            child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Continue', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 10),
          Text(_error!, style: const TextStyle(color: Colors.red)),
        ]
      ],
    );
  }

  Widget _buildOtpStep() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Get Your Code',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
        ),
        const SizedBox(height: 8),
        const Text(
          'Please enter the 4 digit code that was sent to your email address',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _otpController,
          maxLength: 4,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            hintText: 'Enter OTP',
            border: OutlineInputBorder(),
            counterText: '',
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('If you don\'t receive code. '),
            GestureDetector(
              onTap: _isLoading ? null : _sendOtp,
              child: const Text('Resend', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 45,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _verifyOtp,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal[700]),
            child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Verify and Proceed', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 10),
          Text(_error!, style: const TextStyle(color: Colors.red)),
        ]
      ],
    );
  }

  Widget _buildNewPasswordStep() {
    bool _obscureNew = true;
    bool _obscureConfirm = true;
    return StatefulBuilder(
      builder: (context, setState) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Enter New Password',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your new password must be different from previously used password',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _newPasswordController,
            obscureText: _obscureNew,
            decoration: InputDecoration(
              hintText: 'New password',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(_obscureNew ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _obscureNew = !_obscureNew),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirm,
            decoration: InputDecoration(
              hintText: 'Confirm password',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _resetPassword,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal[700]),
              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Reset Password', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 10),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ]
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: _step == 0
              ? _buildEmailStep()
              : _step == 1
                  ? _buildOtpStep()
                  : _buildNewPasswordStep(),
        ),
      ),
    );
  }
}

// You need to implement sendOtp, verifyOtp, and resetPassword in your Api/auth.dart 