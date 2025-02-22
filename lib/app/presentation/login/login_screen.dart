import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:skansapung_presensi/app/presentation/home/home_screen.dart';
import 'package:skansapung_presensi/app/presentation/login/login_notifier.dart';
import 'package:skansapung_presensi/core/helper/global_helper.dart';
import 'package:skansapung_presensi/core/widget/app_widget.dart';

class LoginScreen extends AppWidget<LoginNotifier> {
  LoginNotifier notifier = LoginNotifier();

  @override
  void checkVariableAfterUi(BuildContext context) {
    if (notifier.isLoged) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ));
    }
  }

  @override
  Widget bodyBuild(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Image.asset(
                      'assets/images/logo_sekolah.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Selamat datang kembali 👋',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'di PRESENSI SKANSAPUNG',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 30),
                    // Form fields
                    TextField(
                      key: ValueKey('email-field'),
                      controller: notifier.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email, color: Color.fromRGBO(243, 154, 0, 0.988)),
                        hintText: 'Email Address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onTap: kIsWeb ? () {
                        // Ensure proper focus handling on web
                        FocusScope.of(context).requestFocus(FocusNode());
                      } : null,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      key: ValueKey('password-field'),
                      controller: notifier.passwordController,
                      obscureText: !notifier.isShowPassword,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: Color.fromRGBO(243, 154, 0, 0.988)),
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: IconButton(
                          icon: Icon(
                            notifier.isShowPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Color.fromRGBO(243, 154, 0, 0.988),
                          ),
                          onPressed: _showHidePassword,
                        ),
                      ),
                      onTap: kIsWeb ? () {
                        // Ensure proper focus handling on web
                        FocusScope.of(context).requestFocus(FocusNode());
                      } : null,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Color.fromRGBO(243, 154, 0, 0.988),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _onPressLogin(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(243, 154, 0, 0.988),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Or continue with social account',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/images/google_icon.png',
                        width: 24,
                        height: 24,
                      ),
                      label: Text('Continue with Google'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        side: BorderSide(color: Colors.grey[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppWidget<LoginNotifier>(
      child: (notifier) => WillPopScope(
        onWillPop: () async => false,
        child: bodyBuild(context),
      ),
    );
  }

  _showHidePassword() {
    notifier.isShowPassword = !notifier.isShowPassword;
  }

  _onPressLogin(BuildContext context) async {
    await notifier.login();
    if (notifier.errorMessage.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }
}
