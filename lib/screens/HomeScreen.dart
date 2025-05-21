import 'package:flutter/material.dart';
import 'package:plant_task/helper/generalWidgets/widgets.dart';
import 'package:plant_task/helper/styles/colorsRes.dart';
import 'package:plant_task/helper/utils/constant.dart';
import 'package:plant_task/helper/utils/routeGenerator.dart';
import 'package:plant_task/helper/utils/sessionManager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final String userName = Constant.session.getData(SessionManager.keyUserName);
    return Scaffold(
      appBar: _buildAppBar(userName),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: ColorsRes.appColorWhite,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: ColorsRes.grey,
                          radius: 32,
                          child: Constant.session.isUserLoggedIn()
                              ? Text(
                                  _getInitials(userName),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : defaultImg(height: 48, width: 48, image: "default_user"),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome,",
                                style: TextStyle(
                                  color: ColorsRes.appColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                userName.isNotEmpty ? userName : "Guest",
                                style: TextStyle(
                                  color: ColorsRes.appColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                _buildActionButton(
                  icon: Icons.cloud_upload_rounded,
                  label: "Upload Diagnosis",
                  color: ColorsRes.appColor,
                  onPressed: () {
                    Navigator.pushNamed(context, uploadDiagnosisScreen);
                  },
                ),
                const SizedBox(height: 24),
                _buildActionButton(
                  icon: Icons.history_rounded,
                  label: "View Diagnosis History",
                  color: ColorsRes.appColor.withOpacity(0.9),
                  onPressed: () {
                     Navigator.pushNamed(context, diagnosisHistoryscreen);
                  },
                ),
                const SizedBox(height: 24),
                _buildActionButton(
                  icon: Icons.logout_rounded,
                  label: "Logout",
                  color: Colors.redAccent,
                  onPressed: () {
                    if (Constant.session.isUserLoggedIn()){
                       Constant.session.logoutUser(context);
                    }
                  
                    
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 26),
        label: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 2,
        ),
        onPressed: onPressed,
      ),
    );
  }

  /// Helper function to get initials from a name
  String _getInitials(String name) {
    if (name.isEmpty) return "";
    final parts = name.trim().split(" ");
    final firstLetter = parts.isNotEmpty ? parts[0][0] : "";
    final secondLetter = parts.length > 1 ? parts[1][0] : "";
    return "$firstLetter$secondLetter".toUpperCase();
  }

  /// Builds the AppBar
  AppBar _buildAppBar(String userName) {
    return AppBar(
      
      title: 
          Text(
              "Plant Task",
              style: TextStyle(
                color: ColorsRes.appColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
      centerTitle: true,
      elevation: 0,
      titleSpacing: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Theme.of(context).cardColor,
    );
  }
}
