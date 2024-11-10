import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final bool isPhoneRegistration; // Determine if the user registered with phone
  final String? email; // Pass the email if registered via email
  final String? phone; // Pass the phone if registered via phone

  const ProfileScreen(
      {super.key, this.isPhoneRegistration = true, this.email, this.phone});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String selectedGender = '';
  DateTime? birthDate;

  @override
  void initState() {
    super.initState();
    // Initialize email and phone based on the registration type
    if (widget.isPhoneRegistration && widget.phone != null) {
      phoneController.text = widget.phone!;
    } else if (!widget.isPhoneRegistration && widget.email != null) {
      emailController.text = widget.email!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/favlog.png',
          height: 120,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // First Name Field
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              // Last Name Field
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              // Phone Number Field (shown if registered via email)
              if (!widget.isPhoneRegistration) ...[
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
              ],

              // Email Field (shown if registered via phone)
              if (widget.isPhoneRegistration) ...[
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
              ],

              // Gender Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _genderOption('Male', Icons.male),
                  SizedBox(width: 20),
                  _genderOption('Female', Icons.female),
                ],
              ),
              SizedBox(height: 16),

              // Birthdate Field
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: birthDate == null
                            ? 'Birthdate'
                            : "${birthDate!.day}/${birthDate!.month}/${birthDate!.year}",
                        border: OutlineInputBorder(),
                      ),
                      onTap: _selectBirthdate,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

              // Confirm Button
              ElevatedButton(
                onPressed: _confirmProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Confirm',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _genderOption(String gender, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = gender;
        });
      },
      child: CircleAvatar(
        radius: 40,
        backgroundColor:
            selectedGender == gender ? Colors.red : Colors.grey[200],
        child: Icon(
          icon,
          color: selectedGender == gender ? Colors.white : Colors.black,
          size: 40,
        ),
      ),
    );
  }

  // Method to open date picker for birthdate
  void _selectBirthdate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    setState(() {
      birthDate = picked;
    });
  }

  // Confirm button logic
  void _confirmProfile() {
    String firstName = firstNameController.text.trim();
    String lastName = lastNameController.text.trim();
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        selectedGender.isEmpty ||
        birthDate == null) {
      // Show an error or a validation message
      print('Please fill all the fields');
      return;
    }

    // You can now use these values to save the user's profile information
    print(
        'Profile confirmed: $firstName, $lastName, $email, $phone, $selectedGender, $birthDate');
  }
}
