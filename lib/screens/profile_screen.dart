
import 'package:flutter/material.dart';
import 'package:jnjversion01windows/handlers/database_helper.dart';
import 'package:jnjversion01windows/models/user.dart';
import 'package:jnjversion01windows/screens/home_screen.dart';
import 'package:jnjversion01windows/screens/sign_in_screen.dart';
import 'package:jnjversion01windows/utilities/univariable.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<User>(
        future: DatabaseHelper.instance.getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.name.isEmpty) {
            return const Center(child: Text("No user profile found."));
          }

          final user = snapshot.data!;
          final String firstLetter = user.name.isNotEmpty ? user.name[0].toUpperCase() : "?";

          return SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),

                // --- Profile Icon with First Letter ---
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Univariable.primaryColor,
                  child: Text(
                    firstLetter,
                    style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "${user.name} ${user.surname}",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                // --- Profile Details List ---
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _buildDetailItem(Icons.email, "Email", user.email),
                      _buildDetailItem(Icons.phone, "Phone", user.cell),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Univariable.primaryColor,
                        // Matches the 30.0 radius of your input fields
                        borderRadius: BorderRadius.circular(30.0),
                        // Optional: Add a subtle shadow to make it pop
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        "HOME",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2, // Makes the text look more professional
                        ),
                      ),
                    ),
                  ),
                ),
                // --- Logout Button ---
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: GestureDetector(
                    onTap: () {
                      _handleLogout(context, user);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Univariable.primaryColor,
                        // Matches the 30.0 radius of your input fields
                        borderRadius: BorderRadius.circular(30.0),
                        // Optional: Add a subtle shadow to make it pop
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        "LOGOUT",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2, // Makes the text look more professional
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper widget for list items
  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Card(
      elevation: 0,
      color: Colors.grey[100],
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Univariable.accentColor),
        title: Text(label, style: TextStyle(fontSize: 12, color: Univariable.grayColor)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
      ),
    );
  }

  // Logout Logic
  void _handleLogout(BuildContext context, User user) async {
    // We use the ID from the fetched user
    await DatabaseHelper.instance.removeLogout(user.id!);
    // Redirect to sign in and clear the navigation stack
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const SignInScreen()),
            (Route<dynamic> route) => false,
      );
    }
  }

}
