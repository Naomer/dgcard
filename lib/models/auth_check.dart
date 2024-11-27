// import 'package:alsaif_gallery/screens/account.dart';
// import 'package:alsaif_gallery/screens/profile_screen.dart';
// import 'package:flutter/material.dart';

// class AuthCheck extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<bool>(
//       future: isLoggedIn(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         } else if (snapshot.hasData && snapshot.data!) {
//           return ProfileScreen();
//         } else {
//           return Account();
//         }
//       },
//     );
//   }
// }
