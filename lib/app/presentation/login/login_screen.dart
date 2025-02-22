import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:skansapung_presensi/app/presentation/home/home_screen.dart';
import 'package:skansapung_presensi/app/presentation/login/login_notifier.dart';
import 'package:skansapung_presensi/core/helper/global_helper.dart';
import 'package:skansapung_presensi/core/widget/app_widget.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginNotifier _notifier;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _notifier = Provider.of<LoginNotifier>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                  Consumer<LoginNotifier>(
                    builder: (context, notifier, child) {
                      return Column(
                        children: [
                          TextFormField(
                            controller: notifier.usernameController,
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
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email address';
                              }
                              if (!value.endsWith('@skansa.com')) {
                                return 'Please use your @skansa.com email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: notifier.passwordController,
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
                                  notifier.isShowPassword ? Icons.visibility_off : Icons.visibility,
                                  color: Color.fromRGBO(243, 154, 0, 0.988),
                                ),
                                onPressed: () => notifier.togglePasswordVisibility(),
                              ),
                            ),
                            obscureText: !notifier.isShowPassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
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
                              onPressed: notifier.isLoading
                                  ? null
                                  : () async {
                                      if (_formKey.currentState!.validate()) {
                                        final success = await notifier.login(
                                          notifier.usernameController.text,
                                          notifier.passwordController.text,
                                        );

                                        if (success) {
                                          Navigator.pushReplacementNamed(context, '/dashboard');
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(notifier.errorMessage),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromRGBO(243, 154, 0, 0.988),
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: notifier.isLoading
                                  ? CircularProgressIndicator(color: Colors.white)
                                  : Text(
                                      'Login',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          if (notifier.errorMessage.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text(
                                notifier.errorMessage,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          SizedBox(height: 24),
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
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
