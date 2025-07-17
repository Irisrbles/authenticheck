
// ignore_for_file: unused_import, unused_local_variable

import 'package:flutter/material.dart';
import '../Api/auth.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _yearGraduatedController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _diplomaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  bool _acceptedPrivacy = false;

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Privacy Policy'),
        content: SingleChildScrollView(
          child: Text('This privacy policy is applicable to the Authenticheck app (hereinafter referred to as "Application") for mobile devices, which was developed by ABC (hereinafter referred to as "Service Provider") as a a Freemium service. This service is provided "AS IS".\n\nWhat information does the Application obtain and how is it used?\nUser Provided Information\nThe Application acquires the information you supply when you download and register the Application. Registration with the Service Provider is not mandatory. However, bear in mind that you might not be able to utilize some of the features offered by the Application unless you register with them.\n\nThe Service Provider may also use the information you provided them to contact you from time to time to provide you with important information, required notices and marketing promotions.\n\nAutomatically Collected Information\nIn addition, the Application may collect certain information automatically, including, but not limited to, the type of mobile device you use, your mobile devices unique device ID, the IP address of your mobile device, your mobile operating system, the type of mobile Internet browsers you use, and information about the way you use the Application.\n\nDoes the Application collect precise real time location information of the device?\nThis Application does not gather precise information about the location of your mobile device.\n\nDo third parties see and/or have access to information obtained by the Application?\nOnly aggregated, anonymized data is periodically transmitted to external services to aid the Service Provider in improving the Application and their service. The Service Provider may share your information with third parties in the ways that are described in this privacy statement.\n\nPlease note that the Application utilizes third-party services that have their own Privacy Policy about handling data. Below are the links to the Privacy Policy of the third-party service providers used by the Application:\n\nGoogle Play Services\nThe Service Provider may disclose User Provided and Automatically Collected Information:\n\nas required by law, such as to comply with a subpoena, or similar legal process;\nwhen they believe in good faith that disclosure is necessary to protect their rights, protect your safety or the safety of others, investigate fraud, or respond to a government request;\nwith their trusted services providers who work on their behalf, do not have an independent use of the information we disclose to them, and have agreed to adhere to the rules set forth in this privacy statement.\n\nWhat are my opt-out rights?\nYou can halt all collection of information by the Application easily by uninstalling the Application. You may use the standard uninstall processes as may be available as part of your mobile device or via the mobile application marketplace or network.\n\nData Retention Policy, Managing Your Information\nThe Service Provider will retain User Provided data for as long as you use the Application and for a reasonable time thereafter. The Service Provider will retain Automatically Collected information for up to 24 months and thereafter may store it in aggregate. If you\'d like the Service Provider to delete User Provided Data that you have provided via the Application, please contact them at authenticheck19@gmail.com and we will respond in a reasonable time. Please note that some or all of the User Provided Data may be required in order for the Application to function properly.\n\nChildren\nThe Service Provider does not use the Application to knowingly solicit data from or market to children under the age of 13.\n\nThe Application does not address anyone under the age of 13. The Service Provider does not knowingly collect personally identifiable information from children under 13 years of age. In the case the Service Provider discover that a child under 13 has provided personal information, the Service Provider will immediately delete this from their servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact the Service Provider (authenticheck19@gmail.com) so that they will be able to take the necessary actions.\n\nSecurity\nThe Service Provider are concerned about safeguarding the confidentiality of your information. The Service Provider provide physical, electronic, and procedural safeguards to protect information we process and maintain. For example, we limit access to this information to authorized employees and contractors who need to know that information in order to operate, develop or improve their Application. Please be aware that, although we endeavor provide reasonable security for information we process and maintain, no security system can prevent all potential security breaches.\n\nChanges\nThis Privacy Policy may be updated from time to time for any reason. The Service Provider will notify you of any changes to the Privacy Policy by updating this page with the new Privacy Policy. You are advised to consult this Privacy Policy regularly for any changes, as continued use is deemed approval of all changes.\n\nThis privacy policy is effective as of 2025-07-16\n\nYour Consent\nBy using the Application, you are giving your consent to the Service Provider processing of your information as set forth in this Privacy Policy now and as amended by us. "Processing," means using cookies on a computer/hand held device or using or touching information in any way, including, but not limited to, collecting, storing, deleting, using, combining and disclosing information.\n\nContact us\nIf you have any questions regarding privacy while using the Application, or have questions about the practices, please contact the Service Provider via email at authenticheck19@gmail.com'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      try {
        final response = await register(
          fullName: _fullNameController.text,
          school: _schoolController.text,
          course: _courseController.text,
          yearGraduated: int.parse(_yearGraduatedController.text),
          email: _emailController.text,
          diploma: _diplomaController.text,
          password: _passwordController.text,
        );
        // Handle success (e.g., navigate to login or home)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful!')),
        );
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF00796B),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (value) => value!.isEmpty ? 'Enter full name' : null,
              ),
              TextFormField(
                controller: _schoolController,
                decoration: InputDecoration(labelText: 'School'),
                validator: (value) => value!.isEmpty ? 'Enter school' : null,
              ),
              TextFormField(
                controller: _courseController,
                decoration: InputDecoration(labelText: 'Course'),
                validator: (value) => value!.isEmpty ? 'Enter course' : null,
              ),
              TextFormField(
                controller: _yearGraduatedController,
                decoration: InputDecoration(labelText: 'Year Graduated'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter year graduated' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Enter email' : null,
              ),
              TextFormField(
                controller: _diplomaController,
                decoration: InputDecoration(labelText: 'Diploma'),
                validator: (value) => value!.isEmpty ? 'Enter diploma' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Enter password' : null,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _acceptedPrivacy,
                    onChanged: (value) {
                      setState(() {
                        _acceptedPrivacy = value!;
                      });
                    },
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: _showPrivacyPolicy,
                      child: Text.rich(
                        TextSpan(
                          text: 'I have read and accept the ',
                          children: [
                            TextSpan(
                              text: 'data protection policy',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (!_acceptedPrivacy)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'You must accept the data protection policy to register.',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              if (_errorMessage != null)
                Text(_errorMessage!, style: TextStyle(color: Colors.red)),
              ElevatedButton(
                onPressed: _isLoading || !_acceptedPrivacy ? null : _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00796B),
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(color: Colors.white),
                ),
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Register', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
