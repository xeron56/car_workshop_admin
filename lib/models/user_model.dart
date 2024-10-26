// lib/models/user_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

/// UserModel represents a user in the system.
class UserModel {
  String id;
  String email;
  String role;
  Timestamp? createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    this.createdAt,
  });

  /// Factory method to create a UserModel from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      role: data['role'] ?? '',
      createdAt: data['createdAt'],
    );
  }

  /// Converts UserModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'role': role,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}
