import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petagram/controllers/account_controller.dart';

// ignore: must_be_immutable
class AccountScreen extends StatelessWidget {
  final AccountController _accountController = Get.put(AccountController());
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isPasswordSectionVisible = false;

  AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Obx(() => Text(_accountController.userModel.value?.email ?? "My Account"))),
      body: Obx(() {
        if (_accountController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              GestureDetector(
                onTap: _accountController.updateProfilePicture,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _accountController.userModel.value?.photoURL.isNotEmpty == true
                      ? NetworkImage(_accountController.userModel.value!.photoURL)
                      : null,
                  child: _accountController.userModel.value?.photoURL.isEmpty == true
                      ? Icon(Icons.person, size: 50)
                      : null,
                ),
              ),
              SizedBox(height: 20),

              // Ad ve Telefon Bilgisi
              _buildTextField("First Name", Icons.person, _accountController.nameController),
              SizedBox(height: 10),
              _buildTextField("Email", Icons.email, _accountController.emailController, enabled: false),
              SizedBox(height: 10),
              _buildTextField("Phone Number", Icons.phone, _accountController.phoneController),
              SizedBox(height: 10),
              _buildTextField("Current Password", Icons.lock, _currentPasswordController, isPassword: true),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () => _accountController.updateUserInfo(
                  _accountController.nameController.text,
                  _accountController.emailController.text,
                  _accountController.phoneController.text,
                  _currentPasswordController.text,
                ),
                child: Text("Update Info"),
              ),
              SizedBox(height: 30),

              // Şifre Değiştirme Bölümü
              GestureDetector(
                onTap: () {
                  _isPasswordSectionVisible = !_isPasswordSectionVisible;
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Change Password",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                    Icon(
                      _isPasswordSectionVisible ? Icons.expand_less : Icons.expand_more,
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),

              if (_isPasswordSectionVisible) ...[
                _buildTextField("Current Password", Icons.lock, _oldPasswordController, isPassword: true),
                SizedBox(height: 10),
                _buildTextField("New Password", Icons.lock_outline, _newPasswordController, isPassword: true),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _accountController.updatePassword(
                    _oldPasswordController.text,
                    _newPasswordController.text,
                  ),
                  child: Text("Update Password"),
                ),
                SizedBox(height: 30),
              ],

              // Çıkış Yap ve Hesap Silme Butonları
              TextButton(
                onPressed: _accountController.logout,
                child: Text("Logout", style: TextStyle(color: Colors.red, fontSize: 16)),
              ),
              TextButton(
                onPressed: () => _showDeleteAccountDialog(),
                child: Text("Delete Account", style: TextStyle(color: Colors.red, fontSize: 16)),
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _showDeleteAccountDialog() async {
    TextEditingController passwordController = TextEditingController();

    Get.defaultDialog(
      title: "Delete Account",
      content: Column(
        children: [
          Text("Enter your password to confirm account deletion."),
          SizedBox(height: 10),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password",
              prefixIcon: Icon(Icons.lock, color: Colors.red),
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      confirm: ElevatedButton(
        onPressed: () {
          _accountController.deleteAccount(passwordController.text);
          Get.back();
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        child: Text("Delete"),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: Text("Cancel"),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller,
      {bool isPassword = false, bool enabled = true}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.orange),
        border: OutlineInputBorder(),
      ),
    );
  }
}