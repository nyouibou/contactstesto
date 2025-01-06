// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/auth_controller.dart';

// class LoginView extends StatelessWidget {
//   final AuthController authController = Get.find<AuthController>();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Login',
//           style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
//         ),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Theme.of(context).primaryColor,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: SingleChildScrollView(
//             child: Form(
//               key: _formKey, // Wrap the Form widget
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Header Text
//                   Text(
//                     'Welcome Back!',
//                     style: TextStyle(
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'Please login to continue.',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey[600],
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 40),

//                   // Email TextField with validation
//                   TextFormField(
//                     controller: emailController,
//                     decoration: InputDecoration(
//                       labelText: 'Email',
//                       labelStyle: TextStyle(color: Colors.black54),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(color: Colors.grey),
//                       ),
//                       contentPadding:
//                           EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//                     ),
//                     keyboardType: TextInputType.emailAddress,
//                     style: TextStyle(fontSize: 16),
//                     validator: (value) {
//                       if (value == null || value.trim().isEmpty) {
//                         return 'Email is required';
//                       }
//                       if (!GetUtils.isEmail(value.trim())) {
//                         return 'Enter a valid email address';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 20),

//                   // Password TextField with validation
//                   TextFormField(
//                     controller: passwordController,
//                     decoration: InputDecoration(
//                       labelText: 'Password',
//                       labelStyle: TextStyle(color: Colors.black54),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(color: Colors.grey),
//                       ),
//                       contentPadding:
//                           EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//                     ),
//                     obscureText: true,
//                     style: TextStyle(fontSize: 16),
//                     validator: (value) {
//                       if (value == null || value.trim().isEmpty) {
//                         return 'Password is required';
//                       }
//                       if (value.trim().length < 6) {
//                         return 'Password must be at least 6 characters long';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 30),

//                   // Login Button
//                   ElevatedButton(
//                     onPressed: () {
//                       if (_formKey.currentState!.validate()) {
//                         final email = emailController.text.trim();
//                         final password = passwordController.text.trim();

//                         // Call the login function in the AuthController
//                         authController.login(email, password);

//                         // Show a snackbar while the process is ongoing
//                         Get.snackbar(
//                           'Login',
//                           'Attempting to log you in...',
//                           snackPosition: SnackPosition.BOTTOM,
//                           duration: Duration(seconds: 2),
//                           colorText: Colors.white,
//                         );
//                       } else {
//                         // Show a snackbar for validation error
//                         Get.snackbar(
//                           'Validation Error',
//                           'Please check the form fields and try again.',
//                           snackPosition: SnackPosition.BOTTOM,
//                           duration: Duration(seconds: 2),
//                           colorText: Colors.white,
//                           backgroundColor: Colors.red,
//                         );
//                       }
//                     },
//                     child: Text(
//                       'Login',
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 16),

//                   // Signup Link
//                   GestureDetector(
//                     onTap: () {
//                       Get.toNamed('/signup'); // Navigate to Signup Page
//                     },
//                     child: Text(
//                       'Don\'t have an account? Sign up',
//                       style: TextStyle(
//                         color: Colors.blueAccent,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class LoginView extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey, // Wrap the Form widget
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo

                  const SizedBox(height: 32),

                  // Title
                  const Text(
                    'Log in your account',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Email Input
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'ex: jon.smith@email.com',
                      labelText: 'Email',
                      labelStyle: const TextStyle(color: Colors.black54),
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 16.0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30), // Curved border
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30), // Curved border
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontSize: 16),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email is required';
                      }
                      if (!GetUtils.isEmail(value.trim())) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Password Input
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: '*********',
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Colors.black54),
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 16.0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30), // Curved border
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25), // Curved border
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    obscureText: true,
                    style: const TextStyle(fontSize: 16),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Password is required';
                      }
                      if (value.trim().length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Sign In Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();

                          // Call the login function in the AuthController
                          authController.login(email, password);

                          // Show a snackbar while the process is ongoing
                          Get.snackbar(
                            'Login',
                            'Attempting to log you in...',
                            snackPosition: SnackPosition.BOTTOM,
                            duration: const Duration(seconds: 2),
                            colorText: Colors.white,
                          );
                        } else {
                          // Show a snackbar for validation error
                          Get.snackbar(
                            'Validation Error',
                            'Please check the form fields and try again.',
                            snackPosition: SnackPosition.BOTTOM,
                            duration: const Duration(seconds: 2),
                            colorText: Colors.white,
                            backgroundColor: Colors.red,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0), // Curved button
                        ),
                      ),
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Sign Up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed('/signup'); // Navigate to Signup Page
                        },
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
