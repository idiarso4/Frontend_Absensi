import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:absen_smkn1_punggelan/app/presentation/home/home_screen.dart';
import 'package:absen_smkn1_punggelan/app/presentation/login/login_notifier.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

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
            padding: const EdgeInsets.symmetric(horizontal: 24),
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
                  const SizedBox(height: 20),
                  const Text(
                    'Selamat datang kembali 👋',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'di PRESENSI SKANSAPUNG',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Consumer<LoginNotifier>(
                    builder: (context, notifier, child) {
                      return Column(
                        children: [
                          TextFormField(
                            controller: notifier.emailController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email, color: Color.fromRGBO(243, 154, 0, 0.988)),
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
                                return 'Mohon masukkan email';
                              }
                              if (!value.contains('@')) {
                                return 'Mohon masukkan email yang valid';
                              }
                              if (!value.endsWith('@skansa.com')) {
                                return 'Mohon gunakan email @skansa.com';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: notifier.passwordController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock, color: Color.fromRGBO(243, 154, 0, 0.988)),
                              hintText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  notifier.isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                  color: const Color.fromRGBO(243, 154, 0, 0.988),
                                ),
                                onPressed: () => notifier.togglePasswordVisibility(),
                              ),
                            ),
                            obscureText: !notifier.isPasswordVisible,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Mohon masukkan password';
                              }
                              return null;
                            },
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Lupa Password?',
                                style: TextStyle(
                                  color: Color.fromRGBO(243, 154, 0, 0.988),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: notifier.isLoading
                                  ? null
                                  : () async {
                                      if (_formKey.currentState!.validate()) {
                                        final success = await notifier.login();
                                        if (success) {
                                          if (mounted) {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const HomeScreen(),
                                              ),
                                            );
                                          }
                                        } else if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(notifier.error ?? 'Login gagal'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(243, 154, 0, 0.988),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: notifier.isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
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
