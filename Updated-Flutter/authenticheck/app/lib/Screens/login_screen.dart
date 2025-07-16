import 'package:flutter/material.dart';
import 'dart:math';
import '../Api/auth.dart';
import 'student_dashboard.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _captchaController = TextEditingController();
  bool _isLoading = false;
  String _captchaText = '';
  String _captchaError = '';
  
  @override
  void initState() {
    super.initState();
    _generateCaptcha();
  }
  
  void _generateCaptcha() {
    final random = Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    _captchaText = String.fromCharCodes(
      Iterable.generate(6, (_) => chars.codeUnitAt(random.nextInt(chars.length)))
    );
    setState(() {});
  }
  
  bool _validateCaptcha() {
    if (_captchaController.text.trim().isEmpty) {
      setState(() {
        _captchaError = 'Please enter the captcha';
      });
      return false;
    }
    
    if (_captchaController.text.trim().toUpperCase() != _captchaText) {
      setState(() {
        _captchaError = 'Captcha is incorrect';
      });
      return false;
    }
    
    setState(() {
      _captchaError = '';
    });
    return true;
  }
  
  @override
  void dispose() {
    _captchaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Captcha Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Enter Captcha:',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: _generateCaptcha,
                          tooltip: 'Refresh Captcha',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        _captchaText,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                          color: Colors.grey.shade700,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _captchaController,
                      decoration: InputDecoration(
                        hintText: 'Enter the code above',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorText: _captchaError.isNotEmpty ? _captchaError : null,
                      ),
                      textCapitalization: TextCapitalization.characters,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () async {
                    // Validate captcha first
                    if (!_validateCaptcha()) {
                      return;
                    }
                    
                    setState(() { _isLoading = true; });
                    try {
                      final result = await login(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );
                      // On success, navigate to dashboard and pass email and fullName
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentDashboard(
                            userEmail: _emailController.text.trim(),
                            fullName: result['user']?['fullName'] ?? '',
                            institution: result['user']?['institution'] ?? '',
                            course: result['user']?['courseProgram'] ?? '',
                            yearGraduated: result['user']?['yearGraduated']?.toString() ?? '',
                          ),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result['message'] ?? 'Login successful')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
                      );
                    } finally {
                      setState(() { _isLoading = false; });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterScreen()),
                      );
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
