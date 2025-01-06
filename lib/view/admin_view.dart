import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/auth_controller.dart';

class AdminView extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return FutureBuilder(
          future: authController.fetchUserRole(),  // Ensure the user role is fetched first
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            // Fetch all users from Firestore
            return StreamBuilder(
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> usersSnapshot) {
                if (usersSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!usersSnapshot.hasData || usersSnapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No users found.'));
                }

                final users = usersSnapshot.data!.docs;

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final userEmail = user['email'] ?? 'No email';
                    final userRole = user['role'] ?? 'user';

                    return ListTile(
                      title: Text(userEmail),
                      subtitle: Text('Role: $userRole'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (authController.isAdmin)
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                _showRoleDialog(context, user.id, userEmail);
                              },
                            ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteUser(user.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      }),
    );
  }

  // Function to show a dialog to change the role of a user
void _showRoleDialog(BuildContext context, String userId, String userEmail) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Declare a reactive variable for selected role using GetX
      var selectedRole = 'user'.obs; // This makes it reactive with GetX

      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Change Role for $userEmail',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select a role:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 10),
              // Use Obx to make the Dropdown reactive
              Obx(() {
                return InputDecorator(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedRole.value,  // Use .value to get the reactive value
                      isExpanded: true,
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                      items: ['user', 'admin'].map((role) {
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        selectedRole.value = newValue!;  // Update reactive variable
                      },
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey,
            ),
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
              backgroundColor: Colors.blue[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Save'),
            onPressed: () {
              // Call the method to change the user role
              authController.changeUserRole(userId, selectedRole.value);
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}




  // Function to delete a user
  void _deleteUser(String userId) {
    FirebaseFirestore.instance.collection('users').doc(userId).delete().then((_) {
      Get.snackbar("Success", "User deleted successfully!", snackPosition: SnackPosition.BOTTOM);
    }).catchError((error) {
      Get.snackbar("Error", "Failed to delete user: $error", snackPosition: SnackPosition.BOTTOM);
    });
  }
}
