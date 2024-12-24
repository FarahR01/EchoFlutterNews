import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:echo_flutter_news/screens/auth/logo.dart';
import 'package:echo_flutter_news/screens/auth/validators.dart';

// Define custom colors
const Color primaryColor = Color(0xFF84A59D);  // Sage green
const Color accentColor = Color(0xFFF7BD5F);   // Golden yellow
const Color backgroundColor = Color(0xFFEFE9AE); // Light yellow

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.toggleAuthScreen});

  final void Function() toggleAuthScreen;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _isLoading = false;
  var _isPassHiden = true;
  var _email = '';
  var _password = '';

  String? _errorMsg;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Logo(),
                  const SizedBox(height: 32),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          TextFormField(
                            validator: validateEmail,
                            controller: _emailController,
                            onSaved: (newValue) {
                              _email = newValue!;
                            },
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.none,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              errorText: _errorMsg,
                              prefixIcon: Icon(Icons.email, color: primaryColor),
                              labelStyle: TextStyle(color: primaryColor),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: primaryColor),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.length < 8) {
                                return 'Password must be at least 8 characters long';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _password = newValue!;
                            },
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            obscureText: _isPassHiden,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              errorText: _errorMsg,
                              prefixIcon: Icon(Icons.lock, color: primaryColor),
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    _isPassHiden = !_isPassHiden;
                                  });
                                },
                                child: Icon(
                                  _isPassHiden ? Icons.visibility : Icons.visibility_off,
                                  color: primaryColor,
                                ),
                              ),
                              labelStyle: TextStyle(color: primaryColor),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: primaryColor),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ))
                        : const Text(
                            'LOG IN',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(height: 24),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Don\'t have an account? ',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text: 'Create',
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.toggleAuthScreen,
                          style: TextStyle(
                            color: accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_isLoading) {
      return;
    }
    setState(() {
      _errorMsg = null;
    });

    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    try {
      setState(() {
        _isLoading = true;
      });

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'invalid-credential') {
          setState(() {
            _errorMsg = 'Invalid Email or Password';
          });
        } else {
          showAlert(e.code);
        }
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void showAlert(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: primaryColor,
      ),
    );
  }
}