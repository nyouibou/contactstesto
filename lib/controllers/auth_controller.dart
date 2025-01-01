import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rxn<User> firebaseUser = Rxn<User>();
  RxString userRole = ''.obs; // Holds the role of the user: 'admin' or 'user'

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  // Set initial screen based on user's role
  void _setInitialScreen(User? user) async {
    if (user == null) {
      Get.offAllNamed('/login');
    } else {
      await fetchUserRole();
      Get.offAllNamed('/home');
    }
  }

  // Fetch the role from Firestore
  Future<void> fetchUserRole() async {
    if (firebaseUser.value != null) {
      final userDoc = await _firestore
          .collection('users')
          .doc(firebaseUser.value!.uid)
          .get();
      userRole.value = userDoc['role'] ?? 'user'; // Default to 'user'
    }
  }

  // Login Method
  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // Signup Method with Role Assignment
  Future<void> signup(String email, String password, String role) async {
    try {
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

      Get.offNamed('/home');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // Logout Method
  void logout() async {
    await _auth.signOut();
    Get.offAllNamed('/login');
  }
}
