import 'package:flutter/material.dart';
import 'package:alsaif_gallery/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutScreen extends StatefulWidget {
  final int? initialStep;

  const CheckoutScreen({Key? key, this.initialStep}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late int _currentStep;
  bool _isLoggedIn = false;
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStep ?? 0;
    _checkLoginState();
  }

  Future<void> _checkLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      // If logged in and initial step is 0, move to address stage
      if (_isLoggedIn && _currentStep == 0) {
        _currentStep = 1;
      }
    });
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _onStepContinue() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep += 1;
      });
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Image.asset('assets/favlog.png', height: 115),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 19.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _buildAlignedStep(0, 'Login', Alignment.centerLeft),
                      Expanded(
                        child: Transform.translate(
                          offset: Offset(3, -11), // Move line upward
                          child: Divider(
                            color: _currentStep >= 1 ? Colors.red : Colors.grey,
                            thickness: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      _buildAlignedStep(1, 'Address', Alignment.center),
                      Expanded(
                        child: Transform.translate(
                          offset:
                              Offset(-4, -11), // Move line upward (keep this)
                          child: Divider(
                            color: _currentStep >= 2 ? Colors.red : Colors.grey,
                            thickness: 1,
                            endIndent: 0, // Remove right-side indent
                            indent: 0, // Remove left-side indent
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildAlignedStep(2, 'Payment', Alignment.centerRight),
              ],
            ),
          ),
          Expanded(
            child: _buildStepContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildAlignedStep(int stepIndex, String title, Alignment alignment) {
    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: null, // Remove the onTap handler to prevent stage changes
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 31,
                  height: 31,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 11,
                  backgroundColor: _currentStep == stepIndex
                      ? const Color.fromARGB(255, 184, 23, 11)
                      : Colors.white,
                  child: Text(
                    '${stepIndex + 1}',
                    style: TextStyle(
                        color: _currentStep == stepIndex
                            ? Colors.white
                            : Colors.grey),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                color: _currentStep == stepIndex ? Colors.black : Colors.grey,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        if (_currentStep == 0 && !_isLoggedIn) {
          return LoginScreen(hideAppBar: true); // Hide app bar when in checkout
        }
        setState(() {
          _currentStep = 1; // Skip to address step
        });
        return Container(); // Temporary container while state updates
      case 1:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delivery Address',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  hintText: 'Enter your delivery address',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentStep = 2; // Move to payment step
                  });
                },
                child: Text('Continue to Payment'),
              ),
            ],
          ),
        );
      case 2:
        return Center(
          child: Text('Payment Step'),
        );
      default:
        return Container();
    }
  }
}
