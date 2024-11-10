class User {
  final String id;
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final String mobile;
  final String country;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.mobile,
    required this.country,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userName: json['userName'],
      email: json['email'],
      mobile: json['mobile'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'email': email,
      'mobile': mobile,
      'country': country,
    };
  }
}
