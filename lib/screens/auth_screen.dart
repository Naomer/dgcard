// import 'package:alsaif_gallery/screens/registration_screen.dart';
// import 'package:flutter/material.dart';
// import 'login_screen.dart';
// import 'registration_screen.dart';

// class AuthScreen extends StatefulWidget {
//   @override
//   _AuthScreenState createState() => _AuthScreenState();
// }

// class _AuthScreenState extends State<AuthScreen> {
//   bool isLoginScreen = true;

//   void toggleScreen() {
//     setState(() {
//       isLoginScreen = !isLoginScreen;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Image.asset(
//           'assets/favlog.png',
//           height: 120,
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           if (isLoginScreen)
//             TextButton(
//               onPressed: () {
//                 // Navigate to HomeScreen
//                 Navigator.pushNamed(context, '/home');
//               },
//               child: Text(
//                 'Skip',
//                 style: TextStyle(color: Colors.red, fontSize: 16),
//               ),
//             ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Show either LoginScreen or RegistrationScreen based on the flag
//             isLoginScreen
//                 ? LoginScreen(toggleScreen: toggleScreen)
//                 : RegistrationScreen(toggleScreen: toggleScreen),
//           ],
//         ),
//       ),
//     );
//   }
// }
