import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'profile_content.dart';

class StudentDashboard extends StatefulWidget {
  final String userEmail;
  final String fullName;
  final String institution;
  final String course;
  final String yearGraduated;
  const StudentDashboard({
    super.key,
    required this.userEmail,
    required this.fullName,
    required this.institution,
    required this.course,
    required this.yearGraduated,
  });

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  bool isDrawerOpen = false;
  String selectedItem = 'Home';
  bool _termsAccepted = false; 
  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Terms & Conditions'),
          content: SingleChildScrollView(
            child: Text(
              'These terms and conditions apply to the Authenticheck app (hereby referred to as "Application") for mobile devices that was created by ABC (hereby referred to as "Service Provider") as a Freemium service.\n\n'
              'Upon downloading or utilizing the Application, you are automatically agreeing to the following terms. It is strongly advised that you thoroughly read and understand these terms prior to using the Application. Unauthorized copying, modification of the Application, any part of the Application, or our trademarks is strictly prohibited. Any attempts to extract the source code of the Application, translate the Application into other languages, or create derivative versions are not permitted. All trademarks, copyrights, database rights, and other intellectual property rights related to the Application remain the property of the Service Provider.\n\n'
              'The Service Provider is dedicated to ensuring that the Application is as beneficial and efficient as possible. As such, they reserve the right to modify the Application or charge for their services at any time and for any reason. The Service Provider assures you that any charges for the Application or its services will be clearly communicated to you.\n\n'
              'The Application stores and processes personal data that you have provided to the Service Provider in order to provide the Service. It is your responsibility to maintain the security of your phone and access to the Application. The Service Provider strongly advise against jailbreaking or rooting your phone, which involves removing software restrictions and limitations imposed by the official operating system of your device. Such actions could expose your phone to malware, viruses, malicious programs, compromise your phone\'s security features, and may result in the Application not functioning correctly or at all.\n\n'
              'Please note that the Application utilizes third-party services that have their own Terms and Conditions. Below are the links to the Terms and Conditions of the third-party service providers used by the Application:\n\nGoogle Play Services\n\n'
              'Please be aware that the Service Provider does not assume responsibility for certain aspects. Some functions of the Application require an active internet connection, which can be Wi-Fi or provided by your mobile network provider. The Service Provider cannot be held responsible if the Application does not function at full capacity due to lack of access to Wi-Fi or if you have exhausted your data allowance.\n\n'
              'If you are using the application outside of a Wi-Fi area, please be aware that your mobile network provider\'s agreement terms still apply. Consequently, you may incur charges from your mobile provider for data usage during the connection to the application, or other third-party charges. By using the application, you accept responsibility for any such charges, including roaming data charges if you use the application outside of your home territory (i.e., region or country) without disabling data roaming. If you are not the bill payer for the device on which you are using the application, they assume that you have obtained permission from the bill payer.\n\n'
              'Similarly, the Service Provider cannot always assume responsibility for your usage of the application. For instance, it is your responsibility to ensure that your device remains charged. If your device runs out of battery and you are unable to access the Service, the Service Provider cannot be held responsible.\n\n'
              'In terms of the Service Provider\'s responsibility for your use of the application, it is important to note that while they strive to ensure that it is updated and accurate at all times, they do rely on third parties to provide information to them so that they can make it available to you. The Service Provider accepts no liability for any loss, direct or indirect, that you experience as a result of relying entirely on this functionality of the application.\n\n'
              'The Service Provider may wish to update the application at some point. The application is currently available as per the requirements for the operating system (and for any additional systems they decide to extend the availability of the application to) may change, and you will need to download the updates if you want to continue using the application. The Service Provider does not guarantee that it will always update the application so that it is relevant to you and/or compatible with the particular operating system version installed on your device. However, you agree to always accept updates to the application when offered to you. The Service Provider may also wish to cease providing the application and may terminate its use at any time without providing termination notice to you. Unless they inform you otherwise, upon any termination, (a) the rights and licenses granted to you in these terms will end; (b) you must cease using the application, and (if necessary) delete it from your device.\n\n'
              'Changes to These Terms and Conditions\nThe Service Provider may periodically update their Terms and Conditions. Therefore, you are advised to review this page regularly for any changes. The Service Provider will notify you of any changes by posting the new Terms and Conditions on this page.\n\n'
              'These terms and conditions are effective as of 2025-07-16\n\n'
              'Contact Us\nIf you have any questions or suggestions about the Terms and Conditions, please do not hesitate to contact the Service Provider at authenticheck19@gmail.com.',
              textAlign: TextAlign.justify,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Are you sure?"),
          content: const Text("Do you really want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog only
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMenuItem(String title) {
    return GestureDetector(
      onTap: () {
        if (title == "Logout") {
          _showLogoutConfirmation();
        } else {
          setState(() {
            selectedItem = title;
            isDrawerOpen = false;
          });
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12)),
        ),
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showDownloadSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 60),
              const SizedBox(height: 20),
              const Text(
                "Diploma Downloaded Successfully",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        setState(() {
                          isDrawerOpen = true;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (selectedItem == "Home") ...[
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Welcome!",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.fullName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Welcome to your Authenticheck student dashboard. This portal provides you with secure and easy access to your verified diploma issued by your institution. You can download your diploma anytime and be assured that it’s protected through advanced encryption. Your academic achievement is safe, authentic, and ready whenever you need it — whether for job applications, further studies, or personal records.",
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            "Diploma Details",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text("Name: ${widget.fullName}"),
                        Text("Institution: ${widget.institution}"),
                        Text("Course: ${widget.course}"),
                        Text("Year Graduated: ${widget.yearGraduated}"),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: _termsAccepted ? _showDownloadSuccessDialog : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal.shade700,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Download Diploma",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Terms and Conditions Checkbox OUTSIDE the box
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: _termsAccepted,
                        onChanged: (bool? value) {
                          setState(() {
                            _termsAccepted = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Text('I agree to the '),
                            GestureDetector(
                              onTap: _showTermsDialog,
                              child: const Text(
                                'Terms and Conditions',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ] else if (selectedItem == "Access History") ...[
                  const Center(
                    child: Text(
                      "Access History",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 150,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Search',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Table(
                    border: TableBorder.all(),
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(3),
                      2: FlexColumnWidth(2),
                    },
                    children: const [
                      TableRow(
                        decoration: BoxDecoration(color: Colors.grey),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Employer', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Action', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(''),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(''),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(''),
                          ),
                        ],
                      ),
                    ],
                  ),
                ] else if (selectedItem == "Profile") ...[
                  Expanded(
                    child: SingleChildScrollView(child: ProfileContent(userEmail: widget.userEmail, fullName: widget.fullName)),
                  ),
                ],
              ],
            ),
          ),
          if (isDrawerOpen)
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              width: 250,
              child: Container(
                color: Colors.grey.shade300,
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isDrawerOpen = false;
                          });
                        },
                        child: const Icon(Icons.close, size: 24),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildMenuItem("Home"),
                    _buildMenuItem("Access History"),
                    _buildMenuItem("Profile"),
                    _buildMenuItem("Logout"),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

