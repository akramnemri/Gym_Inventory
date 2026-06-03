import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/particle_background.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';
import 'theme.dart';
import 'config/api_config.dart';
import 'config/api_client.dart';

class AccountSettingsScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  final int userId;
  
  const AccountSettingsScreen({super.key, required this.userId, required this.user});
  
  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  File? _profileImage;
  String? _profilePictureUrl;
  bool _loading = false;
  bool _fetchingUser = false;
  bool _showPasswordFields = false;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  String? firstNameError,
      lastNameError,
      usernameError,
      phoneError,
      currentPasswordError,
      newPasswordError,
      confirmPasswordError;

  String? _selectedThemeName;

  final Map<AppTheme, String> themeNames = {
    AppTheme.minimalistDark: 'Minimalist Dark Mode',
    AppTheme.industrialGym: 'Industrial Gym Style',
    AppTheme.energeticSport: 'Energetic Sport Theme',
    AppTheme.professionalDashboard: 'Professional Dashboard',
    AppTheme.neoFuturistic: 'Neo-futuristic',
  };

  String _selectedLang = 'en';
  final Map<String, String> languageNames = {
    'en': 'English',
    'fr': 'Français',
    'ar': 'العربية',
  };

  @override
  void initState() {
    super.initState();
    _loadTheme();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUser();
      final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
      _selectedLang = localeProvider.locale?.languageCode ?? 'en';
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeStr = prefs.getString('theme') ?? AppTheme.minimalistDark.name;
      final selectedTheme = AppTheme.values.firstWhere(
        (e) => e.name == themeStr,
        orElse: () => AppTheme.minimalistDark,
      );
      setState(() {
        _selectedThemeName = themeNames[selectedTheme];
      });
    } catch (e, st) {
      print('Error loading theme: $e\n$st');
    }
  }

  Future<void> _changeTheme(String? newName) async {
    if (newName == null || newName == _selectedThemeName) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final newTheme = themeNames.entries.firstWhere((e) => e.value == newName).key;
      await prefs.setString('theme', newTheme.name);
      themeNotifier.value = appThemeData[newTheme]!;
      setState(() {
        _selectedThemeName = newName;
      });
    } catch (e, st) {
      print('Error changing theme: $e\n$st');
    }
  }

  bool _isFieldValid(TextEditingController controller) => controller.text.isNotEmpty;
  bool _isPhoneValid(String phone) => RegExp(r'^\d{8}$').hasMatch(phone);
  bool _isPasswordValid(String password) =>
      password.length >= 8 &&
      RegExp(r'[A-Za-z]').hasMatch(password) &&
      RegExp(r'\d').hasMatch(password);

  Future<void> _fetchUser() async {
    if (_fetchingUser) return;
    setState(() {
      _loading = true;
      _fetchingUser = true;
    });
    try {
      final res = await ApiClient.get('/api/users/${widget.userId}');

      if (res.statusCode == 200) {
        final userData = jsonDecode(res.body);
        if (userData is Map<String, dynamic>) {
          setState(() {
            firstNameController.text = userData['first_name'] ?? '';
            lastNameController.text = userData['last_name'] ?? '';
            usernameController.text = userData['username'] ?? '';
            emailController.text = userData['email'] ?? '';
            phoneController.text = userData['phone'] ?? '';
            if (userData['profile_picture'] != null && userData['profile_picture'].toString().isNotEmpty) {
              _profilePictureUrl = ApiConfig.getUploadUrl(userData['profile_picture']);
            } else {
              _profilePictureUrl = null;
            }
          });
        } else {
          _showError(AppLocalizations.of(context)!.accountSettingsUnexpectedFormat);
        }
      } else {
        _showError('${AppLocalizations.of(context)!.accountSettingsFailedToFetch}: ${res.statusCode}');
      }
    } catch (e, st) {
      print('Error in _fetchUser: $e\n$st');
      _showError(AppLocalizations.of(context)!.accountSettingsErrorFetching);
    } finally {
      if (mounted) setState(() {
        _loading = false;
        _fetchingUser = false;
      });
    }
  }

  Future<void> _updateUser() async {
    try {
      setState(() {
        firstNameError = firstNameController.text.isEmpty ? AppLocalizations.of(context)!.accountSettingsRequired : null;
        lastNameError = lastNameController.text.isEmpty ? AppLocalizations.of(context)!.accountSettingsRequired : null;
        usernameError = usernameController.text.isEmpty ? AppLocalizations.of(context)!.accountSettingsRequired : null;
        phoneError = !_isPhoneValid(phoneController.text.trim()) ? AppLocalizations.of(context)!.accountSettingsInvalidPhone : null;
        
        // Password validation
        if (_showPasswordFields) {
          currentPasswordError = currentPasswordController.text.isEmpty 
              ? AppLocalizations.of(context)!.accountSettingsCurrentPasswordRequired 
              : null;
          
          if (newPasswordController.text.isNotEmpty) {
            if (!_isPasswordValid(newPasswordController.text)) {
              newPasswordError = AppLocalizations.of(context)!.accountSettingsWeakPassword;
            } else {
              newPasswordError = null;
            }
            
            if (newPasswordController.text != confirmPasswordController.text) {
              confirmPasswordError = AppLocalizations.of(context)!.accountSettingsPasswordsDoNotMatch;
            } else {
              confirmPasswordError = null;
            }
          } else {
            newPasswordError = AppLocalizations.of(context)!.accountSettingsNewPasswordRequired;
            confirmPasswordError = null;
          }
        }
      });

      if ([firstNameError, lastNameError, usernameError, phoneError, currentPasswordError, newPasswordError, confirmPasswordError]
          .any((e) => e != null)) return;

      setState(() => _loading = true);

      final Map<String, dynamic> body = {
        'first_name': firstNameController.text.trim(),
        'last_name': lastNameController.text.trim(),
        'username': usernameController.text.trim(),
        'phone': phoneController.text.trim(),
      };

      if (_showPasswordFields && newPasswordController.text.isNotEmpty) {
        body['current_password'] = currentPasswordController.text;
        body['password'] = newPasswordController.text;
      }

      if (_profileImage != null) {
        final bytes = await _profileImage!.readAsBytes();
        body['profile_picture'] = base64Encode(bytes);
      }

      final res = await ApiClient.put(
        '/api/users/${widget.userId}',
        body,
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        if (data['profile_picture'] != null) {
          setState(() {
            _profilePictureUrl = ApiConfig.getUploadUrl(data['profile_picture']);
            _profileImage = null;
          });
        }
        
        // Clear password fields on success
        setState(() {
          currentPasswordController.clear();
          newPasswordController.clear();
          confirmPasswordController.clear();
          _showPasswordFields = false;
        });
        
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(AppLocalizations.of(context)!.accountSettingsUpdateTitle),
            content: Text(data['message'] ?? AppLocalizations.of(context)!.accountSettingsUpdateSuccess),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: Text(AppLocalizations.of(context)!.ok),
              ),
            ],
          ),
        );
      } else {
        final errorMessage = data['message'] ?? AppLocalizations.of(context)!.accountSettingsUpdateFailed;
        final field = data['field'];
        
        // Handle specific field errors
        if (field == 'current_password') {
          setState(() => currentPasswordError = errorMessage);
        } else if (field == 'password') {
          setState(() => newPasswordError = errorMessage);
        } else if (field == 'username') {
          setState(() => usernameError = errorMessage);
        } else {
          _showError(errorMessage);
        }
      }
    } catch (e, st) {
      print('Error in _updateUser: $e\n$st');
      _showError(AppLocalizations.of(context)!.accountSettingsErrorUpdating);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pickProfileImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (picked != null) setState(() {
        _profileImage = File(picked.path);
        _profilePictureUrl = null;
      });
    } catch (e, st) {
      print('Error in _pickProfileImage: $e\n$st');
      _showError(AppLocalizations.of(context)!.accountSettingsErrorPickingImage);
    }
  }

  void _showError(String msg) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  InputDecoration _buildDecoration({
    required String label,
    String? error,
    bool Function()? isValid,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      errorText: error,
      suffixIcon: suffixIcon ?? ((isValid != null && isValid()) 
          ? const Icon(Icons.check_circle, color: Colors.green) 
          : null),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    ImageProvider? avatarImage;
    if (_profileImage != null) {
      avatarImage = FileImage(_profileImage!);
    } else if (_profilePictureUrl != null) {
      avatarImage = NetworkImage(_profilePictureUrl!);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              '/dashboard',
              arguments: {
                'id': widget.userId,
                'type_account': widget.user['type_account'],
                'username': widget.user['username'],
              },
            );
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.accountSettings,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
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
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _pickProfileImage,
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundImage: avatarImage,
                                child: avatarImage == null
                                    ? const Icon(Icons.person, size: 60)
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: firstNameController,
                          decoration: _buildDecoration(
                            label: AppLocalizations.of(context)!.firstName,
                            error: firstNameError,
                            isValid: () => _isFieldValid(firstNameController),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: lastNameController,
                          decoration: _buildDecoration(
                            label: AppLocalizations.of(context)!.lastName,
                            error: lastNameError,
                            isValid: () => _isFieldValid(lastNameController),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: usernameController,
                          decoration: _buildDecoration(
                            label: AppLocalizations.of(context)!.username,
                            error: usernameError,
                            isValid: () => _isFieldValid(usernameController),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: emailController,
                          decoration: _buildDecoration(
                            label: AppLocalizations.of(context)!.email,
                          ),
                          readOnly: true,
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: phoneController,
                          decoration: _buildDecoration(
                            label: AppLocalizations.of(context)!.phone,
                            error: phoneError,
                            isValid: () => _isPhoneValid(phoneController.text.trim()),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Password Change Section
                        InkWell(
                          onTap: () => setState(() => _showPasswordFields = !_showPasswordFields),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.lock_outline,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    AppLocalizations.of(context)!.accountSettingsChangePassword,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Icon(
                                  _showPasswordFields ? Icons.expand_less : Icons.expand_more,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        if (_showPasswordFields) ...[
                          const SizedBox(height: 16),
                          TextField(
                            controller: currentPasswordController,
                            decoration: _buildDecoration(
                              label: AppLocalizations.of(context)!.accountSettingsCurrentPassword,
                              error: currentPasswordError,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureCurrentPassword ? Icons.visibility_off : Icons.visibility,
                                ),
                                onPressed: () => setState(() => _obscureCurrentPassword = !_obscureCurrentPassword),
                              ),
                            ),
                            obscureText: _obscureCurrentPassword,
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: newPasswordController,
                            decoration: _buildDecoration(
                              label: AppLocalizations.of(context)!.accountSettingsNewPassword,
                              error: newPasswordError,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                                ),
                                onPressed: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
                              ),
                            ),
                            obscureText: _obscureNewPassword,
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: confirmPasswordController,
                            decoration: _buildDecoration(
                              label: AppLocalizations.of(context)!.accountSettingsConfirmPassword,
                              error: confirmPasswordError,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                ),
                                onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                              ),
                            ),
                            obscureText: _obscureConfirmPassword,
                          ),
                        ],
                        
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedLang,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.language,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: languageNames.entries
                              .map((entry) => DropdownMenuItem(
                                    value: entry.key,
                                    child: Text(entry.value),
                                  ))
                              .toList(),
                          onChanged: (code) {
                            if (code != null) {
                              setState(() {
                                _selectedLang = code;
                              });
                              localeProvider.setLocale(Locale(code));
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField(
                          value: _selectedThemeName,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.theme,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: themeNames.values
                              .map((name) => DropdownMenuItem(value: name, child: Text(name)))
                              .toList(),
                          onChanged: _changeTheme,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _updateUser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(AppLocalizations.of(context)!.saveChanges),
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
}