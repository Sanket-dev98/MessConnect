import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { student, messOwner }

class UserProfile {
  final String uid;
  final String email;
  final UserRole role;
  final String? name;
  final String? contactNo;
  final String? messName;
  final String? photoUrl;
  final String? qrData;

  UserProfile({
    required this.uid,
    required this.email,
    required this.role,
    this.name,
    this.contactNo,
    this.messName,
    this.photoUrl,
    this.qrData,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] == 'messOwner' ? UserRole.messOwner : UserRole.student,
      name: map['name'],
      contactNo: map['contactNo'],
      messName: map['messName'],
      photoUrl: map['photoUrl'],
      qrData: map['qrData'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role == UserRole.messOwner ? 'messOwner' : 'student',
      'name': name,
      'contactNo': contactNo,
      'messName': messName,
      'photoUrl': photoUrl,
      'qrData': qrData,
    };
  }

  UserProfile copyWith({
    String? uid,
    String? email,
    UserRole? role,
    String? name,
    String? contactNo,
    String? messName,
    String? photoUrl,
    String? qrData,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      role: role ?? this.role,
      name: name ?? this.name,
      contactNo: contactNo ?? this.contactNo,
      messName: messName ?? this.messName,
      photoUrl: photoUrl ?? this.photoUrl,
      qrData: qrData ?? this.qrData,
    );
  }
}
