// import 'package:flutter/material.dart';
// import 'dart:async'; // For the splash screen timer
// import 'package:flutter_spinkit/flutter_spinkit.dart'; // Optional: Animated loader

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Splash Screen',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: SplashScreen(),
//     );
//   }
// }

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Timer(Duration(seconds: 3), () {
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => MainScreen()));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blueAccent,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // App Logo
//             Image.asset(
//               'assets/logo.png', // Add your logo in the assets folder
//               height: 150,
//               width: 150,
//             ),
//             SizedBox(height: 20),
//             // App Name or Tagline
//             Text(
//               'Welcome to MyApp',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//             SizedBox(height: 30),
//             // Loading Indicator (Optional)
//             SpinKitWave(
//               color: Colors.white,
//               size: 50.0,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Home Screen')),
//       body: Center(
//         child: Text(
//           'This is the Home Screen!',
//           style: TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }
