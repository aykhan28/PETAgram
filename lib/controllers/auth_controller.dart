import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:petagram/models/user_model.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get user => _auth.currentUser;

  /// Kullanıcı Girişi
  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.offAllNamed('/home');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'An error occurred');
    }
  }

  /// Kullanıcı Kaydı ve Firestore'a Kayıt
  Future<void> register(String email, String password, String name) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(email: email, password: password);
      String uid = userCredential.user!.uid;

      UserModel newUser = UserModel(
        uid: uid,
        name: name,
        email: email,
        phone: '',
        photoURL: '',
      );

      await _firestore.collection('users').doc(uid).set(newUser.toMap());

      await userCredential.user!.updateDisplayName(name);

      Get.offAllNamed('/home');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'An error occurred');
    }
  }

  /// Firestore'dan Kullanıcı Bilgilerini Al
  Future<UserModel?> getUserData() async {
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(user?.uid).get();
    if (userDoc.exists) {
      return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
    }
    return null;
  }

  /// Kullanıcı Çıkışı
  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed('/login');
  }

  /// Kullanıcı Hesabını Silme
  Future<void> deleteAccount(String password) async {
    try {
      if (user == null) return;

      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: password,
      );
      await user!.reauthenticateWithCredential(credential);

      await user!.delete();
      await _firestore.collection('users').doc(user!.uid).delete();

      Get.offAllNamed('/register');
      Get.snackbar('Account Deleted', 'Your account has been deleted successfully.');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'An error occurred.');
    }
  }
}