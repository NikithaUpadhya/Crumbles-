import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crumbles/data/repositories/authencation/formatter.dart';

class UserModel {
  final String id;
  String firstName;
  String lastName;
  String username;
  final String email;
  String phoneNumber;
  String profilePicture;
  final String userType; 
  String? ngoName; 
  String? ngoType; 
  String? ngoDescription; 

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
    required this.userType, 
    this.ngoName, 
    this.ngoType, 
    this.ngoDescription, 
  });

  String get fullName => '$firstName $lastName';
  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);

  static List<String> nameParts(String fullName) => fullName.split(' ');

  static String generateUsername(String fullName) {
    List<String> nameParts = fullName.split(' ');
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : '';

    String camelCaseUsername = '$firstName$lastName';
    String usernameWithPrefix = 'cwt_$camelCaseUsername';
    return usernameWithPrefix;
  }

  static UserModel empty() => UserModel(
    id: '', 
    firstName: '', 
    lastName: '', 
    username: '', 
    email: '', 
    phoneNumber: '', 
    profilePicture: '', 
    userType: '', 
    ngoName: null, 
    ngoType: null, 
    ngoDescription: null, 
  );

  Map<String, dynamic> toJson() {
    return {
      'FirstName': firstName,
      'LastName': lastName,
      'Username': username,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture,
      'UserType': userType, // Add userType field
      'NgoName': ngoName, // Add ngoName field
      'NgoType': ngoType, // Add ngoType field
      'NgoDescription': ngoDescription, // Add ngoDescription field
    };
  }

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() == null) {
      return empty();
    }
    final data = document.data()!;
    return UserModel(
      id: document.id,
      firstName: data['FirstName'] ?? '',
      lastName: data['LastName'] ?? '',
      username: data['Username'] ?? '',
      email: data['Email'] ?? '',
      phoneNumber: data['PhoneNumber'] ?? '',
      profilePicture: data['ProfilePicture'] ?? '',
      userType: data['UserType'] ?? '', // Add userType field
      ngoName: data['NgoName'], // Add ngoName field
      ngoType: data['NgoType'], // Add ngoType field
      ngoDescription: data['NgoDescription'], // Add ngoDescription field
    );
  }
}
