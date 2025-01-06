import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rxn<User> firebaseUser = Rxn<User>();
  RxString userRole = ''.obs;

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  // Set initial screen based on user's role
  void _setInitialScreen(User? user) async {
    if (user == null) {
      await _showMaterialSnackbar('Please login first', '/login');
    } else {
      await fetchUserRole();
      await _showMaterialSnackbar('Welcome back!', '/home');
    }
  }

  // Fetch the role from Firestore
  Future<void> fetchUserRole() async {
    if (firebaseUser.value != null) {
      try {
        final userDoc = await _firestore
            .collection('users')
            .doc(firebaseUser.value!.uid)
            .get();
        userRole.value = userDoc['role'] ?? 'user'; // Default to 'user'
      } catch (e) {
        await _showMaterialSnackbar('Failed to fetch user role: $e', '/login');
      }
    }
  }

  // Show Material Snackbar and navigate after a delay
  Future<void> _showMaterialSnackbar(String message, String route) async {
    // Show Material Snackbar with the provided message
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Wait for the Snackbar to be visible before navigation
    await Future.delayed(Duration(seconds: 2));

    // Perform the navigation after the delay
    Get.offAllNamed(route);
  }

  // Login Method with Error Handling
  Future<void> login(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        await _showMaterialSnackbar('Email and password cannot be empty.', '/login');
        return;
      }

      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _showMaterialSnackbar('Login successful.', '/home');
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      // Handle specific FirebaseAuthException cases
      if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password.';
      } else if (e.code == 'user-not-found') {
        errorMessage = 'No user found with this email.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email format.';
      } else if (e.code == 'network-request-failed') {
        errorMessage = 'Network error. Please check your connection.';
      } else if (e.code == 'credential-too-old') {
        errorMessage = 'The supplied auth credential is incorrect, malformed, or has expired.';
      } else {
        errorMessage = 'An error occurred: ${e.message}';
      }

      // Show the error message in the Material Snackbar
      await _showMaterialSnackbar(errorMessage, '/login');
    } catch (e) {
      await _showMaterialSnackbar('Unexpected error occurred: $e', '/login');
    }
  }

  // Signup Method with Role Assignment and Error Handling
  Future<void> signup(String email, String password, String role) async {
    try {
      if (email.isEmpty || password.isEmpty || role.isEmpty) {
        await _showMaterialSnackbar('All fields are required.', '/signup');
        return;
      }

      if (!GetUtils.isEmail(email)) {
        await _showMaterialSnackbar('Please enter a valid email.', '/signup');
        return;
      }

      if (password.length < 6) {
        await _showMaterialSnackbar('Password must be at least 6 characters.', '/signup');
        return;
      }

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store the user role in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'role': role,
      });

      await _showMaterialSnackbar('Signup successful.', '/home');
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already in use.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format.';
          break;
        case 'weak-password':
          errorMessage = 'Password is too weak.';
          break;
        default:
          errorMessage = 'An error occurred: ${e.message}';
      }

      await _showMaterialSnackbar(errorMessage, '/signup');
    } catch (e) {
      await _showMaterialSnackbar('Unexpected error occurred: $e', '/signup');
    }
  }

  // Logout Method with Error Handling
  void logout() async {
    try {
      await _auth.signOut();
      await _showMaterialSnackbar('Logout successful.', '/login');
    } catch (e) {
      await _showMaterialSnackbar('Failed to log out: $e', '/login');
    }
  }

  // Method to check if the current user is an admin
  bool get isAdmin {
    return userRole.value == 'admin';
  }

  // Method to change the role of a user (Only admin should have this privilege)
  Future<void> changeUserRole(String userId, String newRole) async {
    if (!isAdmin) {
      await _showMaterialSnackbar('You are not authorized to perform this action.', '/home');
      return;
    }

    try {
      await _firestore.collection('users').doc(userId).update({
        'role': newRole,
      });
      await _showMaterialSnackbar('User role updated successfully.', '/home');
    } catch (e) {
      await _showMaterialSnackbar('Failed to update user role: $e', '/home');
    }
  }
}
