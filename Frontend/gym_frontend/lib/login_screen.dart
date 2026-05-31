import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/particle_background.dart';
import 'theme.dart';
import 'l10n/app_localizations.dart';
import 'config/api_client.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController userController = TextEditingController(); // email or username
  final TextEditingController passwordController = TextEditingController();
  bool _loading = false;
  bool _rememberMe = false;

  String? userError;
  String? passwordError;

  bool userValid = false;
  bool passwordValid = false;

  bool userChecked = false; // Only true if backend confirmed
  bool passwordChecked = false;

  @override
  void initState() {
    super.initState();
    _loadSavedLogin();
  }

  Future<void> _loadSavedLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUser = prefs.getString("lastUser");

      if (savedUser != null) {
        setState(() {
          userController.text = savedUser;
          _rememberMe = true;
          userValid = true;
        });
      }
    } catch (e, st) {
      print('Error loading saved login: $e\n$st');
    }
  }

  Future<void> _saveLogin(String user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_rememberMe) {
        await prefs.setString("lastUser", user);
      } else {
        await prefs.remove("lastUser");
      }
    } catch (e, st) {
      print('Error saving login: $e\n$st');
    }
  }

  void _validateUser(String value) {
    final loc = AppLocalizations.of(context)!;
    setState(() {
      if (value.isEmpty) {
        userError = loc.fieldCannotBeEmpty;
        userValid = false;
        userChecked = false;
      } else {
        userError = null;
        userValid = true;
        userChecked = false;
      }
    });
  }

  void _validatePassword(String value) {
    final loc = AppLocalizations.of(context)!;
    setState(() {
      if (value.isEmpty) {
        passwordError = loc.passwordCannotBeEmpty;
        passwordValid = false;
        passwordChecked = false;
      } else {
        passwordError = null;
        passwordValid = true;
        passwordChecked = false;
      }
    });
  }

  void login() async {
    final loc = AppLocalizations.of(context)!;
    _validateUser(userController.text);
    _validatePassword(passwordController.text);

    if (!userValid || !passwordValid) return;

    setState(() => _loading = true);

    try {
      final response = await ApiClient.post(
        '/api/auth/login',
        {
          'identifier': userController.text.trim(),
          'password': passwordController.text
        },
      );

      final data = jsonDecode(response.body);
      setState(() => _loading = false);

      if (response.statusCode == 200)  {
        final token = data['token'];
        if (token != null) {
          await ApiClient.saveToken(token);
        }
        await _saveLogin(userController.text.trim());

        setState(() {
          userChecked = true;
          passwordChecked = true;
          userError = null;
          passwordError = null;
        });

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('showWelcome', true);
        Navigator.pushReplacementNamed(context, '/dashboard', arguments: data);
      } else {
        final msg = data['message'] ?? loc.loginFailed;
        if (msg.contains("username") || msg.contains("email")) {
          setState(() {
            userError = msg;
            userValid = false;
            userChecked = false;
          });
        } else if (msg.contains("password")) {
          setState(() {
            passwordError = msg;
            passwordValid = false;
            passwordChecked = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg)),
          );
        }
      }
    } catch (e, st) {
      print('Error in login: $e\n$st');
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.errorConnectingServer)),
      );
    }
  }

  void _forgotPassword() {
    final loc = AppLocalizations.of(context)!;
    final emailController = TextEditingController();
    bool closed = false;
    void safeClose() {
      if (closed) return;
      closed = true;
      emailController.dispose();
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(loc.forgotPassword),
          content: TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: loc.enterRegisteredEmail),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  final response = await ApiClient.post(
                    '/api/auth/forgot-password',
                    {'email': emailController.text.trim()},
                  );

                  final data = jsonDecode(response.body);
                  Navigator.pop(dialogContext);

                  if (response.statusCode == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(data['message'] ?? loc.passwordResetInitiated)),
                    );
                    _showPostEmailInstructionsDialog();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(data['message'] ?? loc.errorPasswordReset)),
                    );
                  }
                } catch (e, st) {
                  print('Error in forgot password: $e\n$st');
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(loc.errorSendingResetRequest)),
                  );
                } finally {
                  safeClose();
                }
              },
              child: Text(loc.send),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                safeClose();
              },
              child: Text(loc.cancel),
            ),
          ],
        );
      },
    );
  }

  void _showPostEmailInstructionsDialog() {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(loc.checkYourEmail),
          content: Text(loc.passwordResetEmailInstructions),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _showManualResetPasswordDialog();
              },
              child: Text(loc.enterToken),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(loc.close),
            ),
          ],
        );
      },
    );
  }

  void _showManualResetPasswordDialog() {
  final loc = AppLocalizations.of(context)!;
  final tokenController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool closed = false;

  void safeDispose() {
    if (closed) return;
    closed = true;
    tokenController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (context, setStateInDialog) {
          // Calculate validation states
          final token = tokenController.text.trim();
          final newPassword = newPasswordController.text;
          final confirmPassword = confirmPasswordController.text;
          
          // Password validation
          final passwordHasMinLength = newPassword.length >= 8;
          final passwordHasNumber = RegExp(r'[0-9]').hasMatch(newPassword);
          final passwordHasLetter = RegExp(r'[a-zA-Z]').hasMatch(newPassword);
          final isPasswordValid = passwordHasMinLength && passwordHasNumber && passwordHasLetter;
          
          // Match validation
          final passwordsMatch = newPassword.isNotEmpty && 
                                 confirmPassword.isNotEmpty && 
                                 newPassword == confirmPassword;
          
          // Overall validation
          final isFormValid = token.isNotEmpty && 
                             isPasswordValid && 
                             passwordsMatch;
          
          // Error messages
          String? passwordError;
          if (newPassword.isNotEmpty && !isPasswordValid) {
            passwordError = loc.passwordRequirements;
          }
          
          String? confirmPasswordError;
          if (confirmPassword.isNotEmpty && newPassword != confirmPassword) {
            confirmPasswordError = loc.passwordsDoNotMatch;
          }

          return AlertDialog(
            title: Text(loc.resetPassword),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(loc.enterTokenAndNewPassword),
                  const SizedBox(height: 16),
                  TextField(
                    controller: tokenController,
                    decoration: InputDecoration(
                      labelText: loc.resetTokenFromEmail,
                      border: const OutlineInputBorder(),
                      helperText: 'Enter the token from your email',
                    ),
                    onChanged: (value) => setStateInDialog(() {}),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: loc.newPassword,
                      errorText: passwordError,
                      border: const OutlineInputBorder(),
                      helperText: 'Min 8 chars with letters and numbers',
                    ),
                    onChanged: (value) => setStateInDialog(() {}),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: loc.confirmNewPassword,
                      errorText: confirmPasswordError,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) => setStateInDialog(() {}),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(loc.cancel),
                onPressed: () {
                  Navigator.pop(dialogContext);
                  safeDispose();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFormValid 
                      ? Theme.of(context).colorScheme.primary 
                      : Colors.grey,
                ),
                onPressed: isFormValid
                    ? () async {
                        try {
                      final response = await ApiClient.post(
                        '/api/auth/reset-password',
                        {
                          'token': token,
                          'newPassword': newPassword,
                        },
                      );

                          final data = jsonDecode(response.body);
                          Navigator.pop(dialogContext);

                          if (response.statusCode == 200) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(data['message'] ?? loc.passwordResetSuccess),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(data['message'] ?? loc.passwordResetFailed),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } catch (e, st) {
                          print('Error resetting password: $e\n$st');
                          Navigator.pop(dialogContext);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(loc.errorConnectingServer),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } finally {
                          safeDispose();
                        }
                      }
                    : null,
                child: Text(loc.resetPassword),
              ),
            ],
          );
        },
      );
    },
  );
}

  Widget _buildUserField() {
    final loc = AppLocalizations.of(context)!;
    return TextFormField(
      controller: userController,
      decoration: InputDecoration(
        labelText: loc.usernameOrEmail,
        errorText: userError,
        suffixIcon: userChecked
            ? Icon(Icons.check_circle, color: Colors.green)
            : (userError != null ? Icon(Icons.error, color: Colors.red) : null),
      ),
      onChanged: _validateUser,
    );
  }

  Widget _buildPasswordField() {
    final loc = AppLocalizations.of(context)!;
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: loc.password,
        errorText: passwordError,
        suffixIcon: passwordChecked
            ? Icon(Icons.check_circle, color: Colors.green)
            : (passwordError != null ? Icon(Icons.error, color: Colors.red) : null),
      ),
      onChanged: _validatePassword,
    );
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
                  Text(loc.inventoryLogin, style: TextStyle(fontSize: 32)),
                  SizedBox(height: 24),
                  _buildUserField(),
                  SizedBox(height: 12),
                  _buildPasswordField(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (val) => setState(() => _rememberMe = val ?? false),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Text(loc.rememberMe, softWrap: true),
                      ),
                      Spacer(),
                      Expanded(
                        child: TextButton(
                          onPressed: _forgotPassword, 
                          child: Text(loc.forgotPassword, softWrap: true),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(_loading ? loc.loggingIn : loc.login),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        loc.noAccount,
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/signup'),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          loc.signUpHere,
                          style: TextStyle(color: Theme.of(context).colorScheme.primary),
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