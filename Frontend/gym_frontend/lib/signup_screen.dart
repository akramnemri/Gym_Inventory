import 'package:flutter/material.dart';
import 'dart:convert';
import 'theme.dart';
import 'widgets/particle_background.dart';
import 'l10n/app_localizations.dart';
import 'config/api_client.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController adminCodeController = TextEditingController();

  bool _loading = false;
  String? firstNameError,
      lastNameError,
      usernameError,
      emailError,
      phoneError,
      passwordError;

  bool _isPasswordValid(String password) {
    return password.length >= 8 &&
        RegExp(r'[A-Za-z]').hasMatch(password) &&
        RegExp(r'\d').hasMatch(password);
  }

  bool _isEmailValid(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]{2,8}$');
    return regex.hasMatch(email);
  }

  bool _isPhoneValid(String phone) {
    return RegExp(r'^\d{8}$').hasMatch(phone);
  }

  void signup() async {
    final loc = AppLocalizations.of(context)!;

    setState(() {
      firstNameError =
          firstNameController.text.isEmpty ? loc.requiredField : null;
      lastNameError =
          lastNameController.text.isEmpty ? loc.requiredField : null;
      usernameError =
          usernameController.text.isEmpty ? loc.requiredField : null;
      emailError = !_isEmailValid(emailController.text.trim())
          ? loc.invalidEmail
          : null;
      phoneError = !_isPhoneValid(phoneController.text.trim())
          ? loc.invalidPhone
          : null;
      passwordError = !_isPasswordValid(passwordController.text)
          ? loc.passwordTooWeak
          : null;
    });

    if ([
      firstNameError,
      lastNameError,
      usernameError,
      emailError,
      phoneError,
      passwordError
    ].any((e) => e != null)) return;

    setState(() {
      _loading = true;
    });

    try {
      final response = await ApiClient.post(
        '/api/auth/signup',
        {
          'first_name': firstNameController.text.trim(),
          'last_name': lastNameController.text.trim(),
          'username': usernameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
          'password': passwordController.text,
          'admin_code': adminCodeController.text.trim()
        },
      );

      setState(() {
        _loading = false;
      });

      final data = jsonDecode(response.body);
      final msg = data['message'];

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(loc.signUp),
            content: Text(msg),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context); // back to login
                },
                child: Text(loc.ok),
              )
            ],
          ),
        );
      } else {
        if (msg.contains("username")) {
          setState(() => usernameError = msg);
        } else if (msg.contains("email")) {
          setState(() => emailError = msg);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(msg)));
        }
      }
    } catch (e, st) {
      print('Error in signup: $e\n$st');
      setState(() => _loading = false);
      final loc = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.errorSigningUp)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: ParticleBackground(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AppLogo(withText: true),
                  SizedBox(height: 24),
                  Text(loc.createAccount, style: TextStyle(fontSize: 32)),
                  SizedBox(height: 24),
                  TextField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                      labelText: loc.firstName,
                      errorText: firstNameError,
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      labelText: loc.lastName,
                      errorText: lastNameError,
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: loc.username,
                      errorText: usernameError,
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: loc.email,
                      errorText: emailError,
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: loc.phone,
                      errorText: phoneError,
                      helperText: loc.phoneHelperText,
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: loc.password,
                      errorText: passwordError,
                      helperText: loc.passwordHelperText,
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: adminCodeController,
                    decoration:
                        InputDecoration(labelText: loc.adminCodeOptional),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : signup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(_loading ? loc.creating : loc.createAccount),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        loc.alreadyHaveAccount,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          loc.loginHere,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ],
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
