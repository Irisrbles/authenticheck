import 'package:flutter/material.dart';
import '../Api/auth.dart';

class ProfileContent extends StatefulWidget {
  final String userEmail;
  final String fullName;
  const ProfileContent({super.key, required this.userEmail, required this.fullName});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  final TextEditingController currentPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  late final TextEditingController emailController;
  late final TextEditingController fullNameController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.userEmail);
    fullNameController = TextEditingController(text: widget.fullName);
  }

  @override
  void dispose() {
    emailController.dispose();
    fullNameController.dispose();
    currentPassword.dispose();
    newPassword.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  bool isLengthValid = false;
  bool hasUppercase = false;
  bool hasLowercase = false;
  bool hasNumber = false;
  bool hasSpecialChar = false;

  bool showCurrentPassword = false;
  bool showNewPassword = false;
  bool showConfirmPassword = false;

  void _validatePassword(String password) {
    setState(() {
      isLengthValid = password.length >= 8;
      hasUppercase = password.contains(RegExp(r'[A-Z]'));
      hasLowercase = password.contains(RegExp(r'[a-z]'));
      hasNumber = password.contains(RegExp(r'[0-9]'));
      hasSpecialChar = password.contains(RegExp(r'[!@#\$%^&*]'));
    });
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 50),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirement(String text, bool isValid) {
    return Row(
      children: [
        Icon(Icons.circle, size: 6, color: isValid ? Colors.green : Colors.red),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: isValid ? Colors.green : Colors.red),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                child: const Icon(Icons.person, size: 50),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _showSuccessDialog("Profile Uploaded Successfully");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white, // White text
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Upload Picture"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildTextField(label: "Full Name", controller: fullNameController, enabled: false),
        const SizedBox(height: 10),
        _buildTextField(label: "Email", controller: emailController, enabled: false),
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Change Password", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              _buildPasswordField(
                label: "Current Password",
                controller: currentPassword,
                obscureText: !showCurrentPassword,
                toggleVisibility: () {
                  setState(() {
                    showCurrentPassword = !showCurrentPassword;
                  });
                },
              ),
              const SizedBox(height: 10),
              _buildPasswordField(
                label: "New Password",
                controller: newPassword,
                obscureText: !showNewPassword,
                toggleVisibility: () {
                  setState(() {
                    showNewPassword = !showNewPassword;
                  });
                },
                onChanged: _validatePassword,
              ),
              const SizedBox(height: 10),
              _buildPasswordField(
                label: "Confirm Password",
                controller: confirmPassword,
                obscureText: !showConfirmPassword,
                toggleVisibility: () {
                  setState(() {
                    showConfirmPassword = !showConfirmPassword;
                  });
                },
              ),
              const SizedBox(height: 15),
              const Text("Your password must:", style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              _buildRequirement("Be at least 8 characters long", isLengthValid),
              _buildRequirement("Contain at least one uppercase letter", hasUppercase),
              _buildRequirement("Contain at least one lowercase letter", hasLowercase),
              _buildRequirement("Contain at least one number", hasNumber),
              _buildRequirement("Contain a special character (!@#\$%^&*)", hasSpecialChar),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (!isLengthValid || !hasUppercase || !hasLowercase || !hasNumber || !hasSpecialChar) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please meet all password requirements.")),
                        );
                        return;
                      }
                      if (newPassword.text != confirmPassword.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("New password and confirm password do not match.")),
                        );
                        return;
                      }
                      try {
                        await changePassword(
                          email: emailController.text.trim(),
                          currentPassword: currentPassword.text.trim(),
                          newPassword: newPassword.text.trim(),
                        );
                        _showSuccessDialog("Password Updated Successfully");
                        currentPassword.clear();
                        newPassword.clear();
                        confirmPassword.clear();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white, // White text
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    ),
                    child: const Text("UPDATE"),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildTextField({required String label, TextEditingController? controller, bool enabled = true}) {
    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback toggleVisibility,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: toggleVisibility,
        ),
      ),
    );
  }
}
