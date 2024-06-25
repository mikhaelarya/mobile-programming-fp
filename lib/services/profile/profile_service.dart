// ignore_for_file: unused_field

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_programming_fp/services/auth/auth_service.dart';

class ProfileService {
  final AuthService _authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> fetchProfileImageUrl(String userId) async {
    try {
      final firebase_storage.Reference ref = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child(userId + '.jpg');
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error fetching profile img: $e');
      return null;
    }
  }

  Future<void> uploadProfileImage(File imageFile, String userId) async {
    try {
      final firebase_storage.Reference ref = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child(userId + '.jpg');

      await ref.putFile(imageFile);
      final imageUrl = await ref.getDownloadURL();
      await _authService.saveProfileImageUrl(imageUrl);
      print('Uploaded img url: $imageUrl');
    } catch (e) {
      print('Error uploading img to Firebase Storage: $e');
    }
  }

  Future<void> removeProfileImage(String userId) async {
    try {
      final firebase_storage.Reference ref = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child(userId + '.jpg');

      await ref.delete();
      print('Profile img deleted from storage.');
      await _authService.saveProfileImageUrl('');
    } catch (e) {
      print('Error deleting profile img from Firebase Storage: $e');
    }
  }
}
