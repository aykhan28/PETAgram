import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:petagram/models/user_model.dart';
import 'package:flutter/material.dart';

class AccountController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Rx<UserModel?> userModel = Rx<UserModel?>(null);
  RxBool isLoading = false.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  /// Firestore'dan Kullanıcı Bilgilerini Al ve Güncelle
  Future<void> loadUserData() async {
    isLoading.value = true;
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception("User not logged in.");
      }

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists && userDoc.data() != null) {
        userModel.value =
            UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
        _updateTextControllers();
      } else {
        throw Exception("User data not found in Firestore.");
      }
    } catch (e) {
      print("🔥 Error loading user data: $e");
      Get.snackbar('Error', 'Failed to load user data: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void _updateTextControllers() {
    if (userModel.value != null) {
      nameController.text = userModel.value!.name;
      emailController.text = userModel.value!.email;
      phoneController.text = userModel.value!.phone;
    }
  }

  /// Kullanıcı Bilgilerini Güncelle (Firestore ve Auth)
  Future<void> updateUserInfo(
      String name, String email, String phone, String currentPassword) async {
    if (_auth.currentUser == null) return;

    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: _auth.currentUser!.email!,
        password: currentPassword,
      );
      await _auth.currentUser!.reauthenticateWithCredential(credential);

      await _auth.currentUser!.updateDisplayName(name);

      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'name': name,
        'phone': phone,
      });

      await loadUserData();
      Get.snackbar('Success', 'Your information has been updated.');
    } catch (e) {
      print("🔥 Error updating user info: $e");
      Get.snackbar('Error', 'An error occurred while updating your info.');
    }
  }

  /// Şifre Güncelleme
  Future<void> updatePassword(String oldPassword, String newPassword) async {
    if (_auth.currentUser == null) return;

    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: _auth.currentUser!.email!,
        password: oldPassword,
      );
      await _auth.currentUser!.reauthenticateWithCredential(credential);

      if (newPassword.length < 6) {
        Get.snackbar('Error', 'Password must be at least 6 characters.');
        return;
      }

      await _auth.currentUser!.updatePassword(newPassword);
      Get.snackbar('Success', 'Password updated successfully.');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        Get.snackbar('Error', 'Incorrect old password.');
      } else if (e.code == 'weak-password') {
        Get.snackbar('Error', 'New password is too weak.');
      } else {
        Get.snackbar('Error', 'Failed to update password.');
      }
    }
  }

  /// Profil Fotoğrafını Güncelle
  Future<void> updateProfilePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    File imageFile = File(pickedFile.path);
    String ext = pickedFile.path.split('.').last;
    String filePath = 'profile_pictures/${_auth.currentUser!.uid}.$ext';

    try {
      print("📤 Resim Firebase'e yükleniyor: $filePath");

      Reference storageRef = FirebaseStorage.instance.ref(filePath);
      UploadTask uploadTask = storageRef.putFile(imageFile);

      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      if (snapshot.state == TaskState.success) {
        String downloadUrl = await snapshot.ref.getDownloadURL();

        await _auth.currentUser!.updatePhotoURL(downloadUrl);
        await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .update({'photoURL': downloadUrl});

        await loadUserData();
        Get.snackbar('Success', 'Profile picture updated!');
      } else {
        throw Exception("Upload failed.");
      }
    } catch (e) {
      print("🔥 Error uploading image: $e");
      Get.snackbar('Error', 'Failed to upload image: ${e.toString()}');
    }
  }

  /// Kullanıcı Çıkış Yapma
  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed('/login');
  }

  /// Hesabı Silme
  Future<void> deleteAccount(String password) async {
    if (_auth.currentUser == null) return;

    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: _auth.currentUser!.email!,
        password: password,
      );
      await _auth.currentUser!.reauthenticateWithCredential(credential);

      await _firestore.collection('users').doc(_auth.currentUser!.uid).delete();

      try {
        await _storage
            .ref('profile_pictures/${_auth.currentUser!.uid}.jpg')
            .delete();
      } catch (e) {
        print('Profile picture not found or already deleted.');
      }

      await _auth.currentUser!.delete();

      Get.offAllNamed('/register');
      Get.snackbar('Account Deleted', 'Your account has been deleted.');
    } catch (e) {
      print("🔥 Error deleting account: $e");
      Get.snackbar('Error', 'An error occurred while deleting your account.');
    }
  }
}
