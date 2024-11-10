import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  // Mock function to simulate password reset logic
  Future<void> _sendPasswordResetEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Start loading spinner
      });

      // Simulating a network call for password reset
      await Future.delayed(Duration(seconds: 2)); // Simulate delay

      // You would typically send the password reset request here
      // For demonstration, we assume it's successful
      // You can replace this with your actual logic

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Password reset link has been sent to ${_emailController.text}',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Clear the email field after success
      _emailController.clear();

      setState(() {
        _isLoading = false; // Stop loading spinner
      });
    } else {
      setState(() {
        _isLoading = false; // Stop loading spinner if validation fails
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.grey,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black), // Back arrow color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Enter your email and we\'ll send you a password reset link.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              // Email TextFormField
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),

              // Send Reset Link Button
              _isLoading
                  ? CircularProgressIndicator() // Show spinner when loading
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      onPressed: _sendPasswordResetEmail,
                      child: Text('Send Reset Link'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController
        .dispose(); // Clean up the controller when the widget is disposed
    super.dispose();
  }
}
